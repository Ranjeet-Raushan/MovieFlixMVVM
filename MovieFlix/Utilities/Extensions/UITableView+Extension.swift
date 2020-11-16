//  UITableView+Extension.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import Foundation
import UIKit

extension UITableViewCell {
    static func identifier() -> String {
        return (String(describing: self))
    }
}

extension UICollectionViewCell {
    static func identifier() -> String {
        return (String(describing: self))
    }
}
