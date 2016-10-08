//
//  String+DoubleValue.swift
//  TramuntanApp
//
//  Created by Andrés Pizá on 19/4/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

import Foundation

extension String {
    /**
    Get double from string
    
    - returns: Double value or nil if not a double
    */
    func doubleValue() -> Double? {
        let scanner = Scanner(string: self)
        var double: Double = 0
        
        if scanner.scanDouble(&double) {
            return double
        }
        
        return nil
    }
}
