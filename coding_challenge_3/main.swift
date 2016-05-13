//
//  main.swift
//  coding_challenge_3
//
//  Created by Will Ellis on 5/13/16.
//  Copyright © 2016 Will Ellis. All rights reserved.
//

import Foundation

let ramCount = 10

var ram = Array(count: ramCount, repeatedValue: 0)

var idx = 0
while idx < ramCount, let line = readLine(stripNewline: true) where line.characters.count != 0 {
    guard line.characters.count == 3, let word = Int(line) else {
        exit (1)
    }
    ram[idx] = word
    idx += 1
}



print("Ram: \(ram.map({ "\($0)" }).joinWithSeparator(" "))")