//
//  ViewControllerProtocols.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 3/1/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerDelegate: class {
    func removeViewController()
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

protocol SettingProtocols: class {
    func showProfileScreen()
    func logOut(_ sender: Any)
    func reloadTable()
    func showSettingSelectionScreen(for settingType : SettingType) 
}

protocol ProfileViewDelegate: class {
 //func moveTextField(up movedUp: Bool)
    func moveTextField(up movedUp: Bool ,by height:CGFloat)
    func editProfilePic()
    func showEditNameScreen()
    func showEditGenderScreen()
    
}

protocol SignUpViewDelegate: class {
    //func moveTextField(up movedUp: Bool)
    func signUp()
}
