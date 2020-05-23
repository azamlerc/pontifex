//
//  ExtensionsTests.swift
//  PontifexTests
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

@testable import Pontifex
import XCTest

class ExtensionsTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func testAdd() {
        XCTAssertEqual(Character("A") + Character("B"), Character("C"))
        XCTAssertEqual(Character("A") + Character("Z"), Character("A"))
    }

    func testSubtract() {
        XCTAssertEqual(Character("C") - Character("B"), Character("A"))
        XCTAssertEqual(Character("A") - Character("A"), Character("Z"))
    }

    func testValues() {
        for (number, letter) in letters.enumerated() {
            XCTAssertEqual(letter.intValue(), number + 1)
            XCTAssertEqual((number + 1).charValue(), letter)
        }
    }
}
