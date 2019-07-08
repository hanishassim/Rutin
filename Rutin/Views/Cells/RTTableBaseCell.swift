//
//  RTTableBaseCell.swift
//  Rutin
//
//  Created by H on 05/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

class RTTableBaseCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func setupCell() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
