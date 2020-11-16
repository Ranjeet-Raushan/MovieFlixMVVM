//
//  AppController.swift
//  MovieFlix
//
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.
//

import Foundation

class AppController {
    
    static let shared = AppController()
    
    // if user is saved in our memory then get it from there else try to get user from storage
    var loggedInUser: User?
    
}
