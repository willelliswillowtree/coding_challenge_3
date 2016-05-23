//
//  main.swift
//  coding_challenge_3
//
//  Created by Will Ellis on 5/13/16.
//  Copyright © 2016 Will Ellis. All rights reserved.
//

import Foundation

var ram:[TriDen] = Array(count: TriDenALUController.ramSize, repeatedValue: TriDen(0))

var idx = 0
while idx < ram.count, let line = readLine(stripNewline: true) where line.characters.count != 0 {
    guard line.characters.count == 3, let word = Int(line) else {
        exit (1)
    }
    ram[idx] = TriDen(word)
    idx += 1
}

let triDenALUController = TriDenALUController(ram: ram)
triDenALUController.execute()
