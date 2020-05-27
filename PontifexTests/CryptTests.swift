//
//  CryptTests.swift
//  PontifexTests
//
//  Created by Andrew Zamler-Carhart on 5/23/20.
//  Copyright © 2020 Andrew Zamler-Carhart. All rights reserved.
//

@testable import Pontifex
import XCTest

class CryptTests: XCTestCase {
    var crypt: Crypt?

    let generators: [String: Generator] = [
        "default": Generator(),
        "alphabet": Alphabet(),
        "example": Example()
    ]

    override func setUp() {
        crypt = Crypt(generator: Generator())
    }

    override func tearDown() {

    }

    let testCases = [
        [
            "plain": "Do not use PC!",
            "encryptable": "DONOT USEPC",
            "default": "EPOPU VTFQD",
            "alphabet": "EQQSY AZMYM",
            "example": "OSKJJ JGTMW"
        ],
        [
            "plain": "Cryptonomicon",
            "encryptable": "CRYPT ONOMI CONXX",
            "default": "DSZQU POPNJ DPOYY",
            "alphabet": "DTBTY UUWVS NAALM",
            "example": "NVVKJ DBDJC NSKSN"
        ],
        [
            "plain": "Neal Stephenson",
            "encryptable": "NEALS TEPHE NSONX",
            "default": "OFBMT UFQIF OTPOY",
            "alphabet": "OGDPX ZLXQO YEBBM",
            "example": "YIXGI ISEEY YWLIN"
        ],
        [
            "plain": "12345",
            "encryptable": "ONETW OTHRE EFOUR FIVEX",
            "default": "POFUX PUISF FGPVS GJWFY",
            "alphabet": "PPHXB UAPAO PRBIG VZNXR",
            "example": "ZRBOM DHWOY PJLPH UWKBR"
        ]
    ]

    func testEncryptable() {
        testCases.forEach { test in
            XCTAssertEqual(Crypt.encryptable(test["plain"]!).blocks(), test["encryptable"]!)
        }
    }

    func testEncrypt() {
        generators.forEach { name, generator in
            crypt!.generator = generator
            testCases.forEach { test in
                XCTAssertEqual(crypt?.encrypt(test["plain"]!).blocks(), test[name])
            }
        }
    }

    func testDecrypt() {
        generators.forEach { name, generator in
            crypt!.generator = generator
            testCases.forEach { test in
                XCTAssertEqual(crypt?.decrypt(test[name]!).blocks(), test["encryptable"])
            }
        }
    }

    func testEncryptDecrypt() {
        generators.forEach { _, generator in
            crypt!.generator = generator
            testCases.forEach { test in
                XCTAssertEqual(crypt?.decrypt((crypt?.encrypt(test["plain"]!))!).blocks(), test["encryptable"])
            }
        }
    }

    func testSolitaire1() {
        crypt!.generator = Solitaire(passphrase: nil)
        XCTAssertEqual(crypt?.encrypt("AAAAA AAAAA").blocks(), "EXKYI ZSGEH")
    }

    func testSolitaire2() {
        crypt!.generator = Solitaire(passphrase: "FOO")
        XCTAssertEqual(crypt?.encrypt("AAAAA AAAAA AAAAA").blocks(), "ITHZU JIWGR FARMW")
    }

    func testSolitaire3() {
        crypt!.generator = Solitaire(passphrase: "CRYPTONOMICON")
        XCTAssertEqual(crypt?.encrypt("SOLITAIRE").blocks(), "KIRAK SFJAN")
    }

    func testSolitaireComplete() {
        crypt!.generator = Solitaire(passphrase: "COMSTOCK")
        let haiku = "Two tires fly. Two wail. A bamboo grove, all chopped down. From it, warring songs."
        let encrypted = crypt!.encrypt(haiku)
        XCTAssertEqual(encrypted.blocks(), "KTMIO AXAUC KXGAY BQRKD BLUEP DDJUS HUPGD CABQU ZSZBN WQSHL YCHRF EYPFZ DCVMJ")

        crypt = Crypt(generator: Solitaire(passphrase: "COMSTOCK"))
        let decrypted = crypt!.decrypt(encrypted)
        XCTAssertEqual(decrypted.blocks(), "TWOTI RESFL YTWOW AILAB AMBOO GROVE ALLCH OPPED DOWNF ROMIT WARRI NGSON GSXXX")
    }
}
