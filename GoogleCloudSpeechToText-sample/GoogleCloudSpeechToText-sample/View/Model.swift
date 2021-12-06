//
//  Model.swift
//  GoogleCloudSpeechToText-sample
//
//  Created by kazunori.aoki on 2021/12/03.
//

import Foundation
import Alamofire

class Model {

    // Alamofireを使う
    @MainActor
    func request(soundFilePath: URL) async throws -> [Results] {

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        let config = RequestConfig(encoding: "LINEAR16",
                                   samleRateHertz: 16000,
                                   languageCode: "ja-JP",
                                   maxAlternatives: 30)

        guard let audioData = NSData(contentsOf: soundFilePath) else {
            throw(NSError(domain: "data not found", code: 0, userInfo: nil))
        }

        let audio = RequestAudio(content: audioData.base64EncodedString())
        let request = RequestEntity(config: config, audio: audio)

        return try await withCheckedThrowingContinuation({ continuation in
            APIClient.ProcessSpeech.request(params: request, headers: headers) { response in

                print("result:", response)

                switch response {
                case .success(let result):
                    continuation.resume(returning: result.results)

                case .failure(let e):
                    print(e.localizedDescription)
                    continuation.resume(throwing: e)
                }
            }
        })
    }

    @MainActor
    func request2(soundFilePath: URL) async throws -> Results {

        guard let audioData = NSData(contentsOf: soundFilePath) else {
            throw(NSError(domain: "data not found", code: 0, userInfo: nil))
        }

        let config: [String: Any] = [
            "encoding": "LINEAR16",
            "sampleRateHertz": 16000,
            "languageCode":"ja-JP",
            "maxAlternatives": 30,
        ]

        let audio = audioData.base64EncodedString()

        let request: [String: Any] = [
            "config": config,
            "audio": [
                "content": audio,
            ]
        ]

        let params = try JSONSerialization.data(withJSONObject: request)

        return try await withCheckedThrowingContinuation({ continuation in
            APIClient.ProcessSpeech.request2(params: params) { response in

                print("result:", response)

                switch response {
                case .success(let result):
                    if let res = result.results.first {
                        continuation.resume(returning: res)
                    } else {
                        continuation.resume(throwing: Errors.AllError(e: nil))
                    }

                case .failure(let e):
                    print(e.localizedDescription)
                    continuation.resume(throwing: e)
                }
            }
        })
    }
}

