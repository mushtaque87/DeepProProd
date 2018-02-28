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
import RxSwift


class ServiceManager: NSObject {
    
    typealias constant = Constants.ServerApi
    let disposeBag = DisposeBag()
    
    
    
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
    
    func doSignUp(with email : String ,firstName : String ,lastName: String , password:String , with completionHandler: @escaping (Any) -> Void)
    {
        /*
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
        
    })*/
        let parameters: [String: Any] = [
            "email" : email,
            "firstname" : firstName,
            "lastname" : lastName ,
            "password" : password ,
        ]
        
        Alamofire.request(constant.baseUrl+constant.signUp, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                debugPrint(serverResponse)
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                        let decoder = JSONDecoder()
                        let signupresponse = try! decoder.decode(SignUpResponse.self, from: data)
                        print("signupresponse \(signupresponse)")
                        
                       // self.doLogin(for: email, and: password, with: completionHandler)
                        
                       /* DispatchQueue.main.async {
                            UserInfo.sharedInstance.userDetails = userdetails
                            completionHandler(userdetails)
                            
                        }*/
                    }
                    else
                    {
                        
                        self.handleHTTPError(from: serverResponse)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                }
        }
}
    
    func doLogin(for username: String, and password:String , with completionHandler: @escaping (LoginResponse) -> Void ) {
    //"https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login"
    

        
        Alamofire.request(constant.baseUrl+constant.login, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                debugPrint(serverResponse)
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                        let decoder = JSONDecoder()
                        let userdetails = try! decoder.decode(LoginResponse.self, from: data)
                        print("userdetails \(userdetails)")
                        
                        TokenManager.shared.storeNewToken(with: userdetails)
                      //  TokenManager.shared.isRefreshTokenValid()
                        
                        DispatchQueue.main.async {
                            //UserInfo.shared.userDetails = userdetails
                            completionHandler(userdetails)
                            
                        }
                    }
                    else
                    {
                     
                        self.handleHTTPError(from: serverResponse)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                }
        }
        
        
        /*
       Alamofire.request("http://localhost:8080/v1/uam/users/login").responseString(queue: DispatchQueue.global(qos: .default), encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue) , completionHandler: {response in
      
        print("responseString")
           switch response.result {
           case .success:
              print("Success")
              
              if(response.result.value== 200)
              {
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
              }
            break
            case .failure:
                print("failure : \(response.error?.localizedDescription ?? "Some Error Occured, Please tyr Again")")
                
                
//                DispatchQueue.main.async {
//                self.showLoginScreen(with: (response.error?.localizedDescription)!)
//                }
                self.showInfoAlertScreen(with: (response.error?.localizedDescription)!)
            break
            }
      
   // https://9b2ea2a7-b268-45d0-906b-1bb3c5341088.mock.pstmn.io/uam/v1/users/login
})
   print("end of trialLogin")*/
        
        
}

    func updateRefreshToken(of uid : String)
    {
        
        Alamofire.request(constant.baseUrl+uid+constant.refreshtoken, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                debugPrint(serverResponse)
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                        let decoder = JSONDecoder()
                        let userdetails = try! decoder.decode(LoginResponse.self, from: data)
                        print("userdetails \(userdetails)")
                        
                        TokenManager.shared.storeNewToken(with: userdetails)

                    }
                    else
                    {
                        
                        self.handleHTTPError(from: serverResponse)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                }
        }
    }
    
    func verifyTokenAndProceed(of uid : String, with completionHandler: @escaping () -> Void )
    {
        guard TokenManager.shared.isaccessTokenValid() else {
            guard TokenManager.shared.isRefreshTokenValid() else {
                if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
                {
                    rootVc.showLoginViewController()
                }
                return
            }
            
            //FIXME: Change the condition from take(2) to actual condition on real time environment
            UserInfo.shared.accessTokenObserver.take(2).subscribe(onNext: { [weak self] details in
               // print("AccessToken : \(details!)")
                completionHandler()
                
            }).disposed(by: disposeBag)

            self.updateRefreshToken(of: uid)
            return
        }
        
    }
    
        func getProfile(for uid : String , with completionHandler: @escaping (Any) -> Void)
        {
            let startRequest: () -> Void = {  
                
                Alamofire.request(constant.baseUrl+constant.port+constant.login, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil)
                    .responseData { serverResponse in
                        debugPrint(serverResponse)
                        switch serverResponse.result {
                        case .success(let data):
                            if serverResponse.response!.statusCode == 200 {
                                let decoder = JSONDecoder()
                                let userdetails = try! decoder.decode(LoginResponse.self, from: data)
                                print("userdetails \(userdetails)")
                                
                                TokenManager.shared.storeNewToken(with: userdetails)
                                DispatchQueue.main.async {
                                    completionHandler(userdetails)
                                    
                                }
                            }
                            else
                            {
                                
                                self.handleHTTPError(from: serverResponse)
                            }
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                            self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                        }
              
                }
            }
            verifyTokenAndProceed(of: uid, with: startRequest)
            
        }
    
    func forgotPassword(for emailId:String , with completionHandler: @escaping (ForgotPasswordResponse) -> Void)
    {
        /*
        let startRequest: () -> Void = {
            
            
        }
        
        verifyTokenAndProceed(of: emailId, with: startRequest)
        */
        
        Alamofire.request(constant.baseUrl+constant.forgotpassword, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                debugPrint(serverResponse)
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                        let decoder = JSONDecoder()
                        let response = try! decoder.decode(ForgotPasswordResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            completionHandler(response)
                            
                        }
                    }
                    else
                    {
                        
                        self.handleHTTPError(from: serverResponse)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                }
        }
    }
    
func handleHTTPError(from serverResponse: DataResponse<Data>)
{
    var httpError: HTTPError?
    switch serverResponse.response!.statusCode {
    case 400 , 401 , 405 , 404:
        let decoder = JSONDecoder()
        httpError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
        showInfoAlertScreen(with: httpError, oftype: "HTTPERROR")
    case 403 :
        let decoder = JSONDecoder()
        httpError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
        self.showLoginScreen(with: (httpError?.description)!)
        
    default:
        showInfoAlertScreen(with: "Server Problem", oftype: "INFO")
        break
    }
    
    print("Error \(String(describing: httpError))")
   // return httpError!
}
    
    
    func showInfoAlertScreen(with alertDetails: Any , oftype alertType:String)
{
    DispatchQueue.main.async {
            if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
            {
            
                //rootVc.showInfoAlertView()
                switch alertType{
                case "HTTPERROR":
                    if let alert:HTTPError = alertDetails as? HTTPError
                   {
                    let alert = UIAlertController(title: String(alert.error_code), message: alert.description, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    rootVc.present(alert, animated: true, completion: nil)
                   }
                    break
                case "INFO":
                    let alert = UIAlertController(title: "Warning", message: alertDetails as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    rootVc.present(alert, animated: true, completion: nil)
                    break
                default:
                    break
                }
                
            }
        
        }
        
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
