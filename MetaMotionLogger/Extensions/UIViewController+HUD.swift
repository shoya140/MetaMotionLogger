//
//  UIViewController+HUD.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2019.04.18.
//  Copyright © 2019 shoya140. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showHUD(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissHUD(completion:(() -> Void)? = nil) {
        dismiss(animated: false, completion: completion)
    }
}
