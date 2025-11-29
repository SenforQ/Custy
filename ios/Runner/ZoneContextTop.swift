
//: Declare String Begin

/*: "rsycon" :*/
fileprivate let k_startSearchIndicatorTimer:String = "rsycofinish"

/*: "https://m. :*/
fileprivate let coreSchemeBridgeAlert:[Character] = ["h","t","t","p","s",":","/","/","m","."]

/*: .com" :*/
fileprivate let styleGrantEnvironmentTitle:[Character] = [".","c","o","m"]

/*: "1.9.1" :*/
fileprivate let commonFireRatingPreference:[Character] = ["1",".","9",".","1"]

/*: "988" :*/
fileprivate let layoutOnFollowPreference:[Character] = ["9","8","8"]

/*: "okh43p8t2800" :*/
fileprivate let layoutStopEvent:String = "OKH43P"

/*: "p5qz2r" :*/
fileprivate let styleSubDevice:String = "P5QZ2R"

/*: "CFBundleShortVersionString" :*/
fileprivate let kObjectSettings:String = "appear numberCFBund"
fileprivate let commonTopicContent:String = "rtVersgroup prod shared point succeed"
fileprivate let layoutToUtility:[Character] = ["i","o","n","S","t","r","i","n","g"]

/*: "CFBundleDisplayName" :*/
fileprivate let modulePendingPlatform:[Character] = ["C","F","B","u","n","d","l","e","D","i","s","p","l","a","y","N","a","m"]
fileprivate let widgetKnownAlert:[Character] = ["e"]

/*: "CFBundleVersion" :*/
fileprivate let appAlbumPath:String = "appear to text messageCFBundl"
fileprivate let styleUsedBasicDevice:[Character] = ["e","V","e","r","s","i","o","n"]

/*: "weixin" :*/
fileprivate let layoutArrayObjectSettings:[Character] = ["w","e","i","x","i","n"]

/*: "wxwork" :*/
fileprivate let spacingWarnEvent:String = "WXWORK"

/*: "dingtalk" :*/
fileprivate let spacingTrackDevice:String = "DINGTALK"

/*: "lark" :*/
fileprivate let spacingMainUtility:String = "larnetwork"

//: Declare String End

// __DEBUG__
// __CLOSE_PRINT__
//
//  ZoneContextTop.swift
//  OverseaH5
//
//  Created by young on 2025/9/24.
//

//: import KeychainSwift
import KeychainSwift
//: import UIKit
import UIKit

/// 域名
//: let ReplaceUrlDomain = "rsycon"
let spacingGroupPartModelHelper = (k_startSearchIndicatorTimer.replacingOccurrences(of: "finish", with: "n"))
//: let H5WebDomain = "https://m.\(ReplaceUrlDomain).com"
let screenReadPath = (String(coreSchemeBridgeAlert)) + "\(spacingGroupPartModelHelper)" + (String(styleGrantEnvironmentTitle))
/// 网络版本号
//: let AppNetVersion = "1.9.1"
let layoutPathValue = (String(commonFireRatingPreference))
/// 包ID
//: let PackageID = "988"
let widgetReplacePolicyValue = (String(layoutOnFollowPreference))
/// Adjust
//: let AdjustKey = "okh43p8t2800"
let coreArgumentPlatform = (layoutStopEvent.lowercased() + "8t2800")
//: let AdInstallToken = "p5qz2r"
let moduleEmptyTitle = (styleSubDevice.lowercased())

//: let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let widgetSumScaleTimeMessage = Bundle.main.infoDictionary![(String(kObjectSettings.suffix(6)) + "leSho" + String(commonTopicContent.prefix(6)) + String(layoutToUtility))] as! String
//: let AppBundle = Bundle.main.bundleIdentifier!
let themeNoLogger = Bundle.main.bundleIdentifier!
//: let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? ""
let spacingVariableEvent = Bundle.main.infoDictionary![(String(modulePendingPlatform) + String(widgetKnownAlert))] ?? ""
//: let AppBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
let spacingTopicFormat = Bundle.main.infoDictionary![(String(appAlbumPath.suffix(7)) + String(styleUsedBasicDevice))] as! String

//: class AppConfig: NSObject {
class ZoneContextTop: NSObject {
    /// 获取状态栏高度
    //: class func getStatusBarHeight() -> CGFloat {
    class func will() -> CGFloat {
        //: if #available(iOS 13.0, *) {
        if #available(iOS 13.0, *) {
            //: if let statusBarManager = UIApplication.shared.windows.first?
            if let statusBarManager = UIApplication.shared.windows.first?
                //: .windowScene?.statusBarManager
                .windowScene?.statusBarManager
            {
                //: return statusBarManager.statusBarFrame.size.height
                return statusBarManager.statusBarFrame.size.height
            }
            //: } else {
        } else {
            //: return UIApplication.shared.statusBarFrame.size.height
            return UIApplication.shared.statusBarFrame.size.height
        }
        //: return 20.0
        return 20.0
    }

    /// 获取window
    //: class func getWindow() -> UIWindow {
    class func startComponentGo() -> UIWindow {
        //: var window = UIApplication.shared.windows.first(where: {
        var window = UIApplication.shared.windows.first(where: {
            //: $0.isKeyWindow
            $0.isKeyWindow
            //: })
        })
        // 是否为当前显示的window
        //: if window?.windowLevel != UIWindow.Level.normal {
        if window?.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: return window!
        return window!
    }

    /// 获取当前控制器
    //: class func currentViewController() -> (UIViewController?) {
    class func methodStop() -> (UIViewController?) {
        //: var window = AppConfig.getWindow()
        var window = ZoneContextTop.startComponentGo()
        //: if window.windowLevel != UIWindow.Level.normal {
        if window.windowLevel != UIWindow.Level.normal {
            //: let windows = UIApplication.shared.windows
            let windows = UIApplication.shared.windows
            //: for windowTemp in windows {
            for windowTemp in windows {
                //: if windowTemp.windowLevel == UIWindow.Level.normal {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    //: window = windowTemp
                    window = windowTemp
                    //: break
                    break
                }
            }
        }
        //: let vc = window.rootViewController
        let vc = window.rootViewController
        //: return currentViewController(vc)
        return coveredBridge(vc)
    }

    //: class func currentViewController(_ vc: UIViewController?)
    class func coveredBridge(_ vc: UIViewController?)
        //: -> UIViewController?
        -> UIViewController?
    {
        //: if vc == nil {
        if vc == nil {
            //: return nil
            return nil
        }
        //: if let presentVC = vc?.presentedViewController {
        if let presentVC = vc?.presentedViewController {
            //: return currentViewController(presentVC)
            return coveredBridge(presentVC)
            //: } else if let tabVC = vc as? UITabBarController {
        } else if let tabVC = vc as? UITabBarController {
            //: if let selectVC = tabVC.selectedViewController {
            if let selectVC = tabVC.selectedViewController {
                //: return currentViewController(selectVC)
                return coveredBridge(selectVC)
            }
            //: return nil
            return nil
            //: } else if let naiVC = vc as? UINavigationController {
        } else if let naiVC = vc as? UINavigationController {
            //: return currentViewController(naiVC.visibleViewController)
            return coveredBridge(naiVC.visibleViewController)
            //: } else {
        } else {
            //: return vc
            return vc
        }
    }
}

// MARK: - Device

//: extension UIDevice {
extension UIDevice {
    //: static var modelName: String {
    static var modelName: String {
        //: var systemInfo = utsname()
        var systemInfo = utsname()
        //: uname(&systemInfo)
        uname(&systemInfo)
        //: let machineMirror = Mirror(reflecting: systemInfo.machine)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        //: let identifier = machineMirror.children.reduce("") {
        let identifier = machineMirror.children.reduce("") {
            //: identifier, element in
            identifier, element in
            //: guard let value = element.value as? Int8, value != 0 else {
            guard let value = element.value as? Int8, value != 0 else {
                //: return identifier
                return identifier
            }
            //: return identifier + String(UnicodeScalar(UInt8(value)))
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //: return identifier
        return identifier
    }

    /// 获取当前系统时区
    //: static var timeZone: String {
    static var timeZone: String {
        //: let currentTimeZone = NSTimeZone.system
        let currentTimeZone = NSTimeZone.system
        //: return currentTimeZone.identifier
        return currentTimeZone.identifier
    }

    /// 获取当前系统语言
    //: static var langCode: String {
    static var langCode: String {
        //: let language = Locale.preferredLanguages.first
        let language = Locale.preferredLanguages.first
        //: return language ?? ""
        return language ?? ""
    }

    /// 获取接口语言
    //: static var interfaceLang: String {
    static var interfaceLang: String {
        //: let lang = UIDevice.getSystemLangCode()
        let lang = UIDevice.communicationSystem()
        //: if ["en", "ar", "es", "pt"].contains(lang) {
        if ["en", "ar", "es", "pt"].contains(lang) {
            //: return lang
            return lang
        }
        //: return "en"
        return "en"
    }

    /// 获取当前系统地区
    //: static var countryCode: String {
    static var countryCode: String {
        //: let locale = Locale.current
        let locale = Locale.current
        //: let countryCode = locale.regionCode
        let countryCode = locale.regionCode
        //: return countryCode ?? ""
        return countryCode ?? ""
    }

    /// 获取系统UUID（每次调用都会产生新值，所以需要keychain）
    //: static var systemUUID: String {
    static var systemUUID: String {
        //: let key = KeychainSwift()
        let key = KeychainSwift()
        //: if let value = key.get(AdjustKey) {
        if let value = key.get(coreArgumentPlatform) {
            //: return value
            return value
            //: } else {
        } else {
            //: let value = NSUUID().uuidString
            let value = NSUUID().uuidString
            //: key.set(value, forKey: AdjustKey)
            key.set(value, forKey: coreArgumentPlatform)
            //: return value
            return value
        }
    }

    /// 获取已安装应用信息
    //: static var getInstalledApps: String {
    static var getInstalledApps: String {
        //: var appsArr: [String] = []
        var appsArr: [String] = []
        //: if UIDevice.canOpenApp("weixin") {
        if UIDevice.enableAllPermission((String(layoutArrayObjectSettings))) {
            //: appsArr.append("weixin")
            appsArr.append((String(layoutArrayObjectSettings)))
        }
        //: if UIDevice.canOpenApp("wxwork") {
        if UIDevice.enableAllPermission((spacingWarnEvent.lowercased())) {
            //: appsArr.append("wxwork")
            appsArr.append((spacingWarnEvent.lowercased()))
        }
        //: if UIDevice.canOpenApp("dingtalk") {
        if UIDevice.enableAllPermission((spacingTrackDevice.lowercased())) {
            //: appsArr.append("dingtalk")
            appsArr.append((spacingTrackDevice.lowercased()))
        }
        //: if UIDevice.canOpenApp("lark") {
        if UIDevice.enableAllPermission((spacingMainUtility.replacingOccurrences(of: "network", with: "k"))) {
            //: appsArr.append("lark")
            appsArr.append((spacingMainUtility.replacingOccurrences(of: "network", with: "k")))
        }
        //: if appsArr.count > 0 {
        if appsArr.count > 0 {
            //: return appsArr.joined(separator: ",")
            return appsArr.joined(separator: ",")
        }
        //: return ""
        return ""
    }

    /// 判断是否安装app
    //: static func canOpenApp(_ scheme: String) -> Bool {
    static func enableAllPermission(_ scheme: String) -> Bool {
        //: let url = URL(string: "\(scheme)://")!
        let url = URL(string: "\(scheme)://")!
        //: if UIApplication.shared.canOpenURL(url) {
        if UIApplication.shared.canOpenURL(url) {
            //: return true
            return true
        }
        //: return false
        return false
    }

    /// 获取系统语言
    /// - Returns: 国际通用语言Code
    //: @objc public class func getSystemLangCode() -> String {
    @objc public class func communicationSystem() -> String {
        //: let language = NSLocale.preferredLanguages.first
        let language = NSLocale.preferredLanguages.first
        //: let array = language?.components(separatedBy: "-")
        let array = language?.components(separatedBy: "-")
        //: return array?.first ?? "en"
        return array?.first ?? "en"
    }
}
