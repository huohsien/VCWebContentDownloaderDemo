//
//  VCSearchViewController.swift
//  VCWebContentDownloaderDemo
//
//  Created by victor on 04/05/2017.
//  Copyright © 2017 VHHC Studio. All rights reserved.
//

import UIKit
import CocoaLumberjack

class VCSearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var downloadManager : VCWebNovelDownloadManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true;
        
        downloadManager = VCWebNovelDownloadManager()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let searchTextFieldFrame = self.searchTextField.frame
        let searchButtonFrame = self.searchButton.frame
        
        let frame = CGRect(x: searchTextFieldFrame.origin.x , y:searchTextFieldFrame.origin.y + searchTextFieldFrame.size.height + 20 , width: searchButtonFrame.origin.x + searchButtonFrame.size.width - searchTextFieldFrame.origin.x, height: self.view.frame.size.height - searchTextFieldFrame.size.height - searchButtonFrame.size.height - 40)
        downloadManager.wkWebView.frame = frame
        self.view.addSubview(downloadManager.wkWebView)
//        print(downloadManager.wkWebView.frame)
        
        DDLogVerbose("VCSVC:obp - parsing html to look for the book in search")
        if let htmlContent = VCHelper.readTextFrom(file: self.searchTextField.text! + ".txt") {
            if let doc = Kanna.HTML(html: htmlContent, encoding: String.Encoding.utf8) {
                
                for node in doc.xpath("//div[@class='result-item result-game-item']/div/@onclick") {
                    print("---------------------------")
                    print((node.text)!)
                    
                }
                
            }
 
        }
       
    }
    @IBAction func okButtonPressed(_ sender: Any) {
        
        downloadManager.bookName = searchTextField.text
        downloadManager.load()
        
    }
    
    @IBAction func touchedOutside(_ sender: Any) {
        self.searchTextField.resignFirstResponder()
    }

}

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
}
