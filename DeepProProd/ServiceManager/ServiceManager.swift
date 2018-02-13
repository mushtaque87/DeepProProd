//
//  ServiceManager.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/12/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import Foundation



class ServiceManager: NSObject {
    
    weak var delegate: ServiceProtocols?
    var manager : SessionManager? = Alamofire.SessionManager()

    func ignoreSSL() -> Void {
        manager = Alamofire.SessionManager()
        
        manager?.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust, let trust = challenge.protectionSpace.serverTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: trust)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.manager?.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
    }
    
    
    func sendAudioForPrediction(file: URL , text: String) {
       // let urlString = "https://192.168.8.18:8500/audio/predict"
        ignoreSSL()
        
       // https://ainfinity.dyndns.org:8500/audio/predict
 
      //  let url = try! URLRequest(url: URL(string:"https://192.168.8.118:8500/audio/predict")!, method: .post, headers: nil)
            //https://192.168.8.118:8500/audio/predict
        var url: URLRequest?
        if(Settings.sharedInstance.language == "English")
        {
            url = try! URLRequest(url: URL(string:Constants.api.baseUrl+Constants.api.engPort+Constants.api.speechApi)!, method: .post, headers: nil)

        // url = try! URLRequest(url: URL(string:"https://ainfinity.dyndns.org:8500/audio/predict")!, method: .post, headers: nil)
        }else{
         url = try! URLRequest(url: URL(string:"https://ainfinity.dyndns.org:8400/audio/predict")!, method: .post, headers: nil)

        }
        // let frenchData = "français".data(using: .utf8, allowLossyConversion: false)!
        // let japaneseData = "日本語".data(using: .utf8, allowLossyConversion: false)!
        
        //let audioData =  getDocumentsDirectory().appendingPathComponent("recording.m4a")
    let textData = text.data(using: .utf8, allowLossyConversion: false)!
    let debugData = "false".data(using: .utf8, allowLossyConversion: false)!

    
    var jsonresponse: DataResponse<Any>?
        
        // When
    manager?.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append(file, withName:"audio")
            multipartFormData.append(textData, withName: "text")
            multipartFormData.append(debugData, withName: "debug")
        },
        with: url!,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if((response.result.value) != nil) {
                        print(response.result.value as Any)
                       // type(of: response.result.value)
                       // let pred: Prediction_Model = Prediction_Model.init(text: <#T##String#>, numPred: <#T##Int#>)
                       
                       // let JSON = response.result.value as! NSDictionary
                       // print(JSON)
                        self.delegate?.returnPredictionValue(response: response)
                        
                    } else {
                        print(response)
                        self.delegate?.returnPredictionValue(response: response)

                        
                    }
                }
            case .failure( _):
                break
            }
})

}
    
    func doSignUp(with wmail : String ,firstName : String ,lastName: String , password:String , with completionHandler: @escaping (UserDetails) -> Void)
    {
        
        Alamofire.request("https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login").responseString(queue: DispatchQueue.global(qos: .default), encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue) , completionHandler: {response in
            
            print("responseString")
            switch response.result {
            case .success:
                print("Success")
                
                // Convert the response to NSData to handle with SwiftyJSON
                if (response.result.value?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))) != nil {
                    //            let json = JSON(data: data)
                    
                    let decoder = JSONDecoder()
                    let userdetails = try! decoder.decode(UserDetails.self, from: (response.result.value?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))!)
                    print("userdetails \(userdetails)")
                    DispatchQueue.main.async {
                        UserInfo.sharedInstance.userDetails = userdetails
                        completionHandler(userdetails)
                        
                    }
                    print("after completion is called")
                }
                break
            case .failure:
                print("failure : \(response.error?.localizedDescription ?? "Please Login Again")")
                DispatchQueue.main.async {
                    self.showLoginScreen(with: (response.error?.localizedDescription)!)
                }
                break
            }
        
    })
}
    
    func doLogin(for username: String, and password:String , with completionHandler: @escaping (UserDetails) -> Void) {
    //"https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login"
    
   /* Alamofire.request("https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login", method: .get, parameters: [:], encoding: JSONEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: JSONSerialization.ReadingOptions.allowFragments, completionHandler:{ response in
        
        print(response)
    }
    )*/
   
     //  try manager?.request("https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login".asURL(), method: .get, parameters: [:], encoding:JSONEncoding.default , headers: [:])
    
    
//    let url = try! URLRequest(url: URL(string:"https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login")!, method: .post, headers: nil) as! URLConvertible
    
    
        Alamofire.request("https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login").responseString(queue: DispatchQueue.global(qos: .default), encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue) , completionHandler: {response in
      
        print("responseString")
           switch response.result {
           case .success:
              print("Success")
              
              // Convert the response to NSData to handle with SwiftyJSON
              if (response.result.value?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))) != nil {
                //            let json = JSON(data: data)
                
                let decoder = JSONDecoder()
                let userdetails = try! decoder.decode(UserDetails.self, from: (response.result.value?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))!)
                print("userdetails \(userdetails)")
                DispatchQueue.main.async {
                    UserInfo.sharedInstance.userDetails = userdetails
                    completionHandler(userdetails)
                    
                }
                print("after completion is called")
              }
            break
            case .failure:
                print("failure : \(response.error?.localizedDescription ?? "Please Login Again")")
                DispatchQueue.main.async {
                self.showLoginScreen(with: (response.error?.localizedDescription)!)
                }
            break
            }
      
   // https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login
})
   print("end of trialLogin")
}

func getProfile(of uid : String , with completionHandler: @escaping (ProfileDetails) -> Void)
{
    
    }
    
    
func showLoginScreen(with message: String = "Please Login Again")
{
    if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
    {
        rootVc.showLoginViewController()
    }
    
}
    
/*func sendAudioForPrediction(file: Any)
{
    
    var r  = URLRequest(url: URL(string: "https://192.168.8.18:8500/audio/predict")!)
    r.httpMethod = "POST"
    let boundary = "Boundary-\(UUID().uuidString)"
    r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    r.httpBody = createBody(parameters: params,
                            boundary: boundary,
                            data: UIImageJPEGRepresentation(chosenImage, 0.7)!,
                            mimeType: "image/jpg",
                            filename: "hello.jpg")
}
    
func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
 */
    
}
