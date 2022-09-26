//
//  RequestEntiry.swift
//  GoogleCloudSpeechToText-sample
//
//  Created by kazunori.aoki on 2021/12/02.
//

import Foundation

struct RequestEntity: Codable {
    let config: RequestConfig
    let audio: RequestAudio
}

struct RequestConfig: Codable {
    let encoding: String
    let sampleRateHertz: Int
    let languageCode: String
    let maxAlternatives: Int
}

struct RequestAudio: Codable {
    let content: String
}
