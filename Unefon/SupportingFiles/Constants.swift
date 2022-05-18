//
//  Constants.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import Foundation
import UIKit

// let baseUrl:String = "https://inspirum-unefon-development.azurewebsites.net/"   // DEV
 let baseUrl:String = "https://inspirum-unefon.azurewebsites.net/"   // PROD

var k_SelectedTabBarIndex:Int = 0
let k_baseColor:UIColor = UIColor.colorWithHexString("#449ED6")
let k_window:UIWindow = UIApplication.shared.delegate!.window! as! UIWindow
let k_appDel:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
let localTimeZoneName: String = TimeZone.current.localizedName(for: .generic, locale: .current) ?? ""
let k_helper:Helper = Helper.shared
let k_userDef = UserDefaults.standard
let timestamp = Date().timeIntervalSince1970
var deviceToken_FCM = ""
var deviceToken = ""
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
// let platformAccessToken = "16a4bd1a40d8c6342ad19172dd31eade" // Dev
 let platformAccessToken = "16a4bd1a40d8c6342ad19172dd31eade" // PROD
var isPad: Bool{
    return (UIDevice.current.userInterfaceIdiom == .phone) ? false : true
}
typealias CompletionHandler = ([String:Any], String, Error?) -> ()

enum ServiceName:String
{
//    case POST_Login = "users/new_validate_credentials"
    case POST_Login = "users/new_validate_credentials_2"
    case GET_ActivePlans = "plans/active"
    case GET_UserPreRegistration = "users/validate_user_pre_registration"
    case GET_WorkplacesList = "workplaces/get"
    case GET_StatesList = "catalogues/get"
    case POST_UploadProfileImageTemp = "temporal-media/upload_file"
    case POST_UploadProfilepic = "users/profile_picture/update"
    case PUT_AnalyseProfilePic = "users/auto_analyze_profile_picture"
    case PUT_AnalyseBadgePic = "users/auto_analyze_id_evidence"
    case GET_SendCodeEmail = "security-codes/send_to_mail"
    case GET_SendCodeValidate = "security-codes/validate"
//    case GET_SendCodePhone = "security-codes/send_to_phone"
    case POST_RegisterNewUser = "users/register"
    case GET_ForgotPasswordCode = "users/request_password_security_code"
    case POST_UpdatePassword = "users/update_user_password"
    case GET_Dashboards = "users/dashboard"
    case GET_Ranking = "leaderboards/users"
    case GET_History = "users/historical_data/overview/get?uuid="
    case GET_PerformanceWrapper = "wrappers/performance?uuid="
    case GET_RewardsWrapper = "wrappers/rewards?uuid="
    case GET_Operations = "users/transactions/points/simplified?uuid="
    case GET_Operations_2 = "users/transactions/tokens/simplified?uuid="
    case GET_CanjearList = "gifts/available/container?uuid="
    case GET_CanjearList_2 = "physical_products/available/container?uuid="
    case GET_RankingWrapper = "wrappers/leaderboard?uuid="
    case GET_EmailWrapper = "wrappers/inbox?uuid="
    case GET_FeedWrapper = "wrappers/feed?uuid="
    case GET_History_ViewInfo = "users/historical_data/performance_summary/get?uuid=+AA+&month_id="
    case GET_historical_performance = "wrappers/performance/historical_performance?uuid=+AA+&period_id="
    case GET_NewsDetail = "announcements/get_active"
    case GET_SingleAnnouncement = "announcements/get_single"
    case GET_SinglePromotion = "promotions/get_single"
    case DELETE_Logout = "notifications/release/ios"
    case GET_EmailList = "inbox/get_summary"
    case GET_EmailDetail = "inbox/mail/get"
    case PUT_SetFavorite = "inbox/mail/mark_as_favorite"
    case PUT_SetUnFavorite = "inbox/mail/unmark_as_favorite"
    case GET_Objectives = "users/quick_guide/get"
    case GET_FAQlist = "discussion/posts/get_for_user"
    case POST_SearchFaq = "discussion/posts/search"
    case GET_FAQPost = "discussion/posts/get_full_post"
    case POST_FAQLike = "discussion/posts/replies/up_vote"
    case POST_FAQDisLike = "discussion/posts/replies/down_vote"
    case POST_FAQDMarkSolution = "discussion/posts/replies/mark_as_solution"
    case POST_FAQCreatePost = "discussion/posts/create"
    case GET_PointsDetail = "users/transactions/balance"
    case GET_TransactionSales = "achievements/get"
    case GET_TransactionRedemptions = "redemptions/get"
    case GET_UserGifts = "gifts/get_available_for_user"
    case GET_GiftDetail = "gifts/get_details_for_user"
    case POST_previewBuyGiftPost = "gifts/codes/preview_request"
    case POST_SubmitBuyGiftPost = "gifts/codes/request"
//    case GET_UserWalletList = "gifts/wallet/get"   commented on 23Sep19
    case PUT_AcceptTermsWalletGift = "gifts/codes/accept_tc"
    case PUT_EnviarType1 = "gifts/codes/reports/send_code_to_mail"
    case GET_MyProfile = "users/personal_information/get"
    case POST_UpdateMyProfile = "users/personal_information/update"
    case GET_OtpCode = "users/request_security_code"
    case POST_UpdateEmail = "users/update_user_mail_address"
    case POST_UpdatePhone = "users/update_user_phone_number"
    case GET_ContactHeader = "platform/assistance_information"
    case GET_ContactHeaderDashboard = "plans/assistance_information"
    case GET_UserTicketsContact = "support_tickets/get_by_user"
    case GET_TicketDetail = "support_tickets/get"
    case POST_CreateTicket = "support_tickets/rise"
    case GET_UserWalletDownloadPDF = "gifts/codes/reports/consolidated_file"
    case GET_PhysicalProductsStore = "physical_products/get_available_for_user"
    case GET_PhysicalProductsStoreMyOrder = "physical_products/requests/get_from_user"
    case GET_PhysicalProductsStoreDetails = "physical_products/get_details_for_user"
    case POST_PhysicalProductPreview = "physical_products/preview_request"
    case GET_VarDetail_Code = "gifts/codes/detailed"
    case GET_VarDetail_Code_1 = "physical_products/requests/detailed"
    case POST_PhysicalProductFinal = "physical_products/request"
    case GET_CodeRequest_1 = "gifts/codes/requests/grouped/expanded"
    case GET_CodeRequest_2 = "physical_products/requests/grouped/expanded"
    case GET_UserWalletList = "users/rewards/get"
    case GET_Ranking_General = "leaderboards/general"
    case GET_Ranking_Regional = "leaderboards/regional"
    case GET_EachGiftSelectt = "gifts/user_information"
    case GET_EachProductSelectt = "physical_products/user_information"
    case GET_RecompansesDropdown1 = "gifts/codes/requests/grouped"
    case GET_UserProfile = "wrappers/profile"
    case GET_RecompansesDropdown2 = "physical_products/requests/grouped"
    case GET_EnterList = "courses/get_active"
    case GET_EnterListDetail = "courses/get"
    case GET_Point_Operation = "users/transactions/points/simplified/details"
    case GET_Token_Operation = "users/transactions/tokens/simplified/details"
    case GET_EnterQuiz = "courses/quizz/get_for_user"
    case POST_SubmitQuiz = "courses/quizz/answers/submit"
    case POST_TrackerVerMosTap = "courses/interactions/opening"
    case POST_TrackerFileTap = "courses/interactions/download"
    case POST_TrackerVideoStart = "courses/interactions/video_start"
    case POST_TrackerVideoEnd = "courses/interactions/video_end"
    case PUT_MarkAsRead = "inbox/mail/multiple/mark_as_read"
    case PUT_MarkAsUnRead = "inbox/mail/multiple/mark_as_unread"
}

enum userDefaultKeys :String
{
    case uuid = "Inspirum_uuid"
    case plan_id = "Inspirum_planid"
    case user_Loginid = "Inspirum_LoginId"
}

struct CustomFont
{
    static let regular = "Roboto-Regular"
    static let semiBold = "Roboto-Medium"
    static let bold = "Roboto-Bold"
    static let light = "Roboto-Thin"
    static let italic = "Roboto-Italic"
}

enum AppStoryBoards : String
{
    case Main, Register, HomeTabBarVC, Dashboard, NewsDetail, PointsDetail, Ranking, EmailDetail, Entertainment, FAQ, Contact, Profile, Objectives
    case Activaciones
    case Rankings
    case Recompensas
    case Anuncios
    case EmailSupport
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

/*
 struct CustomFont
 {
     static let robotoBlack = "Roboto-Black"
     static let robotoBlackItalic = "Roboto-BlackItalic"
     static let robotoBold = "Roboto-Bold"
     static let robotoBoldIralic = "Roboto-BoldItalic"
     static let robotoItalic = "Roboto-Italic"
     static let robotoLight = "Roboto-Light"
     static let robotoLightItalic = "Roboto-LightItalic"
     static let robotoMedium = "Roboto-Medium"
     static let robotoMediumItalic = "Roboto-MediumItalic"
     static let robotoRegular = "Roboto-Regular"
     static let robotoThin = "Roboto-Thin"
     static let robotoThinItalic = "Roboto-ThinItalic"
 }
 */
