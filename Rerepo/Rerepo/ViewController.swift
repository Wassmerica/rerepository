//
//  ViewController.swift
//  Rerepo
//
//  Created by Michael Wasserman on 2019-02-04.
//  Copyright © 2019 Michael Wasserman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig

class ViewController: UIViewController {

    @IBOutlet weak var labelOutlet: UILabel!
    var remoteConfig: RemoteConfig!
    
    let welcomeMessageConfigKey     = "welcome_message"
    let welcomeMessageCapsConfigKey = "welcome_message_caps"
    let loadingPhraseConfigKey      = "loading_phrase"
    let testParamConfigKey = "test_param"
    var welcomeString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.remoteConfig = RemoteConfig.remoteConfig()
        
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.setDefaults(fromPlist: "defaults")
        
        fetchConfig()
    }
    
    func fetchConfig() {
        welcomeString = remoteConfig[loadingPhraseConfigKey].stringValue!
        
        var expirationDuration = 3600
        // If your app is using developer mode, expirationDuration is set to 0, so each fetch will
        // retrieve values from the service.
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        // [START fetch_config_with_callback]
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
        // [END fetch_config_with_callback]
    }
    
    func displayWelcome() {
        // [START get_config_value]
        var welcomeMessage = remoteConfig[welcomeMessageConfigKey].stringValue
        // [END get_config_value]
        
        if remoteConfig[welcomeMessageCapsConfigKey].boolValue {
            welcomeMessage = welcomeMessage?.uppercased()
        }
        welcomeString = welcomeMessage!
        print(welcomeString)
    }
    

}

