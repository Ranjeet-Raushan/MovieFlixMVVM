//  NetworkResponse.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "Unfortunately we encountered an error."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case noInternet = "Please check your Internet Connection"
    case noData = "Response returned with no data."
    case noCacheData = "No data found in Cache."
    case unableToDecode = "We could not decode the response."
    case somethingWrong = "Something went wrong please try again."
    case userNameOrPass = "User name or password incorrect."
}
