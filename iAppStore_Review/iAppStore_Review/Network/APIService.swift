//
//  APIService.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import Foundation

public struct APIService {
    // 基地址
    let baseURL = "https://itunes.apple.com/"
    
    // 单例
    public static let shared = APIService()
    
    // 解码器，Codable 解码
    let decoder = JSONDecoder()
    
    // 错误枚举：未响应、json 解码失败、网络错误
    public enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
    // 不同请求的 URL 拼接
    public enum Endpoint {
        case topFreeApplications(cid: String, country: String, limit: Int),
             topFreeiPadApplications(cid: String, country: String, limit: Int),
             topPaidApplications(cid: String, country: String, limit: Int),
             topPaidiPadApplications(cid: String, country: String, limit: Int),
             topGrossingApplications(cid: String, country: String, limit: Int),
             topGrossingiPadApplications(cid: String, country: String, limit: Int),
             newApplications(cid: String, country: String, limit: Int),
             newFreeApplications(cid: String, country: String, limit: Int),
             newPaidApplications(cid: String, country: String, limit: Int),
             searchApp(word: String, country: String, limit: Int),
             lookupApp(appid: String, country: String)

        func url() -> String {
            let url = APIService.shared.baseURL
            switch self {
                //https://itunes.apple.com/rss/topfreeapplications/limit=20/genre=6014/json?cc=cn
            case .topFreeApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/topfreeapplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .topFreeiPadApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/topFreeiPadApplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .topPaidApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/topPaidApplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .topPaidiPadApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/topPaidiPadApplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .topGrossingApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/topGrossingApplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .topGrossingiPadApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/topGrossingiPadApplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .newApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/newApplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .newFreeApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/newFreeApplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .newPaidApplications(cid: let cid, country: let country, limit: let limit):
                return url + "rss/newPaidApplications/limit=\(limit)/genre=\(cid)/json?cc=\(country)"
            case .searchApp(word: let word, country: let country, limit: let limit):
                return url + "search?term=\(word)&country=\(country)&limit=\(limit)&entity=software"
            case .lookupApp(appid: let appid, country: let country):
                return url + "\(country)/lookup?id=\(appid)"
            }
        }
    }
    
    // POST 请求
    public func POST<T: Codable>(endpoint: Endpoint,
                         params: [String: String]?,
                         completionHandler: @escaping (Result<T, APIError>) -> Void) {
        // 请求的 URL String
        let queryURL = endpoint.url()
        
        // URL
        guard let url = URL(string: queryURL) else {
            debugPrint("error url: \(queryURL)")
            
            return
        }
        
        // 使用 URLComponents 为了进行参数拼接，有一个 queryItems 属性解析 URL 更方便
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        // 参数拼接
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        
        debugPrint(components.url!)
        
        // request
        var request = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
        
        // 请求方法和请求头
        request.httpMethod = "POST"
        request.setValue("iAppStore/1.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        
        // 构建 Task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                // 如果 data 不存在，则在主线程回调请求未响应
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }
            
            guard error == nil else {
                // 如果 error 不为空，则在主线程回调网络错误原因
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error!)))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // 如果响应 code 不是 200，则在主线程回调未响应
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }
            
            do {
                // Codable 数据解析
                let object = try self.decoder.decode(T.self, from: data)
                
                // 在主线程回调响应成功的对象
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                // 如果 Codable 数据解析失败了，在主线程回调 jsonDecodingError
                DispatchQueue.main.async {
                    #if DEBUG
                    print("JSON Decoding Error: \(error)")
                    #endif
                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            }
        }
        
        // 发起网络请求
        task.resume()
    }
    
    // GET 请求，除了没有请求头和 POST 请求几乎完全一致
    public func GET_JSON(endpoint: Endpoint,
                         params: [String: String]?,
                    completionHandler: @escaping (Result<Dictionary<String, Any>, APIError>) -> Void) {
        let queryURL = endpoint.url()
        var components = URLComponents(url: URL(string: queryURL)!, resolvingAgainstBaseURL: true)!
        
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        
        var request = URLRequest(url: components.url!)
        
        // GET 请求，和 POST 请求相比，没有请求头
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error!)))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let object = json as! Dictionary<String, Any>
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    #if DEBUG
                    print("JSON Decoding Error: \(error)")
                    #endif
                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            }
        }
        
        task.resume()
    }
    
}

