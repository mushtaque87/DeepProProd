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
import MBProgressHUD

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
                        print(response.result.value!)
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
  
    func generateAuthHeaders() -> [String:String]
    {
        return ["Authorization" : String(format: "%@ %@", "Bearer",UserDefaults.standard.string(forKey: "access_token")!),
                "Refresh-Token" : UserDefaults.standard.string(forKey: "refresh_token")!]
    }
    
    func createCustomeRequest<T : Encodable>(for apiEndpoint:String , withParameter body:T? = nil,  httpType: HTTPMethod , withAuth authOn:Bool = false) -> URLRequest
    {
        var request = URLRequest(url:URL(string: apiEndpoint)! )
        request.httpMethod = httpType.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        if(authOn) {
            request.allHTTPHeaderFields =  generateAuthHeaders()
       // request.addValue(UserDefaults.value(forKey: "refresh_token") as! String, forHTTPHeaderField: "Refresh-Token")
       // request.addValue(String(format: "%s %s", "Bearer",UserDefaults.value(forKey: "access_token") as! String), forHTTPHeaderField: "Authorization")
        }
        
        guard body != nil else {
            return request
        }
        var jsonData:Data?
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(body)
            print("body: " +  String(data: jsonData!, encoding: .utf8)!)
        }
        catch {
        }
        request.httpBody = jsonData
        
        
        return request
    }
 
    
    func doSignUp(withBody body: SignUpRequest,
                  onSuccess successCompletionHandler: @escaping (SignUpResponse) -> Void,
                  onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                  onError errorHandler: @escaping (Error)-> Void  ,
                  onComplete completeCompletionHandler: @escaping ()-> Void)
    {
     
        
        /*
        var jsonData:Data?
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(body)
            print("body: " +  String(data: jsonData!, encoding: .utf8)!)
        }
        catch {
        }
        
        var request = URLRequest(url:URL(string: constant.baseUrl+constant.signUp)! )
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        */
        //print("Body--> \(body.toJSON().description)")
       // print("Dict--> \(JSONSerialization.jsonObject(with: jsonData!) as? [String:Any])")
        //var newRequest = createCustomeRequest(for: constant.baseUrl+constant.signUp, withParameter: body, httpType: HTTPMethod.post, withAuth: false)
        //Alamofire.request(constant.baseUrl+constant.forgotpassword, method: .post, parameters:  jsonData , encoding: JSONEncoding.default, headers: nil)
       
        Alamofire.request(createCustomeRequest(for: constant.baseUrl+constant.signUp, withParameter: body, httpType: HTTPMethod.post, withAuth: false)).responseData(completionHandler:  { serverResponse in
                debugPrint(serverResponse)
                let decoder = JSONDecoder()
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                       // let decoder = JSONDecoder()
                        let signupresponse = try! decoder.decode(SignUpResponse.self, from: data)
                        print("signupresponse \(signupresponse)")
                         successCompletionHandler(signupresponse)
                         completeCompletionHandler()
                    }
                    else
                    {
                        print(serverResponse.result.value!)
                        let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: data)
                        print(httpError.description)
                        print("HTTP error: \(httpError.description)")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    errorHandler(error)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    completeCompletionHandler()
                }
        })
}
    
    func forgotPassword(for emailId:String ,
                        onSuccess successCompletionHandler: @escaping (ForgotPasswordResponse) -> Void,
                        onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                        onError errorHandler: @escaping (Error)-> Void  ,
                        onComplete completeCompletionHandler: @escaping ()-> Void)
    {
        Alamofire.request(constant.baseUrl+constant.forgotpassword, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                DispatchQueue.main.async {
                debugPrint(serverResponse)
                let decoder = JSONDecoder()
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                        let decoder = JSONDecoder()
                        let response = try! decoder.decode(ForgotPasswordResponse.self, from: data)
                            successCompletionHandler(response)
                            completeCompletionHandler()

                    }
                    else
                    {
                        //   self.handleHTTPError(from: serverResponse)
                        let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                        httpErrorHandler(httpError)
                        print("HTTP error: \(httpError.description)")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                     errorHandler(error)
                    //self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        completeCompletionHandler()
                    }
                    
                }
        }
    }
    

    
    func doLogin(for username: String, and password:String ,
                 onSuccess successCompletionHandler: @escaping (LoginResponse) -> Void,
                 onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                 onError errorHandler: @escaping (Error)-> Void  ,
                 onComplete completeCompletionHandler: @escaping ()-> Void ) {
        
        Alamofire.request(constant.baseUrl+constant.login, method: .post, parameters: ["username":username ,"password":password] , encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                DispatchQueue.main.async {
                debugPrint(serverResponse)
                let decoder = JSONDecoder()
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                        let userdetails = try! decoder.decode(LoginResponse.self, from: data)
                        print("userdetails \(userdetails)")
                        
                            TokenManager.shared.storeNewToken(with: userdetails)
                            successCompletionHandler(userdetails)
                    }
                    else
                    {
                        //self.handleHTTPError(from: serverResponse)
                        let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                        httpErrorHandler(httpError)
                        print("HTTP error: \(httpError.description)")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    errorHandler(error)
                    //self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                         completeCompletionHandler()
                    }
              
                }
        }
}
    

    func getProfile(for uid : String ,
                    onSuccess completionHandler: @escaping (Profile) -> Void,
                    onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                    onError  errorHandler: @escaping (Any) -> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                
                                Alamofire.request(constant.baseUrl + uid, method: .get, parameters: [:] , encoding: JSONEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                        let decoder = JSONDecoder()
                                        switch serverResponse.result {
                                        case .success(let data):
                                            if serverResponse.response!.statusCode == 200 {
                                                let profiledetails = try! decoder.decode(Profile.self, from: data)
                                                completionHandler(profiledetails)
                                            }
                                            else
                                            {
                                                let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                httpErrorHandler(httpError)
                                                print("HTTP error: \(httpError.description)")
                                            }
                                        case .failure(let error):
                                            print("Request failed with error: \(error)")
                                            self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                                        }
                                        
                                }
                                
        },   onError: { error in
            errorHandler(error)
        })
        
    }
    
    
    func updateRefreshToken(of uid : String ,
                            onSuccess completionHandler: @escaping () -> Void ,
                            onError errorHandler: @escaping (Any) -> Void)
    {
        
        Alamofire.request(constant.baseUrl+uid+constant.refreshtoken, method: .post, parameters: ["refresh-token":(UserDefaults.standard.string(forKey: "refresh_token"))!], encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                debugPrint(serverResponse)
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                        let decoder = JSONDecoder()
                        let userdetails = try! decoder.decode(LoginResponse.self, from: data)
                        TokenManager.shared.storeNewToken(with: userdetails)
                        completionHandler()
                    }
                case .failure(let error):
                    errorHandler(error)
                }
        }
    }
    
    func verifyTokenAndProceed(of uid : String,
                               onSuccess successCompletionHandler: @escaping () -> Void ,
                               onError errorHandler: @escaping (Any) -> Void)
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
          /*  UserInfo.shared.accessTokenObserver.take(2).subscribe(onNext: { [weak self] details in
               // print("AccessToken : \(details!)")
                completionHandler()
                
            }).disposed(by: disposeBag)
            */
            
            self.updateRefreshToken(of: uid , onSuccess: {
                successCompletionHandler()
            }, onError: { error in
                errorHandler(error)
            })
            return
        }
        successCompletionHandler()
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
