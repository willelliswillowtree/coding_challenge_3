//
//  TriDenALUController.swift
//  coding_challenge_3
//
//  Created by Will Ellis on 5/21/16.
//  Copyright © 2016 Will Ellis. All rights reserved.
//

import Foundation

class TriDenALUController {
    static let ramSize = TRI_DEN_MOD_DIVISOR
    private let triDenALU:TriDenALU = TriDenALU()
    private var ram:[TriDen]
    private var currentInstructionIdx = TriDen(0)
    private var goToInstructionIdx = TriDen(0)
    
    init(ram:[TriDen]) {
        assert(ram.count >= TriDenALUController.ramSize, "RAM Size is too small")
        self.ram = ram
        triDenALU.delegate = self
    }
    
    func execute() {
        var operationCount = 0
        var output = TriDenALUReturnType.Ok
        repeat {
            output = triDenALU.execute(ram[currentInstructionIdx])
            operationCount += 1
            currentInstructionIdx = (output == .GoTo ? goToInstructionIdx : currentInstructionIdx+1)
        } while output != .Halt
        print(operationCount)
        print("Registers: \(triDenALU.registers.map({ String(format: "%03d", arguments: [$0.rawValue]) }).joinWithSeparator(" "))")
    }
}

extension TriDenALUController: TriDenALUDelegate {
    func getValueFromRAMAtAddress(ramAddress:TriDen) -> TriDen {
        return ram[ramAddress]
    }
    
    func writeValue(value:TriDen, toRAMAtAddress ramAddress:TriDen) {
        ram[ramAddress] = value
    }
    
    func goTo(instructionInRAMAtAddress ramAddress:TriDen) {
        goToInstructionIdx = ramAddress
    }
}
