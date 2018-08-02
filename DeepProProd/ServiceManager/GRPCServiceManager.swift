//
//  GRPCManager.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation

class GRPCServiceManager: NSObject {
    
//MARK: - GRPC Client Connection
var service : Pronounce_PronounceServiceClient?
typealias constant = Constants.ServerApi
    
    public override init()
    {
        super.init()
        prepareService()
    }
    
    func prepareService()
    {
        service = Pronounce_PronounceServiceClient(address: Constants.ServerApi.grpcBaseUrl, secure: false)
    }

    func getWordPredictionFromGRPC(for uid:String , unit unitId:Int = 0, with audio: Data, and text: String ,
                                   onSuccess successCompletionHandler: @escaping (Pronounce_PronounceResponse) -> Void ,
                                   onFailure  failureCompletionHandler: @escaping (Any) -> Void)
    {
       ServiceManager().verifyTokenAndProceed(of: uid, onSuccess: {
            
                
                var requestMessage = Pronounce_PronounceRequest()
                requestMessage.text = text
                requestMessage.speech = audio
                requestMessage.userID = uid
                requestMessage.studentID = uid
                requestMessage.unitID = Int32(unitId)
                requestMessage.authToken =  UserDefaults.standard.string(forKey: "access_token")!
        
        do {
                _ = try self.service?.predict(requestMessage, completion: { (response, callresult) in
                    
                    print(response)
                    print(callresult.statusMessage)
                    DispatchQueue.main.async {
                        
                        switch callresult.statusCode {
                        case .ok:
                            successCompletionHandler(response!)
                            break
                        case .unauthenticated:
                            failureCompletionHandler("Unauthenticated. Please Log in Again.")
                            break
                        default :
                            failureCompletionHandler("Server Error. Please retry!!! ")
                            break
                        }
                        
                    }
                })
        } catch {
            print("Catch \(error)")
            }
        
 
            } , onError: { error in
            failureCompletionHandler("Unauthenticated. Please Log in Again.")
                
        })
}

}
