//
//  crypt.swift
//  Pontifex
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

import Foundation

class Crypt {
    var generator: Generator

    init(generator: Generator) {
        self.generator = generator
    }

    func encrypt(_ string: String) -> String {
        let value = Crypt.encryptable(string)
        let keystream = generator.keystream(length: value.count)
        let result = String(zip(value, keystream).map(+))
        return result
    }

    func decrypt(_ string: String) -> String {
        let value = string.replacingOccurrences(of: " ", with: "")
        let keystream = generator.keystream(length: value.count)
        let result = String(zip(value, keystream).map(-))
        return result
    }

    static func encryptable(_ string: String) -> String {
        var value = string.uppercased()
        for (number, name) in numberNames where value.contains(number) {
            value = value.replacingOccurrences(of: number, with: name)
        }
        value = value.components(separatedBy: CharacterSet.letters.inverted).joined(separator: "")
        while value.count % 5 > 0 {
            value += "X"
        }
        return value
    }

    static let numberNames = ["0": "ZERO", "1": "ONE", "2": "TWO", "3": "THREE",
        "4": "FOUR", "5": "FIVE", "6": "SIX", "7": "SEVEN", "8": "EIGHT", "9": "NINE"
    ]
}
