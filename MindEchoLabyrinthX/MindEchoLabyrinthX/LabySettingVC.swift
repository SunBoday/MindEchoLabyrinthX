//
//  LabySettingVC.swift
//  MindEchoLabyrinthX
//
//  Created by SunTory on 2025/2/10.
//

import UIKit
import StoreKit

class LabySettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRate(_ sender: UIButton) {
        
        SKStoreReviewController.requestReview()
        
    }

    
    @IBAction func share(_ sender: Any) {
        
        let textToShare = "Check out this amazing app!"
        let appStoreURL = "MindEcho LabyrinthX"
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare, appStoreURL], applicationActivities: nil)
        
        // Exclude certain activity types if desired
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        
        present(activityViewController, animated: true, completion: nil)
    }
  
}
