//
//  APIClient.swift
//  GoogleCloudSpeechToText-sample
//
//  Created by kazunori.aoki on 2021/12/02.
//

import Foundation

struct APIClient {

    struct ProcessSpeech: APIConfigure {
        typealias ReqEntity = RequestEntity
        typealias ResEntity = ResponseEntity
        static let path = "https://speech.googleapis.com/v1/speech:recognize?key=\(Config.google_api_key)"
    }
}
