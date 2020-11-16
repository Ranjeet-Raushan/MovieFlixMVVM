//  BaseViewController.swift
//  MovieFlix
//  Created by Ranjeet Raushan on 22/06/2020.
//  Copyright © 2020 Ranjeet Raushan. All rights reserved.

import UIKit

class BaseViewController: UIViewController {
    
    private var progressHUD: ProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showProgressHUD(text: String = "Loading") {
        DispatchQueue.main.async {
            if let progressHUD = self.progressHUD {
                progressHUD.removeFromSuperview()
                self.progressHUD = nil
            }
            
            self.view.isUserInteractionEnabled = false
            self.progressHUD = ProgressHUD(text: text)
            self.view.addSubview(self.progressHUD!)
        }
    }
    
    func hideProgressHUD() {
        DispatchQueue.main.async {
            guard let progressHUD = self.progressHUD else { return }
            
            self.view.isUserInteractionEnabled = true
            progressHUD.removeFromSuperview()
            self.progressHUD = nil
        }
    }
}
