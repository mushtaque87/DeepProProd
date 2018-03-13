//
//  GRPCManager.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/12/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation


//MARK: - GRPC Client Connection
var service : Pronounce_PronounceServiceClient?

    func prepareService(address: String, host: String)
    {
    service = Pronounce_PronounceServiceClient(address: address, secure: false)
        
    }

    func getWordPredictionFromGRPC(for audio: Data, and text: String , onSuccess successCompletionHandler: @escaping (Pronounce_PronounceResponse) -> Void) throws
    {
        
        var requestMessage = Pronounce_PronounceRequest()
        requestMessage.text = text
        requestMessage.speech = audio
        
        _ = try service?.predict(requestMessage, completion: { (response, callresult) in
       
            print(callresult)
            guard response != nil else{
                return
            }
            successCompletionHandler(response!)
            
        //let pronunceResponse = try? Pronounce_PronounceResponse // 3
        //completion(pronunceResponse)
        //print("\n")
        //print(pronunceResponse)
            
        })
        
}

