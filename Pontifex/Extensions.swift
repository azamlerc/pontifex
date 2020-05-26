//
//  Extensions.swift
//  Pontifex
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

import Foundation

extension Character {
    func intValue() -> Int {
        return Int(self.asciiValue ?? 64) - 64
    }

    static func + (a: Character, b: Character) -> Character {
        return (a.intValue() + b.intValue()).charValue()
    }

    static func - (a: Character, b: Character) -> Character {
        return (a.intValue() - b.intValue()).charValue()
    }
}

extension Int {
    func charValue() -> Character {
        var value = self
        while value < 1 {
            value += 26
        }
        value = (value - 1) % 26 + 1
        return Character(UnicodeScalar(value + 64)!)
    }

    func times(closure: () -> Void) {
        if self > 0 {
            for _ in 1...self {
                closure()
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension String {
    func blocks() -> String {
        let chunks = Array(self).chunked(into: 5).map { String($0) }
        return chunks.joined(separator: " ")
    }
}
