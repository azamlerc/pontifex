//
//  GeneratorsTests.swift
//  PontifexTests
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

@testable import Pontifex
import XCTest

class GeneratorsTests: XCTestCase {

    override func setUp() {

    }

    override func tearDown() {

    }

    func testAAAA() {
        let generator = Generator()
        XCTAssertEqual(generator.keystream(length: 5), "AAAAA")
        XCTAssertEqual(generator.keystream(length: 20).blocks(), "AAAAA AAAAA AAAAA AAAAA")
    }

    func testAlphabet() {
        let generator = Alphabet()
        XCTAssertEqual(generator.keystream(length: 5), "ABCDE")
        XCTAssertEqual(generator.keystream(length: 26), Alphabet.letters)
    }

    func testExample() {
        let generator = Example()
        XCTAssertEqual(generator.keystream(length: 10).blocks(), "KDWUP ONOWT")
        XCTAssertEqual(generator.keystream(length: 20).blocks(), "KDWUP ONOWT KDWUP ONOWT")
    }

    func testSolitaire1() {
        let generator = Solitaire(passphrase: nil)
        XCTAssertEqual(generator.keystream(length: 9).map { $0.intValue() }, [4, 23, 10, 24, 8, 25, 18, 6, 4])
    }

    func testSolitaire1b() {
        let generator = Solitaire(passphrase: nil)
        XCTAssertEqual(generator.keystream(length: 10), "DWJXHYRFDG")
    }

    func testSolitaire2() {
        let generator = Solitaire(passphrase: "FOO")
        XCTAssertEqual(generator.keystream(length: 15).map { $0.intValue() }, [8, 19, 7, 25, 20, 9, 8, 22, 6, 17, 5, 26, 17, 12, 22])
    }

    func testSolitaire2b() {
        let generator = Solitaire(passphrase: "FOO")
        XCTAssertEqual(generator.keystream(length: 15), "HSGYTIHVFQEZQLV")
    }
}
