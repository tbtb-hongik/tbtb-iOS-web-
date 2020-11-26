//
//  AppDelegate.swift
//  clipboard
//
//  Created by 김준성 on 2020/06/01.
//  Copyright © 2020 김준성. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(forName: UIPasteboard.changedNotification, object: nil, queue: nil, using: sendData)
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}


extension AppDelegate{
    
    typealias dataFromURLCompletionClosure = (URLResponse, Data) -> (Void)
    
    func dicToQuery(_ dict: [String : String]) -> String{
        var parts = [String]()
        for (key, val) in dict{
            let part : String = key + "=" + val
            parts.append(part)
        }
        return parts.joined(separator: "&")
    }
    
    func sendData(_ notification: Notification) {
        print("send bef")
        if let theString = UIPasteboard.general.string{
            let os = "iOS"
            let myURL = theString
            let param = "os=\(os)&url=\(myURL)"
            let paramData = param.data(using: .utf8)
            
            
            //
            let url = URL(string : "http://13.251.164.73:5555/android")
            //
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = paramData

            //
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(String(paramData!.count), forHTTPHeaderField: "content-Length")

            //
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                //
                if let e = error {
                    NSLog("An error has occurred up: \(e.localizedDescription)")
                    return
                }
                
//                DispatchQueue.main.async {
//                    if let data = data{
//                        let str = String(decoding: data, as: UTF8.self)
//                        print(str)
//                        let msgString = "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
//                        let alert = UIAlertController(title: "Your title", message: msgString, preferredStyle: .alert)
//                        let cancelButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//                        alert.addAction(cancelButton)
//                        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
//                        //self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//                        //TTS
////                        let synthesizer = AVSpeechSynthesizer()
////                        let utterance = AVSpeechUtterance(string : str)
////                        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
////                        utterance.rate = 0.4
////                        synthesizer.speak(utterance)
////                        self.showAlert(vc: mvc, title: "as", message: "dsa", actionTitle: "dsad", actionStyle: .default)
//                    }
//
//                }
                var personsList = [String : Any]()
                var objectString : String = "사진 속의 객체 : "
                var labelString : String = "사진 속의 디테일 객체 : "
                var totalString : String = ""
                let enter : String = "\n"
//                응답처리
                DispatchQueue.main.async {
                    do {
                        let object = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                        
                        personsList = object
                        
                        for item in (personsList["Object"] as! Array<Any>? as! Array<String>){
                            objectString += item
                            objectString += " "
                        }

                        for item in (personsList["Label"] as! Array<Any>? as! Array<String>){
                            labelString += item
                            labelString += " "
                        }
                        
                        var textFlag = 0
                        var tmptext = ""
                        
                        if let retText = personsList["Text"] as? String {
                            if (retText == ""){
                                print("NULL")
                            }
                            else{
                                totalString += "사진에 글자가 포함되어 있습니다."
                                totalString += enter
                                totalString += enter
                                textFlag = 1
                                tmptext += retText
                            }
                        }
                        else {
                            print("Error") // Was not a string
                        }
                        
                        totalString += objectString
                        totalString += enter
                        totalString += "."
                        totalString += labelString
                        totalString += enter
                        totalString += "."
                        
                        if (textFlag == 1){
                            totalString += "텍스트 : "
                            totalString += tmptext
                        }
                        
                        let alert = UIAlertController(title: "분석 결과", message: totalString, preferredStyle: .alert)
                        let cancelButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(cancelButton)
                        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                        
                        
                    } catch let e as NSError {
                        NSLog("An error has occurred: \(e.localizedDescription)")
                    }
                }
            }

            task.resume()
        }
         //POST전송
    }

    func applicationUserDidChangeClipboard(_ notification: Notification){
        
        if let theString = UIPasteboard.general.string{
            print("now : \(theString)")
        }
        print("clipboard change")
    }

}


//계층 뷰에서 최상위 뷰를 가져오기 위한 것
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
        return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
    }
    if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
    }
    return controller
} }





