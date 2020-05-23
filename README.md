# Pontifex

### Introduction

This program implements the Solitaire encryption algorithm as described in the [Appendix](https://www.schneier.com/academic/solitaire/) of _Cryptonomicon_ by Neal Stephenson.

Solitaire is a cyper that can be performed using a deck of playing cards. If two people each have a deck of playing cards in the same order, each can generate a keystream that can be used to encypher and decypher a message. 

### Framework

The code is implemented as a framework with the following files:

- **Crypt** can encrypt and decrypt messages by adding or subtracting a keystream
- **Generators** includes a number of classes that can generate a keystream
    - AAAAA just shifts every letter by one
    - Alphabet makes a keystream of letters in order
    - Example uses an example from the text
    - Solitaire uses a cypher based on a deck of cards, which can be keyed using a passphrase
- **Deck** implements a deck of cards, with functions to perform certain transformations
- **Extensions** to convert between letters and numbers, and add and subtract letters

### Tests

All of the files above are tested as follows:

- **CryptTests** encrypts and decrypts a variety of phrases
- **GeneratorsTests** tests that keystreams are generated correctly
- **DeckTests** tests that the deck of cards can be created and transformed correctly 
- **ExtensionsTests** tests converting between letters and numbers, and adding and subtracting letters

### Examples

All of the examples in the book are implemented as unit tests. 

The plaintext phrase `Do not use PC` can be represented as two blocks of five characters: `DONOT USEPC`. If we use a keystream like `KDWUP ONOWT`, then adding the letters in these strings produces the cyphertext `OSKJJ JGTMW`. Subtracking the same keystream restores the original string.

The book opens with a haiku: 

```
Two tires fly. Two wail.
A bamboo grove, all chopped down.
From it, warring songs.
```

Using the Solitaire algorithm seeded with the passphrase `COMSTOCK`, this can be encrypted to:

```
KTMIO AXAUC KXGAY BQRKD
BLUEP DDJUS HUPGD CABQU
ZSZBN WQSHL YCHRF EYPFZ
DCVMJ
```

Decrypting it using a deck seeded with the same passphrase yields:

```
TWOTI RESFL YTWOW AILAB
AMBOO GROVE ALLCH OPPED
DOWNF ROMIT WARRI NGSON
GSXXX
```

