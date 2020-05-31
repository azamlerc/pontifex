//
//  Generators.swift
//  Pontifex
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

import Foundation

class Generator {
    func keystream(length: Int) -> String {
        var stream = ""
        while stream.count < length { stream += next() }
        return String(stream.prefix(length))
    }

    func next() -> String {
        return "A"
    }
}

class Alphabet: Generator {
    static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    override func next() -> String {
        return Alphabet.letters
    }
}

class Example: Generator {
    override func next() -> String {
        return "KDWUPONOWT"
    }
}

class Solitaire: Generator {
    let deck = Deck()
    let shouldMoveJokers = false

    init(passphrase: String?) {
        super.init()

        if let pass = passphrase {
            var phrase = pass.uppercased()
            if shouldMoveJokers {
                phrase = String(phrase.dropLast(2))
            }
            for letter in phrase {
                shuffle()
                deck.cut(count: letter.intValue())
            }
            if shouldMoveJokers {
                moveJokers(phrase: phrase)
            }
        }
    }

    override func next() -> String {
        shuffle()
        let number = deck.cards.first!.number
        guard let letter = deck.cards[number].letter else {
            return next()
        }
        return String(letter)
    }

    func shuffle() {
        deck.move(card: deck.jokerA, downBy: 1)
        deck.move(card: deck.jokerB, downBy: 2)
        deck.tripleCut(card1: deck.jokerA, card2: deck.jokerB)
        deck.cut(count: deck.cards.last!.number)
    }

    // The examples in the book say to use the last two letters of the
    // passphrase to move the jokers, but doesn't actually do it.
    // See explanation in https://www.schneier.com/academic/solitaire/
    func moveJokers(phrase: String) {
        let letterA = phrase.suffix(2).first!
        let letterB = phrase.last!
        deck.move(card: deck.jokerA, to: letterA.intValue())
        deck.move(card: deck.jokerB, to: letterB.intValue())
    }
}
