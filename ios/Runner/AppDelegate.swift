import UIKit
import Flutter
import GoogleMaps
import NaverThirdPartyLogin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCnLTJJP6gzqLw3ZgWc7sttIYF6_4ouYYk")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
// naver
//   override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]?) -> Bool {
//     return NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
// }

// kakao & naver login, combined for not to get a conflict
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var result = false
        
        NSLog("URL = \(url.absoluteString)")
        
        if url.absoluteString.hasPrefix("kakao"){
            result = super.application(app, open: url, options: options)
        }
        if !result {
            result = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        }
        
        return result
    }

}



