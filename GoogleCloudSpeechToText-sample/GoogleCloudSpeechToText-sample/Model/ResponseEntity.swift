//
//  ResponseEntity.swift
//  GoogleCloudSpeechToText-sample
//
//  Created by kazunori.aoki on 2021/12/03.
//

import Foundation

struct ResponseEntity: Codable {
    let results: [Results]
    let error: ErrorEntity?
}

struct Results: Codable {
    let alternatives: [Alternatives]
}

struct Alternatives: Codable {
    let transcript: String
}

struct ErrorEntity: Codable {
    let code: Int
    let message: String
    let status: String
}
