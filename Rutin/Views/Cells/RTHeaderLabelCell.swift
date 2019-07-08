//
//  RTHeaderLabelCell.swift
//  Rutin
//
//  Created by H on 05/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

class RTHeaderLabelCell: RTTableBaseCell {

    lazy var headerLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.init(name: Font.bold, size: 38)
        label.textAlignment = .center
        label.textColor = Color.label.primary
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var headerLabelTopConstraint: NSLayoutConstraint!
    var headerLabelBottomConstraint: NSLayoutConstraint!
    
    override func setupCell() {
        contentView.addSubview(headerLabel)
        
        headerLabelTopConstraint = NSLayoutConstraint(item: headerLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 16)
        headerLabelBottomConstraint = NSLayoutConstraint(item: headerLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -16)
        
        NSLayoutConstraint.activate([
            headerLabelTopConstraint,
            NSLayoutConstraint(item: headerLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: headerLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 32),
            headerLabelBottomConstraint,
            ])
        
        selectionStyle = .none
    }
}
