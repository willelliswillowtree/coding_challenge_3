//
//  TriDenALU.swift
//  coding_challenge_3
//
//  Created by Will Ellis on 5/15/16.
//  Copyright © 2016 Will Ellis. All rights reserved.
//

import Foundation

protocol TriDenALUDelegate: class {
    func getValueFromRAMAtAddress(ramAddress:TriDen) -> TriDen
    func writeValue(value:TriDen, toRAMAtAddress ramAddress:TriDen)
    func goTo(instructionInRAMAtAddress ramAddress:TriDen)
}


enum CommandType: Den {
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
}


enum TriDenALUReturnType: TriDen {
    case Ok = 0
    case GoTo
    case Halt
}


class TriDenALU {
    
    var registers:[TriDen] = Array(count: 10, repeatedValue: TriDen())
    weak var delegate:TriDenALUDelegate!
        
    func execute(instruction:TriDen) -> TriDenALUReturnType {
        let (commandDen, leftDen, rightDen) = instruction.dens()
        guard let command = CommandType(rawValue: commandDen) else { assert(false, "Could not convert Den to CommandType") }
        switch command {
        case .GoTo:
            return goTo(instructionInRAMWithAddressAtRegister: leftDen, unlessNonzeroValueAtRegister: rightDen)
        case .Halt:
            return halt(leftDen, rightDen)
        case .Set:
            return set(valueAtRegister: leftDen, withValue: rightDen)
        case .Sum:
            return sumAndSet(valueAtRegister: leftDen, withValue: rightDen)
        case .Multiply:
            return multiplyAndSet(valueAtRegister: leftDen, withValue: rightDen)
        case .SetWithReg:
            return set(valueAtDestinationRegister: leftDen, withValueAtSourceRegister: rightDen)
        case .SumWithReg:
            return sumAndSet(valueAtDestinationRegister: leftDen, withValueAtSourceRegister: rightDen)
        case .MultiplyWithReg:
            return multiplyAndSet(valueAtDestinationRegister: leftDen, withValueAtSourceRegister: rightDen)
        case .SetRegWithRAM:
            return set(valueAtDestinationRegister: leftDen, withValueInRAMWithAddressAtRegister: rightDen)
        case .WriteRegToRAM:
            return write(valueAtSourceRegister: leftDen, toValueInRAMWithAddressAtRegister: rightDen)
        }
    }
    
    
    func goTo(instructionInRAMWithAddressAtRegister destRAMAddressRegIdx:Den, unlessNonzeroValueAtRegister testRegIdx:Den) -> TriDenALUReturnType {
        if registers[testRegIdx] != TriDen(0) {
            delegate.goTo(instructionInRAMAtAddress: registers[destRAMAddressRegIdx])
            return .GoTo
        }
        else {
            return .Ok
        }
    }

    func halt(left:Den, _ right:Den) -> TriDenALUReturnType {
        assert(left == Den(0) && right == Den(0), "Malformed halt message")
        return .Halt
    }
    
    func set(valueAtRegister regIdx:Den, withValue value:Den) -> TriDenALUReturnType {
        registers[regIdx] = TriDen(value)
        return .Ok
    }

    func sumAndSet(valueAtRegister regIdx:Den, withValue value:Den) -> TriDenALUReturnType {
        registers[regIdx] = registers[regIdx] + TriDen(value)
        return .Ok
    }
    
    func multiplyAndSet(valueAtRegister regIdx:Den, withValue value:Den) -> TriDenALUReturnType {
        registers[regIdx] = registers[regIdx] * TriDen(value)
        return .Ok
    }

    func set(valueAtDestinationRegister destRegIdx:Den, withValueAtSourceRegister srcRegIdx:Den) -> TriDenALUReturnType {
        registers[destRegIdx] = registers[srcRegIdx]
        return .Ok
    }
    
    func sumAndSet(valueAtDestinationRegister destRegIdx:Den, withValueAtSourceRegister srcRegIdx:Den) -> TriDenALUReturnType {
        registers[destRegIdx] = registers[destRegIdx] + registers[srcRegIdx]
        return .Ok
    }
    
    func multiplyAndSet(valueAtDestinationRegister destRegIdx:Den, withValueAtSourceRegister srcRegIdx:Den) -> TriDenALUReturnType {
        registers[destRegIdx] = registers[destRegIdx] * registers[srcRegIdx]
        return .Ok
    }
    
    func set(valueAtDestinationRegister destRegIdx:Den, withValueInRAMWithAddressAtRegister srcRAMAddressRegIdx:Den) -> TriDenALUReturnType {
        registers[destRegIdx] = delegate.getValueFromRAMAtAddress(registers[srcRAMAddressRegIdx])
        return .Ok
    }
    
    func write(valueAtSourceRegister srcRegIdx:Den, toValueInRAMWithAddressAtRegister destRAMAddressRegIdx:Den) -> TriDenALUReturnType {
        delegate.writeValue(registers[srcRegIdx], toRAMAtAddress: registers[destRAMAddressRegIdx])
        return .Ok
    }
    
    
}