//  NetworkManager.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import UIKit
import Foundation

class NetworkManager {
    
    private static let timeOutIntervalForRequest = 60.0
    private static let timeOutIntervalForResource = 60.0
    
    static let BASE_URL = "https://api.themoviedb.org/3/movie/"
    static let moviePoster = "https://image.tmdb.org/t/p/original/"
    
    fileprivate enum CachePolicy : String {
        case networkOnly           = "Network Only"
        case cacheOnly             = "Cache Only"
        case cacheElseNetwork      = "Cache Else Network"
        case networkElseCache      = "Network Else Cache"
        case reloadRevalidateCache = "Reload Revalidate Cache Data"
    }
    
    fileprivate enum HTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
    }
    
    fileprivate class func getSession(timeOutInterval: Double = timeOutIntervalForRequest) -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeOutInterval
        sessionConfig.timeoutIntervalForResource = timeOutInterval
        let session = URLSession(configuration: sessionConfig)
        return session
    }
    
    fileprivate class func processResponse(data: Data?, response: URLResponse?, responseError: Error?, completion: @escaping (ApiResponse?) -> ()) {
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        
        guard responseError == nil else {
            completion(ApiResponse(message: responseError?.localizedDescription))
            return
        }
        
        guard let responseData = data else {
            completion(ApiResponse(message: NetworkResponse.noData.rawValue))
            return
        }
        
        guard let json = (try? JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
            print("Not containing JSON")
            return
        }
        
        completion(ApiResponse(json))
    }

    fileprivate class func fetchGenericData(urlString: String, paramsBag: NSDictionary? = nil, cachePolicy: CachePolicy = CachePolicy.networkOnly, completion: @escaping (ApiResponse?) -> ()) {
        if Connectivity.isConnectedToInternet {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            guard let url = URL(string: urlString) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = AppController.shared.loggedInUser?.token
            request.allHTTPHeaderFields = headers
            
            if let paramsBag = paramsBag, paramsBag.count > 0 {
                // will be JSON encoded
                let data = try! JSONSerialization.data(withJSONObject: paramsBag, options: JSONSerialization.WritingOptions.prettyPrinted)
                let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
            }
            
            // Network Only
            if cachePolicy == CachePolicy.networkOnly {
                NetworkManager.getDataFromNetwork(urlRequest: request, completion: completion)
            } else if cachePolicy == CachePolicy.cacheOnly { // Cache Only
                NetworkManager.getDataFromCache(urlRequest: request, completion: completion)
            } else if cachePolicy == CachePolicy.cacheElseNetwork { // Cache Else Network
                NetworkManager.getDataFromCacheElseNetwork(urlRequest: request, completion: completion)
            } else if cachePolicy == CachePolicy.networkElseCache { // Network Else Cache
                NetworkManager.getDataFromNetworkElseCache(urlRequest: request, completion: completion)
            } else if cachePolicy == CachePolicy.reloadRevalidateCache { // Revalidate Cache Data
                NetworkManager.revalidateCacheData(urlRequest: request, completion: completion)
            }
        } else {
            completion(ApiResponse(message: NetworkResponse.noInternet.rawValue))
        }
    }
    
}


extension NetworkManager {
    //Network only
    fileprivate class func getDataFromNetwork(urlRequest : URLRequest, completion: @escaping (ApiResponse?) -> ()) {
        getSession().dataTask(with: urlRequest) { (data, response, responseError) in
            NetworkManager.processResponse(data: data, response: response, responseError: responseError, completion: completion)
        }.resume()
    }
    //CacheOnly
    fileprivate class func getDataFromCache(urlRequest : URLRequest , completion: @escaping (ApiResponse?) -> ()) {
        if let cacheResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            guard let json = (try? JSONSerialization.jsonObject(with: cacheResponse.data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                completion(ApiResponse(message: NetworkResponse.noCacheData.rawValue))
                return
            }
            completion(ApiResponse(json))
        } else {
            completion(ApiResponse(message: NetworkResponse.noCacheData.rawValue))
            return
        }
    }
    //CacheElseNetwork
    fileprivate class func getDataFromCacheElseNetwork(urlRequest : URLRequest, completion: @escaping (ApiResponse?) -> ()) {
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        
        if URLCache.shared.cachedResponse(for: urlRequest) != nil {
            NetworkManager.getDataFromCache(urlRequest: urlRequest, completion: completion)
        } else {
            NetworkManager.getDataFromNetwork(urlRequest: urlRequest, completion: completion)
        }
    }
    
    //NetworkElseCache
    fileprivate class func getDataFromNetworkElseCache(urlRequest : URLRequest, completion: @escaping (ApiResponse?) -> ()) {
        getSession().dataTask(with: urlRequest) { (data, response, responseError) in
            if responseError == nil && data != nil  {
                NetworkManager.processResponse(data: data, response: response, responseError: responseError, completion: completion)
            } else {
                NetworkManager.getDataFromCache(urlRequest: urlRequest, completion: completion)
            }
        }.resume()
    }
    
    //RevalidatingCacheData
    fileprivate class func revalidateCacheData(urlRequest : URLRequest, completion: @escaping (ApiResponse?) -> ()) {
        DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        
        if let cacheResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            NetworkManager.getDataFromCache(urlRequest: urlRequest) { (response: ApiResponse?) in
                completion(response)
                
                getSession().dataTask(with: urlRequest) { (data, response, responseError) in
                    
                    guard responseError == nil else {
                        completion(ApiResponse(message: responseError?.localizedDescription))
                        return
                    }
                    
                    guard let serverData = data else {
                        completion(ApiResponse(message: NetworkResponse.noData.rawValue))
                        return
                    }
                    
                    guard let serverString = String(data: serverData, encoding: String.Encoding.utf8) else {
                        print("Not containing JSON")
                        return
                    }
                    
                    let cachedData = cacheResponse.data
                    
                    guard let cachedString = String(data: cachedData, encoding: String.Encoding.utf8) else {
                        print("Not containing JSON")
                        return
                    }
                    
                    if serverString != cachedString {
                        guard let serverJson = (try? JSONSerialization.jsonObject(with: serverData, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                            print("No data")
                            completion(ApiResponse(message: NetworkResponse.noData.rawValue))
                            return
                        }
                        completion(ApiResponse(serverJson))
                    }
                    
                }.resume()
            }
        } else {
            NetworkManager.getDataFromNetwork(urlRequest: urlRequest, completion: completion)
        }
    }
}


extension NetworkManager {
    class func getNowPlayingList(completion: @escaping (_ response: ApiResponse?) -> ()) {
        NetworkManager.fetchGenericData(urlString: NetworkManager.BASE_URL + "now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed") { (response: ApiResponse?) in
            completion(response)
        }
    }
    
    class func getTopRatedList(completion: @escaping (_ response: ApiResponse?) -> ()) {
        NetworkManager.fetchGenericData(urlString: NetworkManager.BASE_URL + "top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed") { (response: ApiResponse?) in
            completion(response)
        }
    }
}
