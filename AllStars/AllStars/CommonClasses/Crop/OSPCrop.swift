//
//  OSPCrop.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 11/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class OSPCrop: NSObject {

    class func makeRoundView(view : UIView) -> Void {
        
        let maskPathView = UIBezierPath(roundedRect: view.layer.bounds, byRoundingCorners: .AllCorners, cornerRadii: CGSizeMake(view.frame.size.height / 2, view.frame.size.height / 2))
        
        let maskLayerView = CAShapeLayer()
        maskLayerView.frame = view.bounds
        maskLayerView.path = maskPathView.CGPath
        
        view.layer.mask = maskLayerView
    }
}
