//
//  AppDelegate.swift
//  clipboard
//
//  Created by 김준성 on 2020/06/01.
//  Copyright © 2020 김준성. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
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
            let os = "ios다 됐냐?"
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
                    NSLog("An error has occurred: \(e.localizedDescription)")
                    return
                }

                //응답처리
                DispatchQueue.main.async {
                    do {
                        let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        guard let jsonObject = object else {return}

                        NSLog("post json data = %@", jsonObject)

                    } catch let e as NSError {
                        NSLog("An error has occurred: \(e.localizedDescription)")
                    }
                }
            }

            task.resume()
        }
         //POST전송
    }
    
    
    
    
    
    //        let sessionConfig = URLSessionConfiguration.default
    //        let urlString = "http://13.251.164.73:5555/list"
    //
    //        if let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: encodeString){
    //            var request = URLRequest(url: url)
    //            request.httpMethod = "POST"
    //
    //            let params = dicToQuery(["os" : "android", "url" : "@@@@@@@@@@@@@@@@@@@@@@@"])
    //            request.httpBody = params.data(using: String.Encoding.utf8, allowLossyConversion: true)
    //
    //            let urlSession = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    ////            let sessionTask = urlSession.dataTask(with: request){
    ////                (data, response, error) in dataFromURLCompletionClosure(response,data)
    ////            }
    //            sessionTask.resume()




func applicationUserDidChangeClipboard(_ notification: Notification){
    
    if let theString = UIPasteboard.general.string{
        print("now : \(theString)")
    }
    print("clipboard change")
}

}









