//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation
//
//struct TriviaQuestion: Decodable {
//  let category: String
//  let question: String
//  let correctAnswer: String
//  let incorrectAnswers: [String]
//}
//
//
//struct TriviaAPIResponse: Decodable {
//    let results: [TriviaQuestion]
//}
struct TriviaQuestion: Decodable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    private enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

struct TriviaAPIResponse: Decodable {
    let results: [TriviaQuestion]
}

class TriviaManager {
    static func fetchTriviaQuestions(amount: Int = 10, completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
            let urlString = "https://opentdb.com/api.php?amount=\(amount)&type=multiple"
            guard let url = URL(string: urlString) else {
                completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil, error ?? NSError(domain: "Data is missing", code: -2, userInfo: nil))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let triviaResponse = try decoder.decode(TriviaAPIResponse.self, from: data)
                    completion(triviaResponse.results, nil)
                } catch {
                    completion(nil, error)
                }
            }
            task.resume()
        }
    
//    private static func parseTriviaQuestions(data: Data) -> [TriviaQuestion]? {
//        do {
//            let decoder = JSONDecoder()
//            let triviaResponse = try decoder.decode(TriviaAPIResponse.self, from: data)
//            return triviaResponse.results
//        } catch {
//            print("Error parsing trivia questions: \(error)")
//            return nil
//        }
//    }
    static func parseTriviaQuestions(data: Data) -> [TriviaQuestion]? {
           do {
               let decoder = JSONDecoder()
               let triviaResponse = try decoder.decode(TriviaAPIResponse.self, from: data)
               return triviaResponse.results
           } catch {
               print("Error parsing trivia questions: \(error)")
               return nil
           }
       }
}
