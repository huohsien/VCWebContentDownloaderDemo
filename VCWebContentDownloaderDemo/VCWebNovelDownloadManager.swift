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
import Kanna

enum VCWebNovelDownloadManagerStatus {
    case load
    case selectBook
    case fetchChapterList
}

class VCWebNovelDownloadManager: NSObject, WKNavigationDelegate {
    
    fileprivate var wkWebView : WKWebView!
    fileprivate var status : VCWebNovelDownloadManagerStatus!
    fileprivate var htmlContent : String?
    var bookName : String!
    
    override init() {
        super.init()
    
        status = .load
            
        DDLogVerbose("VCWDM:l - create web view")
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
            webView.evaluateJavaScript("document.getElementById('Keyword').value = '" + bookName + "'; var passFields = document.querySelectorAll(\"input[type='submit']\"); passFields[0].click()") { (result : Any?, error : Error?) in
                if error != nil {
                    DDLogError("VCWDM:wdn - error message: \(error.debugDescription)")
                } else {
                    self.status = .selectBook
                    webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (result : Any?, error : Error?) in
                        if error != nil {
                            DDLogError("VCWDM:wdn - error message: \(error.debugDescription)")
                        } else {

                            self.htmlContent = result as! String
                            
                        }
                    }
                }
                
            }
        } else if status == .selectBook {
            
            DDLogVerbose("VCWDM:wdn - parsing html to look for the book in search")

            if let doc = Kanna.HTML(html: htmlContent!, encoding: String.Encoding.utf8) {
                
                for node in doc.xpath("/html/body/div[0]/div[1]") {
                    print(node.text)
                }
                
            }
        }
        
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DDLogError("VCWDM:wdfnwe - error")
    }
    
}
