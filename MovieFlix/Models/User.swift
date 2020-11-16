//  User.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import Foundation

struct User: Codable {
    var id: Int?
    var fullName: String?
    var profileImage: String?
    var email: String?
    var token: String?
}
