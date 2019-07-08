//
//  RTDynamicCollectionView.swift
//  Rutin
//
//  Created by H on 08/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import UIKit

class RTDynamicCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
