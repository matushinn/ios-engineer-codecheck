//
//  GithubAPI.swift
//  iOSEngineerCodeCheck
//
//  Created by 大江祥太郎 on 2021/09/04.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

class GitHubAPI {
    private static var task: URLSessionTask?
    
    enum FetchRepositoryError: Error {
        case wrong
        case network
        case parse
    }
    static func fetchRepository(text: String, completionHandler: @escaping (Result<[Repository], FetchRepositoryError>) -> Void) {
        if !text.isEmpty {
            
            let urlString = "https://api.github.com/search/repositories?q=\(text)"
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(FetchRepositoryError.wrong))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
                if err != nil {
                    completionHandler(.failure(FetchRepositoryError.network))
                    return
                }
                
                guard let safeData = data else {return}
                
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(Repositories.self, from: safeData)
                    completionHandler(.success(decodedData.items))
                    
                } catch  {
                    completionHandler(.failure(FetchRepositoryError.parse))
                }
                /*
                if let result = try? jsonStrategyDecoder.decode(Repositories.self, from: date) {
                    completionHandler(.success(result.items))
                } else {
                    completionHandler(.failure(FetchRepositoryError.parse))
                }
 */
            }
            task.resume()
        }
    }
    
    static private var jsonStrategyDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    static func taskCancel() {
        task?.cancel()
    }
}

