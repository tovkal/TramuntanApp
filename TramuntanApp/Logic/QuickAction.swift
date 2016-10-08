//
//  QuickActions.swift
//  TramuntanApp
//
//  Created by Andrés Pizá Bückmann on 13/1/16.
//  Copyright © 2016 Tovkal. All rights reserved.
//

import Foundation

enum QuickAction: String {
    case OpenAR
    case OpenMap
    
    init?(fullIdentifier: String) {
        guard let shortIdentifier = fullIdentifier.components(separatedBy: ".").last else {
            return nil
        }
                
        self.init(rawValue: shortIdentifier)
    }
}
