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
    
    var downloadManager : VCWebNovelDownloadManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true;
        
        downloadManager = VCWebNovelDownloadManager()
        
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
