//
//  ServiceManager.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/12/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//


import Alamofire
import Foundation


class ServiceManager: NSObject {
    
    typealias constant = Constants.ServerApi
    //weak var delegate: ServiceProtocols?
    var manager : SessionManager? = Alamofire.SessionManager()
    
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        manager = Alamofire.SessionManager(configuration:configuration)
        
    }
    
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
    
    /*
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
                         Helper.printLogs(with:response.result.value!)
                       // type(of: response.result.value)
                       // let pred: Prediction_Model = Prediction_Model.init(text: <#T##String#>, numPred: <#T##Int#>)
                       
                       // let JSON = response.result.value as! NSDictionary
                       //  Helper.printLogs(with:JSON)
                        self.delegate?.returnPredictionValue(response: response)
                        
                    } else {
                         Helper.printLogs(with:response)
                        self.delegate?.returnPredictionValue(response: response)

                        
                    }
                }
            case .failure( _):
                break
            }
})

}
    */
    
     //MARK: - Others
    func isValidJson(check data:Data) -> Bool
    {
        do{
        if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
           return true
        } else if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
            return true
        } else {
            return false
        }
        }
        catch let error as NSError {
             Helper.printLogs(with:"\(error.description)")
            return false
        }
        
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
             Helper.printLogs(with:"body: " +  String(data: jsonData!, encoding: .utf8)!)
        }
        catch {
        }
        request.httpBody = jsonData
        
        
        return request
    }
 
    
    func updateRefreshToken(of uid : String ,
                            onSuccess completionHandler: @escaping () -> Void ,
                            onError errorHandler: @escaping (Error) -> Void)
    {
        
        Alamofire.request(String(format:constant.refreshtoken), method: .post, parameters: ["refresh-token":(UserDefaults.standard.string(forKey: "refresh_token"))!], encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                
                switch serverResponse.result {
                case .success(let data):
                    if serverResponse.response!.statusCode == 200 {
                        let decoder = JSONDecoder()
                        let userdetails = try! decoder.decode(LoginResponse.self, from: data)
                        TokenManager.shared.storeNewToken(with: userdetails)
                        Helper.printLogs(with: "Success")
                        completionHandler()
                    }
                case .failure(let error):
                     Helper.printLogs(with: "Fail")
                    errorHandler(error)
                }
        }
    }
    
    func verifyTokenAndProceed(of uid : String,
                               onSuccess successCompletionHandler: @escaping () -> Void ,
                               onError errorHandler: @escaping (Error) -> Void)
    {
        Helper.printLogs()
        guard TokenManager.shared.isaccessTokenValid() else {
            guard TokenManager.shared.isRefreshTokenValid() else {
                if let rootVc: MainViewController = UIApplication.rootViewController() as? MainViewController
                {
                    rootVc.removeAllVCFromParentViewController()
                    rootVc.showLoginViewController()
                }
                return
            }
            
            //FIXME: Change the condition from take(2) to actual condition on real time environment
            /*  UserInfo.shared.accessTokenObserver.take(2).subscribe(onNext: { [weak self] details in
             //  Helper.printLogs(with:"AccessToken : \(details!)")
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
   
    //MARK: - User Identity
    
    func doSignUp(withBody body: SignUpRequest,
                  onSuccess successCompletionHandler: @escaping (SignUpResponse) -> Void,
                  onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                  onError errorHandler: @escaping (Error)-> Void)
    {

        Alamofire.request(createCustomeRequest(for: constant.signUp, withParameter: body, httpType: HTTPMethod.post, withAuth: false)).responseData(completionHandler:  { serverResponse in
             DispatchQueue.main.async {
                
                let decoder = JSONDecoder()
                switch serverResponse.result {
                case .success(let data):
                    guard self.isValidJson(check: serverResponse.result.value!) == true else {
                         Helper.printLogs(with:"❌ Invalid Json")
                        httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                        return
                    }
                    if serverResponse.response!.statusCode == 200 {
                       // let decoder = JSONDecoder()
                        let signupresponse = try! decoder.decode(SignUpResponse.self, from: data)
                         Helper.printLogs(with:"signupresponse \(signupresponse)")
                         successCompletionHandler(signupresponse)
                         //completeCompletionHandler()
                    }
                    else
                    {
                        
                        let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: data)
                        if let description = httpError.description {
                            httpErrorHandler(httpError)
                             Helper.printLogs(with:"HTTP error: \(description)")
                        }
                    }
                case .failure(let error):
                     Helper.printLogs(with:"Request failed with error: \(error)")
                    errorHandler(error)
                }
               
            }
        })
}
    
    func forgotPassword(for emailId:String ,
                        onSuccess successCompletionHandler: @escaping (ForgotPasswordResponse) -> Void,
                        onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                        onError errorHandler: @escaping (Error)-> Void)
    {

        Alamofire.request(constant.forgotpassword , method: .post, parameters: ["email":emailId], encoding: JSONEncoding.default, headers: nil)
            .responseData { serverResponse in
                DispatchQueue.main.async {
                    
                
                let decoder = JSONDecoder()
                switch serverResponse.result {
                case .success(let data):
                    guard self.isValidJson(check: serverResponse.result.value!) == true else {
                         Helper.printLogs(with:"❌ Invalid Json")
                        httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                        return
                    }
                    if serverResponse.response!.statusCode == 200 {
                        let decoder = JSONDecoder()
                        let response = try! decoder.decode(ForgotPasswordResponse.self, from: data)
                            successCompletionHandler(response)
                           // completeCompletionHandler()

                    }
                    else
                    {
                        //   self.handleHTTPError(from: serverResponse)
                        let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                        if let description = httpError.description {
                            httpErrorHandler(httpError)
                             Helper.printLogs(with:"HTTP error: \(description)")
                        }
                    }
                case .failure(let error):
                     Helper.printLogs(with:"Request failed with error: \(error)")
                     errorHandler(error)
                    //self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                }
                }
        }
    }
    

    
    func doLogin(for username: String, and password:String ,
                 onSuccess successCompletionHandler: @escaping (LoginResponse) -> Void,
                 onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                 onError errorHandler: @escaping (Error)-> Void) {
        Helper.printLogs()
        manager?.request(constant.login, method: .post, parameters: ["username":username ,"password":password] , encoding: JSONEncoding.default, headers: ["device-type":"mobile"])
            .responseData { serverResponse in
                DispatchQueue.main.async {
            
                    
                let decoder = JSONDecoder()
                switch serverResponse.result {
                case .success(let data):
                    guard self.isValidJson(check: serverResponse.result.value!) == true else {
                         Helper.printLogs(with:"❌ Invalid Json")
                        httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                        return
                    }
                    if serverResponse.response!.statusCode == 200 {
                        Helper.printLogs(with: "Success")
                        let userdetails = try! decoder.decode(LoginResponse.self, from: data)
                         Helper.printLogs(with:"userdetails \(userdetails)")
                            TokenManager.shared.storeNewToken(with: userdetails)
                            successCompletionHandler(userdetails)
                    }
                    else
                    {
                        //self.handleHTTPError(from: serverResponse)
                        let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                        Helper.printLogs(with: "HTTP Error")
                        if let description = httpError.description {
                            httpErrorHandler(httpError)
                             Helper.printLogs(with:"HTTP error: \(description)")
                        }
                    }
                case .failure(let error):
                    Helper.printLogs(with: "Error")
                     Helper.printLogs(with:"Request failed with error: \(error)")
                    errorHandler(error)
                    //self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                }
                   
              
                }
        }
}
    
    //MARK: - Profile and Settings
    func getProfile(for uid : String ,
                    onSuccess completionHandler: @escaping (Profile) -> Void,
                    onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                    onError  errorHandler: @escaping (Any) -> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                
                                Alamofire.request(String(format:constant.profile,uid), method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                        DispatchQueue.main.async {
                                     
                                        let decoder = JSONDecoder()
                                        switch serverResponse.result {
                                            case .success(let data):
                                                guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                     Helper.printLogs(with:"❌ Invalid Json")
                                                    httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                    return
                                                }
                                            if serverResponse.response!.statusCode == 200 {
                                                let profiledetails = try! decoder.decode(Profile.self, from: data)
                                                completionHandler(profiledetails)
                                            }
                                            else
                                            {
                                                let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                if let description = httpError.description {
                                                    httpErrorHandler(httpError)
                                                     Helper.printLogs(with:"HTTP error: \(description)")
                                                }
                                            }
                                        case .failure(let error):
                                             Helper.printLogs(with:"Request failed with error: \(error)")
                                            errorHandler(error)
                                            
                                        }
                                            
                                        }
                                        
                                }
                                
        },   onError: { error in
            errorHandler(error)
        })
        
    }
    
    func updateProfile(for uid : String ,
                       with details: Profile,
                    onSuccess completionHandler: @escaping () -> Void,
                    onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                    onError  errorHandler: @escaping (Any) -> Void )
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                let parameters: [String: Any] = [
                                    "first_name": details.first_name as Any,
                                    "last_name": details.last_name as Any,
                                    "user_attributes": ["dob" : details.user_attributes?.dob as Any,
                                                        "address" : details.user_attributes?.address as Any,
                                                        "gender" : details.user_attributes?.gender as Any,
                                                        "phone" : details.user_attributes?.phone as Any,
                                                        "class_code" : details.user_attributes?.class_code as Any,
                                    ]
                                    
                                ]
                                
                                Alamofire.request(String(format:constant.profile,uid), method: .put, parameters:parameters  , encoding: JSONEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                        DispatchQueue.main.async {
                                            
                                            let decoder = JSONDecoder()
                                            switch serverResponse.result {
                                            case .success(let data):
                                                guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                     Helper.printLogs(with:"❌ Invalid Json")
                                                    httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                    return
                                                }
                                                if serverResponse.response!.statusCode == 200 {
                                                   // let profiledetails = try! decoder.decode(Profile.self, from: data)
                                                    completionHandler()
                                                }
                                                else
                                                {
                                                    let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                    if let description = httpError.description {
                                                        httpErrorHandler(httpError)
                                                         Helper.printLogs(with:"HTTP error: \(description)")
                                                    }
                                                }
                                            case .failure(let error):
                                                 Helper.printLogs(with:"Request failed with error: \(error)")
                                                errorHandler(error)
                                                
                                            }
                                            
                                        }
                                        
                                }
                                
        },   onError: { error in
            errorHandler(error)
        })
        
    }
    
     //MARK: - Assignment
    
    func getassignments(for uid:String,
                        onSuccess successCompletionHandler: @escaping ([FailableDecodable<Assignment>]) -> Void,
                        onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                        onError errorHandler: @escaping (Error)-> Void  ,
                        onComplete completeCompletionHandler: @escaping ()-> Void)
    {
        let verifyTime = Date()
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                 Helper.printLogs(with:"Verify Time  \(Date().timeIntervalSince(verifyTime))")
                                let startTime = Date()
                                Alamofire.request(String(format: constant.assignments ,uid) , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                        DispatchQueue.main.async {
                                            
                                           
                                         
                                        let decoder = JSONDecoder()
                                        switch serverResponse.result {
                                        case .success(let data):
                                            
                                            guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                 Helper.printLogs(with:"❌ Invalid Json")
                                                httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                    completeCompletionHandler()
                                                }
                                                return
                                            }
                                            
                                            if serverResponse.response!.statusCode == 200 {
                                                  Helper.printLogs(with:"Response Time  \(Date().timeIntervalSince(startTime))")
                                                let decodeTime = Date()
                                                let assignments = try! decoder.decode([FailableDecodable<Assignment>].self, from: data)
                                                 Helper.printLogs(with:"Decode Time  \(Date().timeIntervalSince(decodeTime))")
                                                successCompletionHandler(assignments)
                                            }
                                            else
                                            {
                                                let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                if let description = httpError.description {
                                                    httpErrorHandler(httpError)
                                                     Helper.printLogs(with:"HTTP error: \(description)")
                                                }
                                            }
                                        case .failure(let error):
                                             Helper.printLogs(with:"Request failed with error: \(error)")
                                            //self.showInfoAlertScreen(with: serverResponse.result.error!.localizedDescription, oftype: "INFO")
                                            errorHandler(error)
                                        }
                                            
                                            
                                        
                                           
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                completeCompletionHandler()
                                            }
                                        }
                                        
                                }
                                
        },   onError: { error in
            errorHandler(error)
        })
        
    }
    
    func getAssignmentsUnits(for assignment:Int,
                  of uid:String,
                  onSuccess successCompletionHandler: @escaping ([FailableDecodable<ContentUnits>]) -> Void,
                  onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                  onError errorHandler: @escaping (Error)-> Void  ,
                  onComplete completeCompletionHandler: @escaping ()-> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                
                                Alamofire.request(String(format:constant.units, uid, assignment) , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                         DispatchQueue.main.async {
                                        
                                        let decoder = JSONDecoder()
                                        switch serverResponse.result {
                                        case .success(let data):
                                            
                                            guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                 Helper.printLogs(with:"❌ Invalid Json")
                                                httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                    completeCompletionHandler()
                                                }
                                                return
                                            }
                                            
                                            
                                            if serverResponse.response!.statusCode == 200 {
                                                let units = try! decoder.decode([FailableDecodable<ContentUnits>].self, from: data)
                                                successCompletionHandler(units)
                                            }
                                            else
                                            {
                                                let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                if let description = httpError.description {
                                                    httpErrorHandler(httpError)
                                                     Helper.printLogs(with:"HTTP error: \(description)")
                                                }
                                            }
                                        case .failure(let error):
                                             Helper.printLogs(with:"Request failed with error: \(error)")
                                            errorHandler(error)
                                            
                                        }
                                        
                                        
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                completeCompletionHandler()
                                            }
                                        }
                                }
                                
        },   onError: { error in
            errorHandler(error)
        })
    }
    
    func getAssignmentsUnitsAnswers(forUnit unitId:Int,
                    ofAssignment assignmentId: Int,
                    ofStudent uid:String,
                  onSuccess successCompletionHandler: @escaping ([FailableDecodable<UnitAnswers>]) -> Void,
                  onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                  onError errorHandler: @escaping (Error)-> Void  ,
                  onComplete completeCompletionHandler: @escaping ()-> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                
                                Alamofire.request(String(format:constant.assignmentAnswer,uid,assignmentId,unitId), method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                        DispatchQueue.main.async {
                                      
                                            let decoder = JSONDecoder()
                                            switch serverResponse.result {
                                                
                                            case .success(let data):
                                                
                                                guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                     Helper.printLogs(with:"❌ Invalid Json")
                                                    httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        completeCompletionHandler()
                                                    }
                                                    return
                                                }
                                                
                                                if serverResponse.response!.statusCode == 200 {
                                                    let unitsanswer = try! decoder.decode([FailableDecodable<UnitAnswers>].self, from: data)
                                                    successCompletionHandler(unitsanswer)
                                                }
                                                else
                                                {
                                                    let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                    if let description = httpError.description {
                                                        httpErrorHandler(httpError)
                                                         Helper.printLogs(with:"HTTP error: \(description)")
                                                    }
                                                }
                                            case .failure(let error):
                                                 Helper.printLogs(with:"Request failed with error: \(error)")
                                                errorHandler(error)
                                                
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                completeCompletionHandler()
                                            }
                                        }
                                }
                                
        },   onError: { error in
            errorHandler(error)
        })
    }
    
    
    func updateAssignmentStatus(for assignment:Int,
                                of uid: String,
                                with status: String,
                        onSuccess successCompletionHandler: @escaping (Response) -> Void,
                       onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                       onError errorHandler: @escaping (Error)-> Void  ,
                       onComplete completeCompletionHandler: @escaping ()-> Void)
    {
       
        Alamofire.request(String(format: constant.updateAssignmentStatus ,uid, assignment)  , method: .put, parameters: ["status":status] , encoding: JSONEncoding.default , headers:self.generateAuthHeaders())
            .responseData { serverResponse in
                DispatchQueue.main.async {
         
                    let decoder = JSONDecoder()
                    switch serverResponse.result {
                    case .success(let data):
                        
                        guard self.isValidJson(check: serverResponse.result.value!) == true else {
                             Helper.printLogs(with:"❌ Invalid Json")
                            httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                completeCompletionHandler()
                            }
                            return
                        }
                        
                        if serverResponse.response!.statusCode == 200 {
                            let response = try! decoder.decode(Response.self, from: data)
                            successCompletionHandler(response)
                        }
                        else
                        {
                            let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                            if let description = httpError.description {
                                httpErrorHandler(httpError)
                                 Helper.printLogs(with:"HTTP error: \(description)")
                            }
                        }
                    case .failure(let error):
                         Helper.printLogs(with:"Request failed with error: \(error)")
                        errorHandler(error)
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        completeCompletionHandler()
                    }
                }
        }
        
    }
   
     //MARK: - Category & Practice
    
    
    func getCategories(onSuccess successCompletionHandler: @escaping ([FailableDecodable<Categories>]) -> Void,
                  onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                  onError errorHandler: @escaping (Error)-> Void  ,
                  onComplete completeCompletionHandler: @escaping ()-> Void)
    {
                            //FIXME: Change URL
                                Alamofire.request(constant.category , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:nil)
                                    .responseData { serverResponse in
                                        DispatchQueue.main.async {
                                            let decoder = JSONDecoder()
                                            switch serverResponse.result {
                                            case .success(let data):
                                                
                                                guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                     Helper.printLogs(with:"❌ Invalid Json")
                                                    httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        completeCompletionHandler()
                                                    }
                                                    return
                                                }
                                                
                                                if serverResponse.response!.statusCode == 200 {
                                                    let categories = try! decoder.decode([FailableDecodable<Categories>].self, from: data)
                                                    successCompletionHandler(categories)
                                                }
                                                else
                                                {
                                                    let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                    if let description = httpError.description {
                                                        httpErrorHandler(httpError)
                                                         Helper.printLogs(with:"HTTP error: \(description)")
                                                    }
                                                }
                                            case .failure(let error):
                                                 Helper.printLogs(with:"Request failed with error: \(error)")
                                                errorHandler(error)
                                                
                                                }
                                                
                                           
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                completeCompletionHandler()
                                            }
                                        }
                                }
                                
        }
    
    
    func getPractices(for categoryid: Int,
                      of uid:String,
                      onSuccess successCompletionHandler: @escaping ([FailableDecodable<Practice>]) -> Void,
                      onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                      onError errorHandler: @escaping (Error)-> Void  ,
                      onComplete completeCompletionHandler: @escaping ()-> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                
                                Alamofire.request(String(format: constant.practice, uid , categoryid) , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                        DispatchQueue.main.async {
                                         
                                            let decoder = JSONDecoder()
                                            switch serverResponse.result {
                                            case .success(let data):
                                                guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                     Helper.printLogs(with:"❌ Invalid Json")
                                                    httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        completeCompletionHandler()
                                                    }
                                                    return
                                                }
                                                
                                                if serverResponse.response!.statusCode == 200 {
                                                    let practices = try! decoder.decode([FailableDecodable<Practice>].self, from: data)
                                                    successCompletionHandler(practices)
                                                }
                                                else
                                                {
                                                    let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                   
                                                    if let description = httpError.description {
                                                         httpErrorHandler(httpError)
                                                         Helper.printLogs(with:"HTTP error: \(description)")
                                                    }
                                                }
                                            case .failure(let error):
                                                 Helper.printLogs(with:"Request failed with error: \(error)")
                                                errorHandler(error)
                                                
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                completeCompletionHandler()
                                            }
                                        }
                                }
                                
        },   onError: { error in
            errorHandler(error)
        })
    }
    
    
    func getPracticesUnits(for practiceid:Int, of uid: String,
                  onSuccess successCompletionHandler: @escaping ([FailableDecodable<ContentUnits>]) -> Void,
                  onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                  onError errorHandler: @escaping (Error)-> Void  ,
                  onComplete completeCompletionHandler: @escaping ()-> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                Alamofire.request(String(format: constant.practiceunit, uid, practiceid) , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                        DispatchQueue.main.async {
                                      
                                            let decoder = JSONDecoder()
                                            switch serverResponse.result {
                                            case .success(let data):
                                                
                                                guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                     Helper.printLogs(with:"❌ Invalid Json")
                                                    httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        completeCompletionHandler()
                                                    }
                                                    return
                                                }
                                                
                                                if serverResponse.response!.statusCode == 200 {
                                                    let units = try! decoder.decode([FailableDecodable<ContentUnits>].self, from: data)
                                                    successCompletionHandler(units)
                                                }
                                                else
                                                {
                                                    let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                    if let description = httpError.description {
                                                        httpErrorHandler(httpError)
                                                         Helper.printLogs(with:"HTTP error: \(description)")
                                                    }
                                                }
                                            case .failure(let error):
                                                 Helper.printLogs(with:"Request failed with error: \(error)")
                                                errorHandler(error)
                                                
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                completeCompletionHandler()
                                            }
                                        }
                                }
                                
        },   onError: { error in
            errorHandler(error)
            
        })
                                
        
    }
    
    func getPracticesUnitsAnswers(forUnit unitId:Int,
                                    ofAssignment assignmentId: Int,
                                    ofStudent uid:String,
                                    onSuccess successCompletionHandler: @escaping ([FailableDecodable<UnitAnswers>]) -> Void,
                                    onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                                    onError errorHandler: @escaping (Error)-> Void  ,
                                    onComplete completeCompletionHandler: @escaping ()-> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                
                                Alamofire.request(String(format:constant.practicesAnswer,uid,assignmentId,unitId), method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
                                    .responseData { serverResponse in
                                        DispatchQueue.main.async {
                                           
                                            let decoder = JSONDecoder()
                                            switch serverResponse.result {
                                            case .success(let data):
                                                
                                                guard self.isValidJson(check: serverResponse.result.value!) == true else {
                                                     Helper.printLogs(with:"❌ Invalid Json")
                                                    httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                        completeCompletionHandler()
                                                    }
                                                    return
                                                }
                                                
                                                if serverResponse.response!.statusCode == 200 {
                                                    let unitsanswer = try! decoder.decode([FailableDecodable<UnitAnswers>].self, from: data)
                                                    successCompletionHandler(unitsanswer)
                                                }
                                                else
                                                {
                                                    let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                                                    if let description = httpError.description {
                                                        httpErrorHandler(httpError)
                                                         Helper.printLogs(with:"HTTP error: \(description)")
                                                    }
                                                }
                                            case .failure(let error):
                                                 Helper.printLogs(with:"Request failed with error: \(error)")
                                                errorHandler(error)
                                                
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                completeCompletionHandler()
                                            }
                                        }
                                }
                                
        },   onError: { error in
            errorHandler(error)
        })
    }
    
    
    
   
  /*

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
                    let alert = UIAlertController(title: String(alert.error_code!), message: alert.description, preferredStyle: UIAlertControllerStyle.alert)
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
 
 */
    
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

     //MARK: - Content Apis
    
    func getRootContent(ofStudent uid:String,
                        for type:String,
                       onSuccess successCompletionHandler: @escaping ([FailableDecodable<ContentGroup>]) -> Void,
                       onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                       onError errorHandler: @escaping (Error)-> Void )
    {
    verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                self.manager?.request(String(format:constant.rootContent,uid,type) , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
            .responseData { serverResponse in
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    switch serverResponse.result {
                    case .success(let data):
                        
                        guard self.isValidJson(check: serverResponse.result.value!) == true else {
                             Helper.printLogs(with:"❌ Invalid Json")
                            httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                            return
                        }
                        
                        if serverResponse.response!.statusCode == 200 {
                            let rootContent = try! decoder.decode([FailableDecodable<ContentGroup>].self, from: data)
                            Helper.printLogs(with: "Success")
                            successCompletionHandler(rootContent)
                        }
                        else
                        {
                            let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                            if let description = httpError.description {
                                httpErrorHandler(httpError)
                                Helper.printLogs(with: "HTTP Error")
                                 Helper.printLogs(with:"HTTP error: \(description)")
                            }
                        }
                    case .failure(let error):
                        Helper.printLogs(with: "Error")
                         Helper.printLogs(with:"Request failed with error: \(error)")
                        errorHandler(error)
                        
                    }
                }
        }
        } , onError: { error in
    errorHandler(error)
    })
        
    }
    
    func getContentGroup(for id: Int ,
                         ofStudent uid:String,
                         for type:String,
                         onSuccess successCompletionHandler: @escaping ([FailableDecodable<ContentGroup>]) -> Void,
                         onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                         onError errorHandler: @escaping (Error)-> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                
                                var url: String?
                                if id == 0 {
                                    url = String(format:constant.rootContent,uid,type)
                                } else {
                                    url = String(format:constant.contentGroup,uid,id)
                                }
                                
                                self.manager?.request(url! , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
            .responseData { serverResponse in
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    switch serverResponse.result {
                    case .success(let data):
                        
                        guard self.isValidJson(check: serverResponse.result.value!) == true else {
                             Helper.printLogs(with:"❌ Invalid Json")
                            httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                            return
                        }
                        
                        if serverResponse.response!.statusCode == 200 {
                            let rootContent = try! decoder.decode([FailableDecodable<ContentGroup>].self, from: data)
                            Helper.printLogs(with: "Success")
                            successCompletionHandler(rootContent)
                        }
                        else
                        {
                            let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                            Helper.printLogs(with: "HTTP Error")
                            if let description = httpError.description {
                                httpErrorHandler(httpError)
                                 Helper.printLogs(with:"HTTP error: \(description)")
                            }
                        }
                    case .failure(let error):
                        Helper.printLogs(with: "Error")
                         Helper.printLogs(with:"Request failed with error: \(error)")
                        errorHandler(error)
                        
                    }
                  
                }
        }
        } , onError: { error in
            errorHandler(error)
        })
    }
    
    func getContentUnit(for id: Int ,
                         ofStudent uid:String,
                         onSuccess successCompletionHandler: @escaping ([FailableDecodable<ContentUnits>]) -> Void,
                         onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                         onError errorHandler: @escaping (Error)-> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                self.manager?.request(String(format:constant.contentUnit,uid,id) , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
            .responseData { serverResponse in
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    switch serverResponse.result {
                    case .success(let data):
                        
                        guard self.isValidJson(check: serverResponse.result.value!) == true else {
                             Helper.printLogs(with:"❌ Invalid Json")
                            httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                           
                            return
                        }
                        
                        if serverResponse.response!.statusCode == 200 {
                            let rootContent = try! decoder.decode([FailableDecodable<ContentUnits>].self, from: data)
                            successCompletionHandler(rootContent)
                        }
                        else
                        {
                            let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                            if let description = httpError.description {
                                httpErrorHandler(httpError)
                                 Helper.printLogs(with:"HTTP error: \(description)")
                            }
                        }
                    case .failure(let error):
                         Helper.printLogs(with:"Request failed with error: \(error)")
                        errorHandler(error)
                        
                    }
                 
                }
        }
        } , onError: { error in
            errorHandler(error)
        })
    }
    
    func getUnitsAnswer(for unitId: Int ,
                        ofStudent uid:String,
                        onSuccess successCompletionHandler: @escaping ([FailableDecodable<UnitAnswers>]) -> Void,
                        onHTTPError httpErrorHandler:@escaping (HTTPError)-> Void ,
                        onError errorHandler: @escaping (Error)-> Void)
    {
        verifyTokenAndProceed(of: uid,
                              onSuccess: {
                                self.manager?.request(String(format:constant.unitAnswers,uid,unitId) , method: .get, parameters: [:] , encoding: URLEncoding.default, headers:self.generateAuthHeaders())
            .responseData { serverResponse in
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    switch serverResponse.result {
                    case .success(let data):
                        
                        guard self.isValidJson(check: serverResponse.result.value!) == true else {
                             Helper.printLogs(with:"❌ Invalid Json")
                            httpErrorHandler(HTTPError(with: String(format:"%d", serverResponse.response!.statusCode), and: "Invalid Json"))
                            return
                        }
                        
                        if serverResponse.response!.statusCode == 200 {
                            let rootContent = try! decoder.decode([FailableDecodable<UnitAnswers>].self, from: data)
                            successCompletionHandler(rootContent)
                        }
                        else
                        {
                            let httpError: HTTPError = try! decoder.decode(HTTPError.self, from: serverResponse.result.value!)
                            if let description = httpError.description {
                                httpErrorHandler(httpError)
                                 Helper.printLogs(with:"HTTP error: \(description)")
                            }
                        }
                    case .failure(let error):
                         Helper.printLogs(with:"Request failed with error: \(error)")
                        errorHandler(error)
                        
                    }
                   
                }
        }
        } , onError: { error in
            errorHandler(error)
        })
    }
    
    
    
}
