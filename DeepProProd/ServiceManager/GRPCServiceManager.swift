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

    func getWordPredictionFromGRPC(for audio: Data, and text: String , onSuccess successCompletionHandler: @escaping (Pronounce_PronounceResponse) -> Void , onFailure  failureCompletionHandler: @escaping () -> Void) throws
    {
        
        var requestMessage = Pronounce_PronounceRequest()
        requestMessage.text = text
        requestMessage.speech = audio
      
        _ = try service?.predict(requestMessage, completion: { (response, callresult) in
            
            print(response)
            print(callresult)
            DispatchQueue.main.async {
            
            guard response != nil else{
                failureCompletionHandler()
                return
            }
            successCompletionHandler(response!)
            }
        })
        
}

}
