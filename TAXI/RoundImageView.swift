//
//  RoundImageView.swift
//  TAXI
//
//  Created by Rkhorenko on 9/20/17.
//  Copyright © 2017 Rkhorenko. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
