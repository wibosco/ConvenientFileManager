//
//  Media.swift
//  SwiftExample
//
//  Created by William Boles on 12/11/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

enum Location: String {
    case cache
    case documents
    
    static func randomLocation() -> Location {
        let cache = arc4random_uniform(2) == 0
        
        if cache {
            return .cache
        } else {
            return .documents
        }
    }
}

struct Media {
    let name: String
    let location: Location
}
