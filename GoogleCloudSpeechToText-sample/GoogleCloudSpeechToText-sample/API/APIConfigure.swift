//
//  APIConfigure.swift
//  GoogleCloudSpeechToText-sample
//
//  Created by kazunori.aoki on 2021/12/02.
//

import Foundation
import Alamofire

protocol APIConfigure {
    associatedtype ReqEntity: Codable
    associatedtype ResEntity: Codable

    static var path: String { get }
    static func request(params: ReqEntity, headers: HTTPHeaders,
                        completion: @escaping ((Result<ResEntity, Error>) -> ()))
}

extension APIConfigure {

    // Alamofireを使う方法
    static func request(params: ReqEntity, headers: HTTPHeaders,
                                    completion: @escaping ((Result<ResEntity, Error>) -> ())) {
        
        AF.request(Self.path, method: .post, parameters: params, headers: headers).responseJSON { response in

            print("response:", response)
            
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let data = try JSONDecoder().decode(ResEntity.self, from: data)
                        completion(.success(data))
                    } catch {
                        completion(.failure(error))
                    }
                }

            case .failure(let e):
                completion(.failure(e))
            }
        }
    }

    // URLSessionを使う方法
    static func request2(params: Data, completion: @escaping ((Result<ResEntity, Error>) -> ())) {

        var request = URLRequest(url: URL(string: Self.path)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.google_api_key, forHTTPHeaderField: "X-Goog-Api-Key")

        request.httpBody = params

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {

                let res = try? JSONDecoder().decode(ResEntity.self, from: data)
                if let res = res {
                    completion(.success(res))
                } else {
                    completion(.failure(Errors.AllError(e: nil)))
                }
            }
        }

        task.resume()
    }
}
