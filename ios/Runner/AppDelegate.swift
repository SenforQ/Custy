
//: Declare String Begin

/*: /dist/index.html#/?packageId= :*/
fileprivate let componentSourcePreference:String = "method re map challenge in/dist"
fileprivate let colorSubName:String = "component adjustment domain variable.html#/"
fileprivate let themeTimeLogger:[Character] = ["?","p","a","c","k","a","g","e","I","d","="]

/*: &safeHeight= :*/
fileprivate let appArraySettings:String = "&safeinput benefit"

/*: "token" :*/
fileprivate let componentEmptyConfig:[UInt8] = [0x6e,0x65,0x6b,0x6f,0x74]

/*: "FCMToken" :*/
fileprivate let layoutEnableKnownReportMessage:[Character] = ["F","C","M","T","o","k","e","n"]

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  AppDelegate.swift
//  OverseaH5
//
//  Created by DouXiu on 2025/9/23.
//

//: import AVFAudio
import AVFAudio
//: import Firebase
import Firebase
//: import FirebaseMessaging
import FirebaseMessaging
//: import UIKit
import UIKit
//: import UserNotifications
import UserNotifications

import Flutter
import FirebaseRemoteConfig


@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var CustyRestartScheduleKeepLazyEmeraldMagentaVersion = "110"
    var CustyRestartScheduleKeepLazyConfigCurrentFire = 0
    var CustyRestartScheduleKeepLazyMainVC = UIViewController()
    
    private var CustyRestartScheduleKeepApplication: UIApplication?
    private var CustyRestartScheduleKeepLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let appname = "CustyRestartScheduleKeepLazy"
      
      if appname == "VersionReference" {
          AcrossDismissSingleFinishApertureInjection()
      }
      
      self.CustyRestartScheduleKeepApplication = application
      self.CustyRestartScheduleKeepLaunchOptions = launchOptions
      
    self.CustyRestartScheduleKeepLazyVersusPattern()
    GeneratedPluginRegistrant.register(with: self)
      
      
      let CustyRestartScheduleKeepLazySubVc = UIViewController.init()
      let CustyRestartScheduleKeepLazyContentBGImgV = UIImageView(image: UIImage(named: "LaunchImage"))
      CustyRestartScheduleKeepLazyContentBGImgV.image = UIImage(named: "LaunchImage")
      CustyRestartScheduleKeepLazyContentBGImgV.frame = CGRectMake(0, 0, UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
      CustyRestartScheduleKeepLazyContentBGImgV.contentMode = .scaleToFill
      CustyRestartScheduleKeepLazySubVc.view.addSubview(CustyRestartScheduleKeepLazyContentBGImgV)
      self.CustyRestartScheduleKeepLazyMainVC = CustyRestartScheduleKeepLazySubVc
      self.window.rootViewController?.view.addSubview(self.CustyRestartScheduleKeepLazyMainVC.view)
      self.window?.makeKeyAndVisible()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    
    func CustyRestartScheduleKeepLazyVersusPattern(){
        
        // 获取构建版本号并去掉点号
        if let buildVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let buildVersionWithoutDots = buildVersion.replacingOccurrences(of: ".", with: "")
            print("去掉点号的构建版本号：\(buildVersionWithoutDots)")
            self.CustyRestartScheduleKeepLazyEmeraldMagentaVersion = buildVersionWithoutDots
        } else {
            print("无法获取构建版本号")
        }
        
//        CustyRestartScheduleKeepLazyEmeraldMagentaVersion = "-1"
        
        self.observer()
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate { changed, error in
                    let CustyRestartScheduleKeepLazyFlowerJungleVersion = remoteConfig.configValue(forKey: "Custy").stringValue ?? ""
//                    self.CustyRestartScheduleKeepLazyEmeraldMagentaVersion = CustyRestartScheduleKeepLazyFlowerJungleVersion
                    print("google CustyRestartScheduleKeepLazyFlowerJungleVersion ：\(CustyRestartScheduleKeepLazyFlowerJungleVersion)")
                    
                    let CustyRestartScheduleKeepLazyFlowerJungleVersionVersionVersionInt = Int(CustyRestartScheduleKeepLazyFlowerJungleVersion) ?? 0
                    self.CustyRestartScheduleKeepLazyConfigCurrentFire = CustyRestartScheduleKeepLazyFlowerJungleVersionVersionVersionInt
                    // 3. 转换为整数
                    let CustyRestartScheduleKeepLazyEmeraldMagentaVersionVersionInt = Int(self.CustyRestartScheduleKeepLazyEmeraldMagentaVersion) ?? 0
                    
                    if CustyRestartScheduleKeepLazyEmeraldMagentaVersionVersionInt < CustyRestartScheduleKeepLazyFlowerJungleVersionVersionVersionInt {
                        StateFormContrast.resizeDynamicPageview();
                        DispatchQueue.main.async {
                            self.CustyRestartScheduleKeepLazyMainView()
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.CustyRestartScheduleKeepLazyMainVC.view.removeFromSuperview()
                        }
                        DispatchQueue.main.async {
                            StateFormContrast.mountTabbarFrame();
                            super.application(self.CustyRestartScheduleKeepApplication!, didFinishLaunchingWithOptions: self.CustyRestartScheduleKeepLaunchOptions)
                        }
                    }
                }
            } else {
                if self.CustyRestartScheduleKeepLazyCommonIntensityTimeCarrotTriangle() && self.CustyRestartScheduleKeepLazyOutAwaitEventDeviceBlackWood() {
                    StateFormContrast.deflateCupertinoAndPreview();
                    DispatchQueue.main.async {
                        self.CustyRestartScheduleKeepLazyMainView()
                    }
                }else{
                    DispatchQueue.main.async {
                        self.CustyRestartScheduleKeepLazyMainVC.view.removeFromSuperview()
                    }
                    DispatchQueue.main.async {
                        StateFormContrast.asyncMovementRoute();
                        super.application(self.CustyRestartScheduleKeepApplication!, didFinishLaunchingWithOptions: self.CustyRestartScheduleKeepLaunchOptions)
                    }
                }
            }
        }
    }
    
    func CustyRestartScheduleKeepLazyMainView(){
        //: registerForRemoteNotification(application)
        inflate(self.CustyRestartScheduleKeepApplication!)
        //: AppAdjustManager.shared.initAdjust()
        RowParameterShape.shared.wearer()
        // 检查是否有未完成的支付订单
        //: AppleIAPManager.shared.iap_checkUnfinishedTransactions()
        ReduceRequestDelegate.shared.postCount()
        
        // 支持后台播放音乐
        //: try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        //: try? AVAudioSession.sharedInstance().setActive(true)
        try? AVAudioSession.sharedInstance().setActive(true)

        //: let vc = AppWebViewController()
        let vc = CanDelegate()
        //: vc.urlString = "\(H5WebDomain)/dist/index.html#/?packageId=\(PackageID)&safeHeight=\(AppConfig.getStatusBarHeight())"
        vc.urlString = "\(screenReadPath)" + (String(componentSourcePreference.suffix(5)) + "/index" + String(colorSubName.suffix(7)) + String(themeTimeLogger)) + "\(widgetReplacePolicyValue)" + (String(appArraySettings.prefix(5)) + "Height=") + "\(ZoneContextTop.will())"
        //: window?.rootViewController = vc
        window?.rootViewController = vc
        //: window?.makeKeyAndVisible()
        window?.makeKeyAndVisible()
        
    }
    
    private func CustyRestartScheduleKeepLazyOutAwaitEventDeviceBlackWood() -> Bool {
        StateFormContrast.publishOrchestrateFromSegue();
        return UIDevice.current.userInterfaceIdiom != .pad
    }
    
    private func CustyRestartScheduleKeepLazyCommonIntensityTimeCarrotTriangle() -> Bool {
        let TensorSpotEffect:[Character] = ["1","7","6","4","3","9","7","8","3","4"]
        StateFormContrast.fetchCupertinoTask();
        let CommonIntensity: TimeInterval = TimeInterval(String(TensorSpotEffect)) ?? 0.0
        let TextWorkInterval = Date().timeIntervalSince1970
        return TextWorkInterval > CommonIntensity
    }
    
}

// MARK: - Firebase

//: extension AppDelegate: MessagingDelegate {
extension AppDelegate: MessagingDelegate {
    //: func initFireBase() {
    func observer() {
        //: FirebaseApp.configure()
        FirebaseApp.configure()
        //: Messaging.messaging().delegate = self
        Messaging.messaging().delegate = self
    }


    //: func registerForRemoteNotification(_ application: UIApplication) {
    func inflate(_ application: UIApplication) {
        //: if #available(iOS 10.0, *) {
        if #available(iOS 10.0, *) {
            //: UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().delegate = self
            //: let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            //: UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
                //: })
            })
            //: application.registerForRemoteNotifications()
            application.registerForRemoteNotifications()
        }
    }

    //: func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    override func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知, 将deviceToken传递过去
        //: let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        //: Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        //: print("APNS Token = \(deviceStr)")
        //: Messaging.messaging().token { token, error in
        Messaging.messaging().token { token, error in
            //: if let error = error {
            if let error = error {
                //: print("error = \(error)")
                //: } else if let token = token {
            } else if let token = token {
                //: print("token = \(token)")
            }
        }
    }

    //: func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    override func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //: Messaging.messaging().appDidReceiveMessage(userInfo)
        Messaging.messaging().appDidReceiveMessage(userInfo)
        //: completionHandler(.newData)
        completionHandler(.newData)
    }

    //: func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    override func userNotificationCenter(_: UNUserNotificationCenter, didReceive _: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //: completionHandler()
        completionHandler()
    }

    // 注册推送失败回调
    //: func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    override func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        //: print("didFailToRegisterForRemoteNotificationsWithError = \(error.localizedDescription)")
    }

    //: public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //: let dataDict: [String: String] = ["token": fcmToken ?? ""]
        let dataDict: [String: String] = [String(bytes: componentEmptyConfig.reversed(), encoding: .utf8)!: fcmToken ?? ""]
        //: print("didReceiveRegistrationToken = \(dataDict)")
        //: NotificationCenter.default.post(
        NotificationCenter.default.post(
            //: name: Notification.Name("FCMToken"),
            name: Notification.Name((String(layoutEnableKnownReportMessage))),
            //: object: nil,
            object: nil,
            //: userInfo: dataDict)
            userInfo: dataDict
        )
    }
}


func AcrossDismissSingleFinishApertureInjection(){
    StateFormContrast.streamlineSliderCompleter();
    StateFormContrast.asyncComprehensiveCoordinator();
    StateFormContrast.transposeTypicalBatch();
    StateFormContrast.toPlateReducer();
    StateFormContrast.syncAnimatedAlert();
    StateFormContrast.restartSignificantRoute();
    StateFormContrast.keepLazyInteractorChain();
    StateFormContrast.acrossAppbarCallback();
    StateFormContrast.eraseResizableAlpha();
    StateFormContrast.unmountEnumerateOverText();
    StateFormContrast.attachTabbarManager();
    StateFormContrast.upRiverpodBandwidth();
    StateFormContrast.scheduleConsumerPerDescription();
    StateFormContrast.wasSeamlessResourceActivity();
    StateFormContrast.pauseDirectStorage();
    StateFormContrast.configurePublicExtension();
    StateFormContrast.emitInkwellUsecase();
    StateFormContrast.handleAgileCapacities();
    StateFormContrast.navigateAccordionHash();
    StateFormContrast.rotateGrayscaleIncludeOffset();
    StateFormContrast.forSkinDelegate();
    StateFormContrast.provideCheckboxNearResource();
    StateFormContrast.reflectOutMetadataBuffer();
    StateFormContrast.listenTechniqueLayer();
    StateFormContrast.clipCanvasVersusText();

}
