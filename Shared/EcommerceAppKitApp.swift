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
        
        Branch.getInstance().enableLogging()
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
            
            // Check for a "productId" parameter and navigate to the corresponding view
            if let productId = params?["$canonical_url"] as? String {
                let productView = ProductView(productId: productId)
                let contentView = ContentView()
                    .environmentObject(productView)
                // navigate to the product view
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: false, completion: nil)
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: contentView)
                }
            }
        }
        
        return true
    }
}

class ProductView: ObservableObject {
    let productId: String
    
    init(productId: String) {
        self.productId = productId
    }
    
    // Add code to display the product with the given ID
}
