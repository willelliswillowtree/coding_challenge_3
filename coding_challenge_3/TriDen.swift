//
//  TriDen.swift
//  coding_challenge_3
//
//  Created by Will Ellis on 5/21/16.
//  Copyright © 2016 Will Ellis. All rights reserved.
//

import Foundation

let TRI_DEN_MOD_DIVISOR = 1000
struct TriDen {
    static let maxTriDen = TriDen(TRI_DEN_MOD_DIVISOR-1)
    let rawValue:Int
    init() {
        rawValue = 0
    }
    
    init(_ rawValue:Int) {
        assert(0..<TRI_DEN_MOD_DIVISOR ~= rawValue, "Invalid Den value")
        self.rawValue = rawValue
    }
    
    init(_ value:Den) {
        self.init(value.rawValue)
    }
    
    init(_ left:Den, _ center:Den, _ right:Den) {
        self = TriDen(left) << 2 + TriDen(center) << 1 + TriDen(right)
    }
    
    func dens() -> (left:Den, center:Den, right:Den) {
        return (Den((self >> 2).rawValue), Den((self >> 1).rawValue % DEN_MOD_DIVISOR), Den(rawValue % DEN_MOD_DIVISOR))
    }
}

extension TriDen: IntegerLiteralConvertible {
    init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension TriDen: Equatable {}
func ==(left:TriDen, right:TriDen) -> Bool { return left.rawValue == right.rawValue }

func +(left:TriDen, right:TriDen) -> TriDen { return TriDen((left.rawValue + right.rawValue) % TRI_DEN_MOD_DIVISOR) }
func *(left:TriDen, right:TriDen) -> TriDen { return TriDen((left.rawValue * right.rawValue) % TRI_DEN_MOD_DIVISOR) }
func /(left:TriDen, right:TriDen) -> TriDen { return TriDen(left.rawValue / right.rawValue) }
func <<(left:TriDen, right:Int) -> TriDen { return (0..<right).reduce(left) { (result, next) -> TriDen in return result * TriDen(10) } }
func >>(left:TriDen, right:Int) -> TriDen { return (0..<right).reduce(left) { (result, next) -> TriDen in return result / TriDen(10) } }

extension Array {
    subscript(index:TriDen) -> Element {
        get {
            return self[index.rawValue]
        }
        set(newElm) {
            self[index.rawValue] = newElm
        }
    }
}
