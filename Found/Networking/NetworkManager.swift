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

    //MARK: upload lost post - needs testing
    func fetchLostPosts(colors: String, category: String, userID: Int, location: String, name:String, description: String, completion: @escaping (Bool, [Post]) -> Void) {
        let jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZZZZZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        //parameters
        let parameters:Parameters = [
            "item_name":name,
            "category":category,
            "color":colors,
            "description": description,
            "location_lost":location,
        ]//MARK: change the endpoint
        AF.request(endpoint+"/api/lost-request/\(userID)/", method: .post, parameters: parameters, encoding: JSONEncoding.default) //change these
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LostResponseData.self, decoder: jsonDecoder) {
                response in
                print(response)
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw Response JSON: \(jsonString)")
                } else {
                    print("No response body or data was empty.")
                }
                
                switch response.result {
                case .success(let response):
                    completion(true, response.data)
                case .failure(let error):
                    print("Error in NetworkManager.fetchLostPosts(): \(error)")
                    completion(false,[])
                }
            }
    }

    //MARK: upload foudn post
    func uploadFoundPost(post: Post, completion: @escaping (Bool) -> Void){
        let jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZZZZZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let parameters:Parameters = [
            "item_name":post.itemName,
            "description":post.description,
            "location_found":post.locationFound,
            "drop_location":post.dropLocation,
            "color":post.color,
            "category":post.category,
            "image":post.image,
            "fulfilled":post.fulfilled,
        ]
        
        print(parameters)
        let urlString = "\(endpoint)/api/users/\(String(post.id))/items/"
        print(urlString)
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)//MARK: change the endpoint
            .validate(statusCode: 200..<300)
            .responseDecodable(of:FoundResponseData.self, decoder: jsonDecoder)
            {
                response in
                //handle response
                print(response)
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw Response JSON: \(jsonString)")
                } else {
                    print("No response body or data was empty.")
                }
                
                switch response.result {
                case .success(let response):
                    print(response)
                    print("Successfully uploaded post: \(response.data)")
                    completion(true)
                case .failure(let error):
                    print("Error in NetworkManager.uploadPost: \(error.localizedDescription)")
                    
                    completion(false)
                }
            }
    }
    //MARK: create new user
    func createNewUser(profileImage: String, username: String, bio: String, email: String, phone: String, licenseApprove: Bool, completion: @escaping (Bool, AppUser?) -> Void) {
        let jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZZZZZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        //parameters
        let parameters:Parameters = [
            "profile_image":profileImage,
            "username":username,
            "bio":bio,
            "email":email,
            "phone":phone,
            "license_approve":licenseApprove
        ]//MARK: change the endpoint
        AF.request(endpoint+"/api/users/", method: .post, parameters: parameters, encoding: JSONEncoding.default) //change these
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AppUserReturn.self, decoder: jsonDecoder) {
                response in
                print(response)
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw Response JSON: \(jsonString)")
                } else {
                    print("No response body or data was empty.")
                }
                
                switch response.result {
                case .success(let response):
                    completion(true, response.data)
                case .failure(let error):
                    print("Error in NetworkManager.fetchLostPosts(): \(error)")
                    completion(false, nil)
                }
            }
    }

}
