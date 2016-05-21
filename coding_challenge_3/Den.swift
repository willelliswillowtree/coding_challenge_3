//
//  Den.swift
//  coding_challenge_3
//
//  Created by Will Ellis on 5/21/16.
//  Copyright © 2016 Will Ellis. All rights reserved.
//

import Foundation

let DEN_MOD_DIVISOR = 10

// As in "denary"
struct Den {
    static let maxDen = Den(DEN_MOD_DIVISOR-1)
    let rawValue:Int
    
    init() {
        rawValue = 0
    }
    
    init(_ rawValue:Int) {
        assert(0..<DEN_MOD_DIVISOR ~= rawValue, "Invalid Den value")
        self.rawValue = rawValue
    }
}

extension Den: IntegerLiteralConvertible {
    init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension Den: Equatable {}
func ==(left:Den, right:Den) -> Bool { return left.rawValue == right.rawValue }

extension Array {
    subscript(index:Den) -> Element {
        get {
            return self[index.rawValue]
        }
        set(newElm) {
            self[index.rawValue] = newElm
        }
    }
}
