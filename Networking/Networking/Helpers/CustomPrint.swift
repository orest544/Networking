//
//  CustomPrint.swift
//  Networking
//
//  Created by Orest Patlyka on 3/12/19.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import Foundation

/// Optimized performance
public func print(_ items: Any...) {
    #if DEBUG
    Swift.print(items[0])
    #endif
}
