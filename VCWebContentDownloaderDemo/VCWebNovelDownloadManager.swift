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

class VCWebNovelDownloadManager: NSObject, WKNavigationDelegate {
    
    var wkWebView : WKWebView!
    fileprivate var status : VCWebNovelDownloadManagerStatus!
    fileprivate var htmlContent : String?
    var bookName : String!
    
    override init() {
        super.init()
    
        status = .load
            
        DDLogVerbose("VCWDM:i - create web view")
        wkWebView = WKWebView(frame:.zero)
        wkWebView.navigationDelegate = self
        
    }
    
    func load() {
        
        let url = URL(string: GlobalConstants.baseURLString)!
        DDLogVerbose("VCWDM:l - load url = \(url)")
        wkWebView.load(URLRequest(url: url))
        
    }
    
// MARK: - WKNavigationDelegates

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        if status == .load {
            DDLogVerbose("VCWDM:wdn - evaluate javascript to search book")
            webView.evaluateJavaScript("document.getElementById('Keyword').value = '" + bookName + "'; var passFields = document.querySelectorAll(\"input[type='submit']\"); passFields[1].click()") { (result : Any?, error : Error?) in

                if error != nil {
                    DDLogError("VCWDM:wdn - error message: \(error.debugDescription)")
                } else {
                    self.status = .selectBook
                }
            }
        } else if status == .selectBook {
            
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (result : Any?, error : Error?) in
                if error != nil {
                    DDLogError("VCWDM:wdn - error message: \(error.debugDescription)")
                } else {
                    if result != nil {
                        self.htmlContent = (result as! String)
                        // write to file
                        VCHelper.writeTo(file: self.bookName + ".txt", text: self.htmlContent)
                    } else {
                        DDLogError("VCWDM:wdn - nothing returned from the web server")
                    }
                    
                }
            }
        }
        
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DDLogError("VCWDM:wdfnwe - error")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
//        if let urlStr = navigationAction.request.url?.absoluteString {
//            DDLogVerbose("VCWDM:wdnd - url = \(urlStr)")
//        }
        decisionHandler(.allow)
    }

}
