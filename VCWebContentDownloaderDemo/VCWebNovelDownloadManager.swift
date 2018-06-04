//
//  VCWebNovelDownloadManager.swift
//  VCWebContentDownloaderDemo
//
//  Created by victor on 25/05/2017.
//  Copyright © 2017 VHHC Studio. All rights reserved.
//

import UIKit
import WebKit
import CocoaLumberjack

enum VCWebNovelDownloadManagerStatus {
    case load
    case selectBook
    case fetchChapterList
}

class VCWebNovelDownloadManager: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    
    var wkWebView : WKWebView!
    fileprivate var status : VCWebNovelDownloadManagerStatus!
    fileprivate var htmlContent : String?
    var bookName : String!
    
    override init() {
        super.init()
    
        status = .load
            
        DDLogVerbose("create web view")
        wkWebView = WKWebView(frame:.zero)
        wkWebView.navigationDelegate = self
        wkWebView.configuration.userContentController.add(self, name: "observe")
        
    }
    
    func load() {
        
        let url = URL(string: GlobalConstants.baseURLString)!
        DDLogVerbose("load url = \(url)")
        wkWebView.load(URLRequest(url: url))
        
    }
// MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        DDLogVerbose("message=\(message.body)")
    }
    
// MARK: - WKNavigationDelegates

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        let urlString = webView.url!.absoluteString
        DDLogVerbose("web loading finished. url = \(urlString)")
        

        if status == .load {
            DDLogVerbose("evaluate javascript to search book")
            
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (result : Any?, error : Error?) in
                if error != nil {
                    DDLogError("error message: \(error.debugDescription)")
                } else {
                    if result != nil {
                        self.htmlContent = (result as! String)
                        // write to file
                        VCHelper.writeTo(file: self.bookName + ".txt", text: self.htmlContent)
                    } else {
                        DDLogError("nothing returned from the web server")
                    }
                    
                }
            }
            webView.evaluateJavaScript("document.getElementById('s_key').value = '" + bookName + "'; document.createElement('form').submit.call(document.forms['articlesearch']);") { (result : Any?, error : Error?) in

                if error != nil {
                    DDLogError("error message: \(error.debugDescription)")
                } else {
                    self.status = .selectBook

                }
            }
        } else if status == .selectBook {
            
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (result : Any?, error : Error?) in
                if error != nil {
                    DDLogError("error message: \(error.debugDescription)")
                } else {
                    if result != nil {
                        self.htmlContent = (result as! String)
                        // write to file
                        VCHelper.writeTo(file: self.bookName + ".txt", text: self.htmlContent)
                    } else {
                        DDLogError("nothing returned from the web server")
                    }
                    
                }
            }
        }
        
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DDLogError("web loading failed. url = \(webView.url!.absoluteString)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
//        if let urlStr = navigationAction.request.url?.absoluteString {
//            DDLogVerbose("VCWDM:wdnd - url = \(urlStr)")
//        }
        decisionHandler(.allow)
    }

}
