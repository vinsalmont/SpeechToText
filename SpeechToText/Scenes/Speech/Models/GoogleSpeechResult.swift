//
//  GoogleSpeechResult.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import Foundation


struct GoogleSpeechResult: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let alternatives: [Alternatives]
}

struct Alternatives: Decodable {
    let transcript: String
    let confidence: Double
    let words: [WordTimeStamp]?
}

struct WordTimeStamp: Decodable {
    let startTime: String
    let endTime: String
    let word: String
}
