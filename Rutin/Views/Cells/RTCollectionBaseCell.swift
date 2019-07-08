//
//  RTCollectionBaseCell.swift
//  Rutin
//
//  Created by H on 08/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

class RTCollectionBaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() { }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
