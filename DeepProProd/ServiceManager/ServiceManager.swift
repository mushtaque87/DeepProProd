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
    var manager : SessionManager?

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
         url = try! URLRequest(url: URL(string:"https://ainfinity.dyndns.org:8500/audio/predict")!, method: .post, headers: nil)
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
                        print(response.result.value)
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
