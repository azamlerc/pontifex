//
//  DeckTests.swift
//  PontifexTests
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

@testable import Pontifex
import XCTest

class DeckTests: XCTestCase {
    var deck: Deck?

    override func setUp() {
        self.deck = Deck()
    }

    override func tearDown() {

    }

    func testCards() {
        XCTAssertEqual(deck!.cards.count, 54)
        for (index, card) in deck!.cards.enumerated() {
            XCTAssertEqual(card.rank, index % 13 + 1)
            switch index + 1 {
            case 1...13: XCTAssertEqual(card.suit, .clubs)
            case 14...26: XCTAssertEqual(card.suit, .diamonds)
            case 27...39: XCTAssertEqual(card.suit, .hearts)
            case 40...52: XCTAssertEqual(card.suit, .spades)
            default: XCTAssertEqual(card.suit, .joker)
            }
        }
    }

    func testDescriptions() {
        let descriptions = ["A♣️", "2♣️", "3♣️", "4♣️", "5♣️", "6♣️", "7♣️", "8♣️", "9♣️", "10♣️", "J♣️", "Q♣️", "K♣️", "A♦️", "2♦️", "3♦️", "4♦️", "5♦️", "6♦️", "7♦️", "8♦️", "9♦️", "10♦️", "J♦️", "Q♦️", "K♦️", "A♥️", "2♥️", "3♥️", "4♥️", "5♥️", "6♥️", "7♥️", "8♥️", "9♥️", "10♥️", "J♥️", "Q♥️", "K♥️", "A♠️", "2♠️", "3♠️", "4♠️", "5♠️", "6♠️", "7♠️", "8♠️", "9♠️", "10♠️", "J♠️", "Q♠️", "K♠️", "A🃏", "B🃏"]
        zip(deck!.cards, descriptions).forEach { card in
            XCTAssertEqual(card.0.description, card.1)
        }
    }

    func testIndex() {
        for index in 1...52 {
            XCTAssertEqual(deck!.cards[index - 1].index, index)
        }
        XCTAssertEqual(deck!.cards[52].index, 53)
        XCTAssertEqual(deck!.cards[53].index, 53) // both jokers are 53
    }

    func testLetters() {
        for (index, letter) in (Alphabet.letters + Alphabet.letters).enumerated() {
            XCTAssertEqual(deck!.cards[index].letter, letter)
        }
        XCTAssertEqual(deck!.cards[52].letter, nil)
        XCTAssertEqual(deck!.cards[53].letter, nil)
    }

     func testIndexOf() {
        let aceOfSpades = deck!.cards[39]
        XCTAssertEqual(aceOfSpades.description, "A♠️")
        XCTAssertEqual(deck!.indexOf(card: aceOfSpades), 39)
        XCTAssertEqual(deck!.indexOf(card: deck!.jokerA), 52)
        XCTAssertEqual(deck!.indexOf(card: deck!.jokerB), 53)
    }

    func testMoveTo() {
        deck!.move(card: deck!.jokerA, to: 8)
        XCTAssertEqual(deck!.cards[8], deck!.jokerA)

        deck!.move(card: deck!.jokerB, to: 21)
        XCTAssertEqual(deck!.cards[21], deck!.jokerB)
    }

    func testMoveCard() {
        deck!.move(card: deck!.cards[0], downBy: 1)
        XCTAssertEqual(deck!.cards[0].description, "2♣️")
        XCTAssertEqual(deck!.cards[1].description, "A♣️")

        deck!.move(card: deck!.cards[26], downBy: 2)
        XCTAssertEqual(deck!.cards[26].description, "2♥️")
        XCTAssertEqual(deck!.cards[27].description, "3♥️")
        XCTAssertEqual(deck!.cards[28].description, "A♥️")
    }

    func testMoveLoop1B() {
        deck!.move(card: deck!.jokerB, downBy: 1)
        XCTAssertEqual(deck!.cards[0].description, "A♣️")
        XCTAssertEqual(deck!.cards[1].description, "B🃏")
        XCTAssertEqual(deck!.cards[2].description, "2♣️")
    }

    func testMoveLoop1A() {
        deck!.move(card: deck!.jokerA, downBy: 1)
        XCTAssertEqual(deck!.cards[51].description, "K♠️")
        XCTAssertEqual(deck!.cards[52].description, "B🃏")
        XCTAssertEqual(deck!.cards[53].description, "A🃏")
    }

    func testMoveLoop2B() {
        deck!.move(card: deck!.jokerB, downBy: 2)
        XCTAssertEqual(deck!.cards[0].description, "A♣️")
        XCTAssertEqual(deck!.cards[1].description, "2♣️")
        XCTAssertEqual(deck!.cards[2].description, "B🃏")
    }

    func testMoveLoop2A() {
        deck!.move(card: deck!.jokerA, downBy: 2)
        XCTAssertEqual(deck!.cards[0].description, "A♣️")
        XCTAssertEqual(deck!.cards[1].description, "A🃏")
        XCTAssertEqual(deck!.cards[2].description, "2♣️")
    }

    func testTripleCut() {
        deck!.move(card: deck!.jokerA, downBy: 4)
        deck!.move(card: deck!.jokerB, downBy: -3)

        XCTAssertEqual(deck!.cards.prefix(5).map { $0.description }, ["A♣️", "2♣️", "3♣️", "A🃏", "4♣️"])
        XCTAssertEqual(deck!.cards.suffix(5).map { $0.description }, ["10♠️", "B🃏", "J♠️", "Q♠️", "K♠️"])

        deck!.tripleCut(card1: deck!.jokerA, card2: deck!.jokerB)

        XCTAssertEqual(deck!.cards.prefix(5).map { $0.description }, ["J♠️", "Q♠️", "K♠️", "A🃏", "4♣️"])
        XCTAssertEqual(deck!.cards.suffix(5).map { $0.description }, ["10♠️", "B🃏", "A♣️", "2♣️", "3♣️"])
    }

    func testCut() {
        let card = deck!.cards[11]
        XCTAssertEqual(card.description, "Q♣️")
        deck!.move(card: card, downBy: 42)
        XCTAssertEqual(deck!.cards.last, card)
        deck!.cut(count: deck!.cards.last!.index)
        XCTAssertEqual(deck!.cards.map { $0.description }, ["A♦️", "2♦️", "3♦️", "4♦️", "5♦️", "6♦️", "7♦️", "8♦️", "9♦️", "10♦️", "J♦️", "Q♦️", "K♦️", "A♥️", "2♥️", "3♥️", "4♥️", "5♥️", "6♥️", "7♥️", "8♥️", "9♥️", "10♥️", "J♥️", "Q♥️", "K♥️", "A♠️", "2♠️", "3♠️", "4♠️", "5♠️", "6♠️", "7♠️", "8♠️", "9♠️", "10♠️", "J♠️", "Q♠️", "K♠️", "A🃏", "B🃏", "A♣️", "2♣️", "3♣️", "4♣️", "5♣️", "6♣️", "7♣️", "8♣️", "9♣️", "10♣️", "J♣️", "K♣️", "Q♣️"])
    }
}
