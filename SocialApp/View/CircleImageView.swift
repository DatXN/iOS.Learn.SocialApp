//
//  CircleImageView.swift
//  SocialApp
//
//  Created by Nguyễn Xuân Đạt on 2/17/17.
//  Copyright © 2017 Nguyễn Xuân Đạt. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }


}
