//
//  BaseApiClient.swift
//
//
//  Created by Miguel Solans on 21/05/2024.
//

import Foundation
import UIKit

/// HTTP verb methods
public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var method: String {
        return self.rawValue
    }
}

/// ApiClient errors
public enum ApiError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case noData
    case decodingError(Error)
}


/// Base class for a ApiClient request
open class BaseApiClient {
    private let urlSession: URLSession;
    
    private var baseURL: String;
    
    private let configuration: ApiClientConfiguration
    
    public init(baseURL: String, configuration: ApiClientConfiguration, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.configuration = configuration
        self.urlSession = session
    }
    
    public func request<T: Codable>(endpoint: String,
                                    method: HttpMethod,
                                    parameters: [String: Any]? = nil,
                                    completion: @escaping (Result<T, ApiError>) -> Void) {
        
        var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)")
        
        if method == .get, let parameters = parameters {
            urlComponents?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        if(!NetworkMonitor.shared.isConnected) {
            self.fetchFromCache(for: endpoint, completion: completion)
            return;
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.method
        request.allHTTPHeaderFields = configuration.getHeaders()
        
        if let parameters = parameters, method != .get {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
        }
        
        self.loadData(with: request, completion: completion);
    }
    
    fileprivate func loadData<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.decodingError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    completion(.failure(.invalidStatusCode(httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    
                    let jsonData = try JSONEncoder().encode(decodedObject)
                    
                    if let jsonString = String(data: jsonData, encoding: .utf8),
                       let url = request.url {
                        
                        self.saveDataToCache(jsonString, for: url.path)
                        print(jsonString)
                    }
                    
                    // self.saveDataToCache(jsonString, for: "");
                    
                    
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }.resume()
    }
    
    func loadImage(for urlString: String, completion: @escaping(Result<UIImage, ApiError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let safeError = error {
                completion(.failure(.decodingError(safeError)))
                return
            }
            
            guard let safeData = data, let image = UIImage(data: safeData) else {
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        
        task.resume()
    }
    
    /// Set base API URL
    /// - Parameter baseURL: String API base URL
    public func setBaseURL(_ baseURL: String) {
        self.baseURL = baseURL
    }
    
}

// MARK: - Offline
extension BaseApiClient {
    
    /**
     * Ideally offline data should be stored using CoreData/SwiftData and not NSUserDefaults, but would require time to setup.
     */
    
    fileprivate func saveDataToCache(_ jsonString: String, for endpoint: String) {
        UserDefaults.standard.set(jsonString, forKey: endpoint)
    }
    
    fileprivate func fetchFromCache<T: Decodable>(for url: String, completion: @escaping (Result<T, ApiError>) -> Void) {
        guard let jsonString = UserDefaults.standard.string(forKey: url) else {
            completion(.failure(.noData))
            return
        }
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            completion(.failure(.decodingError(NSError(domain: "InvalidData", code: -1, userInfo: nil))))
            return
        }
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
            completion(.success(decodedObject))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
}
