//
//  ViewController.swift
//  clipboard
//
//  Created by 김준성 on 2020/06/01.
//  Copyright © 2020 김준성. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var goBackBttn: UIButton!
    @IBOutlet weak var goForwardBttn: UIButton!
    @IBOutlet weak var reloadBttn: UIButton!
    @IBOutlet weak var linkView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        urlTextField.delegate = self
        linkView.layer.addBorder([.bottom], color: UIColor.black, width: 1.0)
        let myURL =  URL(string: "https://naver.com")
        let myReq = URLRequest(url: myURL!)
        webView.load(myReq)
        webView.allowsBackForwardNavigationGestures = true
    }
    @IBAction func reloadPageAct(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func goBackAct(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func goForwardAct(_ sender: Any) {
        webView.goForward()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        goBackBttn.isEnabled = webView.canGoBack
        goForwardBttn.isEnabled = webView.canGoForward
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        urlTextField.selectedTextRange = urlTextField.textRange(from: urlTextField.beginningOfDocument, to: urlTextField.endOfDocument)
        urlTextField.selectAll(nil)
    }
    
    
    
    
    //주소창 부분 주소 넣고, go키보드 눌렀을 때의 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        var urlTF : String = urlTextField.text ?? "https://naver.com"
        if urlTF.hasPrefix("https://") || urlTF.hasPrefix("http://"){
            
        }
        else{
            urlTF = "https://" + urlTF
        }
    
        let newURL = URL(string: urlTF)
        let newReq = URLRequest(url: newURL!)
        webView.load(newReq)
        return true
    }
}


extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}



