//
//  NetworkManager.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import Foundation
import Combine

class NetworkingManager {
   
    // 定义两个请求错误的枚举，一个是请求响应错误，一个是未知的错误，并定义了 errorDescription 属性来描述错误信息
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    // 根据 url 进行数据的下载
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        // 进行数据下载，重试次数是 2，
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .retry(2)
            .eraseToAnyPublisher()
    }
    
    // 根据响应的结果以及 statusCode 判断是否数据下载成功，下载成功以后返回下载的数据
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw NetworkingError.badURLResponse(url: url)
              }
        
        // 返回下载的数据
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

