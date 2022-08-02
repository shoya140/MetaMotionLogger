//
//  SplitVC.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2022/07/29.
//  Copyright © 2022 shoya140. All rights reserved.
//

import UIKit

class SplitVC: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
