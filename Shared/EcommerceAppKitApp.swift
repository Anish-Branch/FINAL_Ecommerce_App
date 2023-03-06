//
//  EcommerceAppKitApp.swift
//  Shared
//
//  Created by Balaji on 26/11/21.
//

import SwiftUI
import BranchSDK

@main
struct EcommerceAppKitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    Branch.getInstance().handleDeepLink(url)
                })
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        //Branch.getInstance().validateSDKIntegration()
        Branch.getInstance().enableLogging()
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
            
            // Check for a "productId" parameter and navigate to the corresponding view
            if let productId = params?["$canonical_url"] as? String {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute:{
                    NotificationCenter.default.post(name: Notification.Name("HANDLEDEEPLINK"), object: nil, userInfo: ["product_id": productId])
                })
            }
        }
        return true
    }
}
