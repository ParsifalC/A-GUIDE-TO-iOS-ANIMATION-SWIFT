//
//  ReplicatorLoader.swift
//  ReplicatorLoaderDemo-Swift
//
//  Created by Kitten Yang on 2/3/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

struct Options {
    var color: UIColor
    var alpha: Float = 1.0
}

enum LoaderType {
    case pulse(option: Options)
    case dotsFlip(option: Options)
    case gridScale(option: Options)
    
    var replicatorLayer: Replicatable{
        switch self {
        case .pulse(_):
            return PulseReplicatorLayer()
        case .dotsFlip(_):
            return DotsFlipReplicatorLayer()
        case .gridScale(_):
            return GridReplicatorLayer()
        }
    }
    
}

protocol Replicatable {
    func configureReplicatorLayer(_ layer: CALayer, option: Options)
}

class ReplicatorLoader: UIView {

    init(frame: CGRect, type: LoaderType) {
        super.init(frame: frame)
        setUp(type)
    }
    
    fileprivate func setUp(_ type: LoaderType) {
        switch type {
        case let .pulse(option):
            type.replicatorLayer.configureReplicatorLayer(layer, option: option)
        case let .dotsFlip(option):
            type.replicatorLayer.configureReplicatorLayer(layer, option: option)
        case let .gridScale(option):
            type.replicatorLayer.configureReplicatorLayer(layer, option: option)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
