//
//  TriDenALU.swift
//  coding_challenge_3
//
//  Created by Will Ellis on 5/15/16.
//  Copyright © 2016 Will Ellis. All rights reserved.
//

import Foundation

protocol TriDenALUDelegate: class {
    func didHalt()
    func getValueFromRAMAtAddress(ramAddress:TriDen) -> TriDen
    func writeValue(value:TriDen, toRAMAtAddress ramAddress:TriDen)
    func goTo(instructionInRAMAtAddress ramAddress:TriDen)
}

struct Den: Equatable {
    let rawValue:Int
    
    init() {
        rawValue = 0
    }
    
    init(_ rawValue:Int) {
        assert(0...9 ~= rawValue, "Invalid Den value")
        self.rawValue = rawValue
    }
}
func ==(left:Den, right:Den) -> Bool { return left.rawValue == right.rawValue }

enum CommandType: Int {
    case GoTo = 0
    case Halt
    case Set
    case Sum
    case Multiply
    case SetWithReg
    case SumWithReg
    case MultiplyWithReg
    case SetRegWithRAM
    case WriteRegToRAM
    
    init?(den:Den) {
        self.init(rawValue:den.rawValue)
    }
}

struct TriDen: Equatable {
    static let maxTriDen = 1000
    let rawValue:Int
    init() {
        rawValue = 0
    }
    
    init(_ rawValue:Int) {
        assert(0..<TriDen.maxTriDen ~= rawValue, "Invalid Den value")
        self.rawValue = rawValue
    }
    
    init(_ value:Den) {
        self.init(value.rawValue)
    }
    
    init(_ left:Den, _ center:Den, _ right:Den) {
        rawValue = left.rawValue * 100 + center.rawValue * 10 + right.rawValue
    }
    
    func dens() -> (left:Den, center:Den, right:Den) {
        return (Den(rawValue/100), Den((rawValue/10)%10), Den(rawValue%10))
    }
}
func ==(left:TriDen, right:TriDen) -> Bool { return left.rawValue == right.rawValue }
func +(left:TriDen, right:TriDen) -> TriDen { return TriDen((left.rawValue + right.rawValue) % TriDen.maxTriDen) }
func *(left:TriDen, right:TriDen) -> TriDen { return TriDen((left.rawValue * right.rawValue) % TriDen.maxTriDen) }

extension Array {
    subscript(index:Den) -> Element {
        get {
            return self[index.rawValue]
        }
        set(newElm) {
            self.insert(newElm, atIndex: index.rawValue)
        }
    }
}

class TriDenALU {
    
    var registers:[TriDen] = Array(count: 10, repeatedValue: TriDen())
    private weak var delegate:TriDenALUDelegate!
    
    init(delegate:TriDenALUDelegate) {
        self.delegate = delegate
    }
    
    func execute(instruction:TriDen) {
        let (commandDen, leftDen, rightDen) = instruction.dens()
        guard let command = CommandType(den: commandDen) else { assert(false, "Could not convert Den to CommandType") }
        switch command {
        case .GoTo:
            goTo(instructionInRAMWithAddressAtRegister: leftDen, unlessNonzeroValueAtRegister: rightDen)
        case .Halt:
            halt(leftDen, rightDen)
        case .Set:
            set(valueAtRegister: leftDen, withValue: rightDen)
        case .Sum:
            sumAndSet(valueAtRegister: leftDen, withValue: rightDen)
        case .Multiply:
            multiplyAndSet(valueAtRegister: leftDen, withValue: rightDen)
        case .SetWithReg:
            set(valueAtDestinationRegister: leftDen, withValueAtSourceRegister: rightDen)
        case .SumWithReg:
            sumAndSet(valueAtDestinationRegister: leftDen, withValueAtSourceRegister: rightDen)
        case .MultiplyWithReg:
            multiplyAndSet(valueAtDestinationRegister: leftDen, withValueAtSourceRegister: rightDen)
        case .SetRegWithRAM:
            set(valueAtDestinationRegister: leftDen, withValueInRAMWithAddressAtRegister: rightDen)
        case .WriteRegToRAM:
            write(valueAtSourceRegister: leftDen, toValueInRAMWithAddressAtRegister: rightDen)
        }
    }
    
    
    func goTo(instructionInRAMWithAddressAtRegister destRAMAddressRegIdx:Den, unlessNonzeroValueAtRegister testRegIdx:Den) {
        if registers[testRegIdx] != TriDen(0) {
            delegate.goTo(instructionInRAMAtAddress: registers[destRAMAddressRegIdx])
        }
    }

    func halt(left:Den, _ right:Den) {
        assert(left == Den(0) && right == Den(0), "Malformed halt message")
        delegate.didHalt()
    }
    
    func set(valueAtRegister regIdx:Den, withValue value:Den) {
        registers[regIdx] = TriDen(value)
    }

    func sumAndSet(valueAtRegister regIdx:Den, withValue value:Den) {
        registers[regIdx] = registers[regIdx] + TriDen(value)
    }
    
    func multiplyAndSet(valueAtRegister regIdx:Den, withValue value:Den) {
        registers[regIdx] = registers[regIdx] * TriDen(value)
    }

    func set(valueAtDestinationRegister destRegIdx:Den, withValueAtSourceRegister srcRegIdx:Den) {
        registers[destRegIdx] = registers[srcRegIdx]
    }
    
    func sumAndSet(valueAtDestinationRegister destRegIdx:Den, withValueAtSourceRegister srcRegIdx:Den) {
        registers[destRegIdx] = registers[destRegIdx] + registers[srcRegIdx]
    }
    
    func multiplyAndSet(valueAtDestinationRegister destRegIdx:Den, withValueAtSourceRegister srcRegIdx:Den) {
        registers[destRegIdx] = registers[destRegIdx] * registers[srcRegIdx]
    }
    
    func set(valueAtDestinationRegister destRegIdx:Den, withValueInRAMWithAddressAtRegister srcRAMAddressRegIdx:Den) {
        registers[destRegIdx] = delegate.getValueFromRAMAtAddress(registers[srcRAMAddressRegIdx])
    }
    
    func write(valueAtSourceRegister srcRegIdx:Den, toValueInRAMWithAddressAtRegister destRAMAddressRegIdx:Den) {
        delegate.writeValue(registers[srcRegIdx], toRAMAtAddress: registers[destRAMAddressRegIdx])
    }
    
    
}