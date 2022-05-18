//
//  Network.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import Foundation
import Alamofire

struct WebService
{
    static func requestService(url: String, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, encoding:String, viewController: UIViewController,  completion: @escaping CompletionHandler)
    {
        var updatedHeader: HTTPHeaders = headers
        let authHederPart1 = "\(Int(timestamp))-"
        let authHederPart2 = "\(Int(timestamp))\(platformAccessToken)".md5Value

        updatedHeader["Authorization"] = authHederPart1+authHederPart2
       // updatedHeader["Content-Type"] = "application/json"
//        print(updatedHeader)
        
        let urlToPass:String = "\(baseUrl)" + url
        
        var encode: ParameterEncoding!
        if encoding == "JSON"
        {
           encode = JSONEncoding.default
        }
        else if encoding == "QueryString"
        {
            encode = URLEncoding.queryString
        }
        else
        {
            encode = URLEncoding.default
        }
        
        Alamofire.request(urlToPass, method: method, parameters: parameters, encoding: encode, headers: updatedHeader).responseJSON { (response:DataResponse) in
            
             let dat:Data = response.data!
             let strRes:String = String(data: dat, encoding: .utf8)!
            // print(strRes)
            
            switch response.result
            {
            case .success:
                if let JSON:[String:Any] = response.result.value as? [String:Any]
                {
                    // print("JSON: \(JSON)")
                    completion(JSON,strRes, nil)
                }
                else if let JSONArray:[[String:Any]] = response.result.value as? [[String:Any]]
                {
                    // print("JSON is ARRAY : \(JSONArray)")
                    completion(["createdArray": JSONArray], strRes, nil)
                }
                break
            case .failure(let err):
                print("- - Error Came for - -> \(url)")
                print("- - - -")
                print("Request failed with error ->   \(err.localizedDescription)")
                
                completion([:], strRes, err)
                break
            }
        }
    }
    
    static func uploadImage(url: String, method: HTTPMethod, parameter: Parameters, header: HTTPHeaders, image: UIImage, viewController: UIViewController, completion: @escaping CompletionHandler)
    {
        var updatedHeader: HTTPHeaders = header
        let authHederPart1 = "\(Int(timestamp))-"
        let authHederPart2 = "\(Int(timestamp))\(platformAccessToken)".md5Value
        
        updatedHeader["Authorization"] = authHederPart1+authHederPart2
        // updatedHeader["Content-Type"] = "application/json"
        print(updatedHeader)
        let urlToPass:String = "\(baseUrl)" + url

        let imageData = image.jpegData(compressionQuality: 0.50)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "file", fileName: "ios_file.png", mimeType: "image/png")
            for (key, value) in parameter {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: urlToPass, headers: updatedHeader)
        { (result) in
            switch result
            {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("Uploading Progress - - > \(progress)")
                })
                
                upload.responseJSON { response in
                    //print response.result
                    if let JSON:[String:Any] = response.result.value as? [String:Any]
                    {
                        let dat:Data = response.data!
                        let strRes:String = String(data: dat, encoding: .utf8)!

                        // print("JSON: \(JSON)")
                        completion(JSON, strRes, nil)
                    }
                    else if let JSONArray:[[String:Any]] = response.result.value as? [[String:Any]]
                    {
                        let dat:Data = response.data!
                        let strRes:String = String(data: dat, encoding: .utf8)!

                        // print("JSON is ARRAY : \(JSONArray)")
                        completion(["createdArray": JSONArray], strRes, nil)
                    }
                }
            case .failure(let err):
                print("- - Error Came for - -> \(url)")
                print("- - - -")
                print("Request failed with error ->   \(err.localizedDescription)")
                
                completion([:], "", err)
                break
            }
        }
    }
}
