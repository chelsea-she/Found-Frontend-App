//
//  NetworkManager.swift
//  Found
//
//  Created by Ryan Ye on 11/24/24.
//

import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init(){}

    private let endpoint = "http://34.145.244.103"

    func fetchPosts(colors: [String], category: String, userID: String, location: String, description: String, completion: @escaping ([Post]) -> Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        //parameters
        let parameters:Parameters = [
            :
        ]
        AF.request(endpoint, method: .get, parameters: parameters, encoding: JSONEncoding.default) //change these
            .validate()
            .responseDecodable(of: [Post].self, decoder: jsonDecoder) {
                posts in switch posts.result {
                case .success(let posts):
                    completion(posts)
                case .failure(let error):
                    print("Error in NetworkManager.fetchPosts(): \(error)")
                }
            }
    }

    func uploadPost(post: Post, completion: @escaping (Bool) -> Void){
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let parameters:Parameters = [
            :
        ]
        AF.request(endpoint, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of:Post.self, decoder: jsonDecoder)
            {
                response in
                //handle response
                //print(response)
                switch response.result {
                case .success(let post):
                    print("Successfully uploaded post: \(post)")
                    completion(true)
                case .failure(let error):
                    print("Error in NetworkManager.uploadPost: \(error.localizedDescription)")
                    completion(false)
                }
            }
    }


}
