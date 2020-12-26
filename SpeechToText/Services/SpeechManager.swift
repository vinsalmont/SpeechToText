//
//  SpeechManager.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import Foundation

class SpeechManager {
    static let shared = SpeechManager()

    private let speechToTextURL = "https://speech.googleapis.com/v1/speech:recognize"
    private let baseURL = "https://texttospeech.googleapis.com/v1beta1/text:synthesize"

    func getSpeech(from text: String, success: @escaping ((String) -> Void), failure: @escaping ((Error) -> Void)) {

    }

    func getText(from speech: Data, success: @escaping (([Alternatives]) -> Void), failure: @escaping (() -> Void)) {
        let urlString = "\(speechToTextURL)?key=\(GoogleCloud.key)"

        guard let url = URL(string: urlString) else {
            failure()
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Bundle.main.bundleIdentifier, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        request.httpMethod = "POST"

        let configParameters: [String : Any] = [
            "encoding": "LINEAR16",
            "sampleRateHertz": 16000,
            "languageCode": "en-US",
            "maxAlternatives": 30,
            "enableWordTimeOffsets": true
        ]

        let audioParameters = ["content": speech.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))]

        let parameters = [
            "config": configParameters,
            "audio": audioParameters
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            failure()
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil,
                  (200 ... 299) ~= response.statusCode else {
                failure()
                return
            }

            do {
                let result = try JSONDecoder().decode(GoogleSpeechResult.self, from: data)
                success(result.results.first!.alternatives)
            } catch {
                failure()
            }

        }.resume()
    }

}
