
//: Declare String Begin

/*: "Net Error, Try again later" :*/
fileprivate let themeFollowEvent:String = "Net trust document return print"
fileprivate let layoutDiskDevice:[Character] = [","," ","T","r","y"," ","a","g"]
fileprivate let themeProcessFeatureHairFormat:String = "ain lfeature prod fatal"

/*: "data" :*/
fileprivate let layoutElementSharedTitle:String = "DATA"

/*: ":null" :*/
fileprivate let screenHandleValue:[Character] = [":","n","u","l","l"]

/*: "json error" :*/
fileprivate let appLayerPath:String = "label item cancel confirmjson erro"
fileprivate let moduleActionTimer:[Character] = ["r"]

/*: "platform=iphone&version= :*/
fileprivate let layoutUsPage:[Character] = ["p","l","a","t","f","o","r","m","=","i","p","h","o","n"]
fileprivate let styleFailCameraChallengeMessage:String = "sub state shared starte&vers"

/*: &packageId= :*/
fileprivate let featureListCommunicationPage:String = "black frame&pac"

/*: &bundleId= :*/
fileprivate let componentOriginTimer:[Character] = ["&","b","u","n","d","l","e","I","d","="]

/*: &lang= :*/
fileprivate let viewNumberUtility:[Character] = ["&","l","a","n","g","="]

/*: ; build: :*/
fileprivate let featureFilterFormat:String = "; build:empty pic failure let object"

/*: ; iOS  :*/
fileprivate let layoutOfText:String = "give sub option present product; iOS "

//: Declare String End

//: import Alamofire
import Alamofire
//: import CoreMedia
import CoreMedia
//: import HandyJSON
import HandyJSON
// __DEBUG__
// __CLOSE_PRINT__
//: import UIKit
import UIKit

//: typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: AppErrorResponse?) -> Void
typealias FinishBlock = (_ succeed: Bool, _ result: Any?, _ errorModel: MisreckoningErrorResponse?) -> Void

//: @objc class AppRequestTool: NSObject {
@objc class RatingRequestTool: NSObject {
    /// 发起Post请求
    /// - Parameters:
    ///   - model: 请求参数
    ///   - completion: 回调
    //: class func startPostRequest(model: AppRequestModel, completion: @escaping FinishBlock) {
    class func block(model: ThatRequestModel, completion: @escaping FinishBlock) {
        //: let serverUrl = self.buildServerUrl(model: model)
        let serverUrl = self.micModel(model: model)
        //: let headers = self.getRequestHeader(model: model)
        let headers = self.observerCurrency(model: model)
        //: AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
        AF.request(serverUrl, method: .post, parameters: model.params, headers: headers, requestModifier: { $0.timeoutInterval = 10.0 }).responseData { [self] responseData in
            //: switch responseData.result {
            switch responseData.result {
            //: case .success:
            case .success:
                //: func__requestSucess(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)
                deadline(model: model, response: responseData.response!, responseData: responseData.data!, completion: completion)

            //: case .failure:
            case .failure:
                //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "Net Error, Try again later"))
                completion(false, nil, MisreckoningErrorResponse(errorCode: RaceWidthMagnitude.NetError.rawValue, errorMsg: (String(themeFollowEvent.prefix(4)) + "Error" + String(layoutDiskDevice) + String(themeProcessFeatureHairFormat.prefix(5)) + "ater")))
            }
        }
    }

    //: class func func__requestSucess(model: AppRequestModel, response: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
    class func deadline(model _: ThatRequestModel, response _: HTTPURLResponse, responseData: Data, completion: @escaping FinishBlock) {
        //: var responseJson = String(data: responseData, encoding: .utf8)
        var responseJson = String(data: responseData, encoding: .utf8)
        //: responseJson = responseJson?.replacingOccurrences(of: "\"data\":null", with: "\"data\":{}")
        responseJson = responseJson?.replacingOccurrences(of: "\"" + (layoutElementSharedTitle.lowercased()) + "\"" + (String(screenHandleValue)), with: "" + "\"" + (layoutElementSharedTitle.lowercased()) + "\"" + ":{}")
        //: if let responseModel = JSONDeserializer<AppBaseResponse>.deserializeFrom(json: responseJson) {
        if let responseModel = JSONDeserializer<ValueBaseResponse>.deserializeFrom(json: responseJson) {
            //: if responseModel.errno == RequestResultCode.Normal.rawValue {
            if responseModel.errno == RaceWidthMagnitude.Normal.rawValue {
                //: completion(true, responseModel.data, nil)
                completion(true, responseModel.data, nil)
                //: } else {
            } else {
                //: completion(false, responseModel.data, AppErrorResponse.init(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                completion(false, responseModel.data, MisreckoningErrorResponse(errorCode: responseModel.errno, errorMsg: responseModel.msg ?? ""))
                //: switch responseModel.errno {
                switch responseModel.errno {
//                case RaceWidthMagnitude.NeedReLogin.rawValue:
//                    NotificationCenter.default.post(name: DID_LOGIN_OUT_SUCCESS_NOTIFICATION, object: nil, userInfo: nil)
                //: default:
                default:
                    //: break
                    break
                }
            }
            //: } else {
        } else {
            //: completion(false, nil, AppErrorResponse.init(errorCode: RequestResultCode.NetError.rawValue, errorMsg: "json error"))
            completion(false, nil, MisreckoningErrorResponse(errorCode: RaceWidthMagnitude.NetError.rawValue, errorMsg: (String(appLayerPath.suffix(9)) + String(moduleActionTimer))))
        }
    }

    //: class func buildServerUrl(model: AppRequestModel) -> String {
    class func micModel(model: ThatRequestModel) -> String {
        //: var serverUrl: String = model.requestServer
        var serverUrl: String = model.requestServer
        //: let otherParams = "platform=iphone&version=\(AppNetVersion)&packageId=\(PackageID)&bundleId=\(AppBundle)&lang=\(UIDevice.interfaceLang)"
        let otherParams = (String(layoutUsPage) + String(styleFailCameraChallengeMessage.suffix(6)) + "ion=") + "\(layoutPathValue)" + (String(featureListCommunicationPage.suffix(4)) + "kageId=") + "\(widgetReplacePolicyValue)" + (String(componentOriginTimer)) + "\(themeNoLogger)" + (String(viewNumberUtility)) + "\(UIDevice.interfaceLang)"
        //: if !model.requestPath.isEmpty {
        if !model.requestPath.isEmpty {
            //: serverUrl.append("/\(model.requestPath)")
            serverUrl.append("/\(model.requestPath)")
        }
        //: serverUrl.append("?\(otherParams)")
        serverUrl.append("?\(otherParams)")

        //: return serverUrl
        return serverUrl
    }

    /// 获取请求头参数
    /// - Parameter model: 请求模型
    /// - Returns: 请求头参数
    //: class func getRequestHeader(model: AppRequestModel) -> HTTPHeaders {
    class func observerCurrency(model _: ThatRequestModel) -> HTTPHeaders {
        //: let userAgent = "\(AppName)/\(AppVersion) (\(AppBundle); build:\(AppBuildNumber); iOS \(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        let userAgent = "\(spacingVariableEvent)/\(widgetSumScaleTimeMessage) (\(themeNoLogger)" + (String(featureFilterFormat.prefix(8))) + "\(spacingTopicFormat)" + (String(layoutOfText.suffix(6))) + "\(UIDevice.current.systemVersion); \(UIDevice.modelName))"
        //: let headers = [HTTPHeader.userAgent(userAgent)]
        let headers = [HTTPHeader.userAgent(userAgent)]
        //: return HTTPHeaders(headers)
        return HTTPHeaders(headers)
    }
}
