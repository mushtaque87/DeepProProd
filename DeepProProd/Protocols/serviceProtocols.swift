//
//  serviceProtocols.swift
//  Pronounciation
//
//  Created by Mushtaque Ahmed on 12/21/17.
//  Copyright © 2017 Mushtaque Ahmed. All rights reserved.
//

import UIKit
import Alamofire

protocol ServiceProtocols: class {
    func returnPredictionValue(response : DataResponse<Any>)
}

protocol PracticeBoardProtocols: class {
    func displayResultType(to resultType: ResultViewType  , from currentType:ResultViewType)
    func resetTextViewContent(textView: UITextView)
    func reloadtable()
    func reloadCollectionView()
    func reloadCellInCollectionView(at indexPath:[IndexPath], isPlaying: Bool)
    func updateExpertAudioButton(isPlaying: Bool)
    func resetAudioButtonInCollectionView(at count:Int)
    func setAttributedText(with text:NSAttributedString)
    //func setExpertSpeechButtonImage()
    func setExpertSpeechButtonImage(set isTTSSpeaking:Bool)
}
