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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true;
                
        DDLogVerbose("verbose");
        DDLogWarn("warn");

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
