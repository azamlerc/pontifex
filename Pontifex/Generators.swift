//
//  Generators.swift
//  Pontifex
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

import Foundation

protocol Generator {
    func keystream(length: Int) -> String
}

class AAAAA: Generator {
    func keystream(length: Int) -> String {
        var stream = ""

        for _ in 0..<length {
            stream += "A"
        }

        return stream
    }
}

class Alphabet: Generator {
    func keystream(length: Int) -> String {
        var stream = ""

        for index in 0..<length {
            stream += "\((index % 26 + 1).charValue())"
        }

        return stream
    }
}

class Example: Generator {
    func keystream(length: Int) -> String {
        var stream = ""

        while stream.count < length {
            stream += "KDWUPONOWT"
        }

        return String(stream.prefix(length))
    }
}

class Solitaire: Generator {
    var deck: Deck
    let moveJokers = false

    init(passphrase: String?) {
        self.deck = Deck()

        if let pass = passphrase {
            let phrase = Crypt.encryptable(pass)
            for letter in String(phrase.dropLast(2)) {
                shuffle(letter: letter)
            }
            // The examples in the book say to use the last two letters of the
            // passphrase to move the jokers, but doesn't actually do it.
            // See explanation in https://www.schneier.com/academic/solitaire/
            if moveJokers {
                let letterA = phrase.suffix(2).first!
                let letterB = phrase.last!
                deck.move(card: deck.jokerA, to: letterA.intValue())
                deck.move(card: deck.jokerB, to: letterB.intValue())
            }
        }
    }

    func keystream(length: Int) -> String {
        var stream = ""

        for _ in 0..<length {
            stream += String(play())
        }

        return stream
    }

    func play() -> Character {
        deck.move(card: deck.jokerA, downBy: 1)
        deck.move(card: deck.jokerB, downBy: 2)
        deck.tripleCut(card1: deck.jokerA, card2: deck.jokerB)
        deck.cut(count: deck.cards.last!.index)
        return deck.cards[deck.cards.first!.index].letter ?? play()
    }

    func shuffle(letter: Character) {
        deck.move(card: deck.jokerA, downBy: 1)
        deck.move(card: deck.jokerB, downBy: 2)
        deck.tripleCut(card1: deck.jokerA, card2: deck.jokerB)
        deck.cut(count: deck.cards.last!.index)
        deck.cut(count: letter.intValue())
    }
}
