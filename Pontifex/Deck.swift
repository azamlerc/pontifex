//
//  deck.swift
//  Pontifex
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

import Foundation

enum Suit: String {
    case clubs = "♣️"
    case diamonds = "♦️"
    case hearts = "♥️"
    case spades = "♠️"
    case joker = "🃏"

    static var all: [Suit] {
        return [.clubs, .diamonds, .hearts, .spades]
    }
}

class Card: Equatable, CustomStringConvertible {
    let suit: Suit
    let rank: Int

    init(suit: Suit, rank: Int) {
        self.suit = suit
        self.rank = rank
    }

    static func == (a: Card, b: Card) -> Bool {
        return a.rank == b.rank && a.suit == b.suit
    }

    var description: String {
        return "\(self.rankString)\(self.suit.rawValue)"
    }

    var rankString: String {
        if suit == .joker {
            return rank == 1 ? "A" : "B"
        } else {
            switch rank {
            case 1: return "A"
            case 11: return "J"
            case 12: return "Q"
            case 13: return "K"
            default: return "\(rank)"
            }
        }
    }

    var index: Int {
        switch suit {
        case .clubs: return rank
        case .diamonds: return rank + 13
        case .hearts: return rank + 26
        case .spades: return rank + 39
        case .joker: return 53
        }
    }

    var number: Int? {
        switch suit {
        case .clubs, .hearts: return rank
        case .diamonds, .spades: return rank + 13
        case .joker: return nil
        }
    }

    var letter: Character? {
        return self.number?.charValue()
    }
}

class Deck {
    var cards = [Card]()
    let jokerA: Card
    let jokerB: Card

    init() {
        for suit in Suit.all {
            for rank in 1...13 {
                cards.append(Card(suit: suit, rank: rank))
            }
        }
        self.jokerA = Card(suit: .joker, rank: 1)
        self.jokerB = Card(suit: .joker, rank: 2)
        cards.append(contentsOf: [jokerA, jokerB])
    }

    func indexOf(card: Card) -> Int {
        return cards.firstIndex(of: card)!
    }

    func move(card: Card, to index: Int) {
        let oldIndex = indexOf(card: card)
        cards.remove(at: oldIndex)
        cards.insert(card, at: index)
    }

    func move(card: Card, downBy: Int) {
        let index = indexOf(card: card)
        cards.remove(at: index)
        let newIndex = (index + downBy - 1) % cards.count + 1
        cards.insert(card, at: newIndex)
    }

    func cut(count: Int) {
        cards = Array([cards[count..<53],
                       cards[0..<count],
                       cards[53...53]].joined())
    }

    func tripleCut(card1: Card, card2: Card) {
        var index1 = indexOf(card: card1)
        var index2 = indexOf(card: card2)
        if index1 > index2 {
            (index1, index2) = (index2, index1)
        }
        cards = Array([cards[(index2 + 1)..<cards.count],
                       cards[index1...index2],
                       cards[0..<index1]].joined())
    }
}
