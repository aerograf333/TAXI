//
//  CenterVCDelegate.swift
//  TAXI
//
//  Created by Rkhorenko on 9/21/17.
//  Copyright © 2017 Rkhorenko. All rights reserved.
//

import UIKit

protocol CenterVCDelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}
