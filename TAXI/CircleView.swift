//
//  CircleView.swift
//  TAXI
//
//  Created by Rkhorenko on 9/20/17.
//  Copyright © 2017 Rkhorenko. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    @IBInspectable var borderColor: UIColor? {
        didSet {
     setupView()
}
    }
 
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = borderColor?.cgColor
        self.clipsToBounds = true
    }

}
