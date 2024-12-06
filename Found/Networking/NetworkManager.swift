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

    private let endpoint = "http://34.145.244.103"//MARK: change this

    func fetchLostPosts(colors: [String], category: String, userID: Int, location: String, name:String, description: String, completion: @escaping ([Post]) -> Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        //parameters
        let parameters:Parameters = [
            "itemName":name,
            "category":category,
            "color":colors,
            "description": description,
            "locationLost":location,
        ]//MARK: change the endpoint
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default) //change these
            .validate()
            .responseDecodable(of: LostResponseData.self, decoder: jsonDecoder) {
                response in switch response.result {
                case .success(let response):
                    completion(response.data)
                case .failure(let error):
                    print("Error in NetworkManager.fetchLostPosts(): \(error)")
                }
            }
    }

    func uploadFoundPost(post: Post, userID: Int, completion: @escaping (Bool) -> Void){
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let parameters:Parameters = [
            "itemName":post.itemName,
            "description":post.description,
            "locationFound":post.locationFound,
            "dropLocation":post.dropLocation,
            "color":post.color,
            "category":post.category,
            "image":post.image,
            "fulfilled":post.fulfilled,
        ]
        
        print(parameters)
        
        AF.request(endpoint+"/api/users/\(userID)/items/", method: .post, parameters: parameters)//MARK: change the endpoint
            .validate()
            .responseDecodable(of:FoundResponseData.self, decoder: jsonDecoder)
            {
                response in
                //handle response
                print(response)
                switch response.result {
                case .success(let response):
                    print("Successfully uploaded post: \(response.data)")
                    completion(true)
                case .failure(let error):
                    print("Error in NetworkManager.uploadPost: \(error.localizedDescription)")
                    
                    completion(false)
                }
            }
    }


}
