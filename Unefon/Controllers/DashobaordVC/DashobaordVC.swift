//
//  DashobaordVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class DashobaordVC: UIViewController {
    
    @IBOutlet weak var btnMenu:UIButton!
    @IBOutlet weak var viewSlide:UIView!
    @IBOutlet weak var viewSlideLayer:UIView!
    @IBOutlet weak var viewTransparent:UIView!
    @IBOutlet weak var tblViewMain:UITableView!
    @IBOutlet weak var tblViewMenu:UITableView!
    
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_vSmallYellow_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_vSmallYellow_Bt:NSLayoutConstraint!
    
    @IBOutlet weak var c_TblMenu_Tr_iPad:NSLayoutConstraint!
    
    var carouselViewReff: AACarousel!
    var caraouselIndexReff:Int = 0
    
    let isDetailClickViewForTokenBalanceTag = 2001
    var strTokenBalance = ""
    
    // let arrMenu: Array<String> = ["Inicio", "Mis puntos", "Canjear", "Entrenamiento", "Foro de discusión", "Reglas y Objetivos", "Modificar mi Información Personal", "Cambiar contraseña", "Cambiar mi correo", "Cambiar mi número de teléfono", "Contacto", "Cerrar sesión"]
    
    let arrMenu: Array<String> = ["Inicio", "Mis Puntos", "Canjear", "Entrenamiento", "Foro de Discusión", "Reglas y Objetivos", "Modificar mi información Personal", "Cambiar Contraseña", "Cambiar mi Correo", "Cerrar sesión"]
    
    var arrMain: Array<String> = ["Scroller", "Detalles-Canjear", "PointBalance", "Points", "Ranking", "Objectives", "Entertainment", "Rewards" , "Email", "Faq"]
    
    
    var strRegion_Title = ""
    var strRegion_SubTitle = ""
    var arrNews: [[String:Any]] = []
    var dMyPoints: [String:Any] = [:]
    var dPointsHeader: [String:Any] = [:]
    var balance:Int = 0
    var dictMain: [String:Any] = [:]
    var imgArray: [String] = []
    var LoginUserID = "AT&T"
    var userImgUrl = ""
    var selectedMenu = "Inicio"
    
    var arrRegions: [[String:Any]] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func callViewWillAppearios13(notfication: NSNotification) {
        self.viewWillAppear(true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callViewWillAppearios13(notfication:)), name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        
        setUpTopBar()
        
        if isPad
        {
            c_TblMenu_Tr_iPad.constant = 200
        }
        
        self.viewSlideLayer.isHidden = true
        viewSlide.frame = CGRect(x: (UIScreen.main.bounds.minX - UIScreen.main.bounds.width), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        if let id:String = k_userDef.value(forKey: userDefaultKeys.user_Loginid.rawValue) as? String
        {
            LoginUserID = id
        }
        
        let menuViewTapped = UITapGestureRecognizer(target: self, action: #selector(self.slideViewTapped))
        viewSlideLayer.addGestureRecognizer(menuViewTapped)
        viewSlideLayer.isUserInteractionEnabled = true
        
        viewTransparent.addGestureRecognizer(menuViewTapped)
        viewTransparent.isUserInteractionEnabled = true
        
        self.perform(#selector(self.hideSlideView), with: nil, afterDelay: 0.1)
        
        tblViewMenu.delegate = self
        tblViewMenu.dataSource = self
    }
    
    @objc func hideSlideView()
    {
        viewSlide.frame = CGRect(x: (UIScreen.main.bounds.minX - UIScreen.main.bounds.width), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    @IBAction func slideMenuClick(btn:UIButton)
    {
        // Show Side Menu
        
        self.viewSlideLayer.alpha = 0.6
        self.viewTransparent.alpha = 0.0
        self.viewSlideLayer.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.viewTransparent.alpha = 0.05
            self.viewSlide.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        })
    }
    
    @objc func slideViewTapped()
    {        
        // Hide Side Menu
        self.viewTransparent.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.viewSlideLayer.alpha = 0.0
            self.viewSlideLayer.isHidden = true
            self.viewSlide.frame = CGRect(x: (UIScreen.main.bounds.minX - UIScreen.main.bounds.width), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        })
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_TopBar_Ht.constant = 90
            c_vSmallYellow_Ht.constant = 50
            c_vSmallYellow_Bt.constant = -50
        }
        else if strModel == "iPhone Max"
        {
            c_TopBar_Ht.constant = 90
            c_vSmallYellow_Ht.constant = 50
            c_vSmallYellow_Bt.constant = -50
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else{
            c_TopBar_Ht.constant = 110
            c_vSmallYellow_Ht.constant = 70
            c_vSmallYellow_Bt.constant = -70
        }
        
        if isPad == true
        {
            c_vSmallYellow_Ht.constant = 35
            c_vSmallYellow_Bt.constant = -35
        }
    }
}

extension DashobaordVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .all : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        slideViewTapped() // when orientation happen, hide menu
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}

extension DashobaordVC: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblViewMenu
        {
            let headerCell: CellMenu_Header = tblViewMenu.dequeueReusableCell(withIdentifier: "CellMenu_Header") as! CellMenu_Header
            headerCell.selectionStyle = .none
            
            headerCell.imgView.layer.cornerRadius = 50.0
            headerCell.imgView.layer.borderWidth = 1.5
            headerCell.imgView.layer.masksToBounds = true
            headerCell.imgView.clipsToBounds = true
            headerCell.imgView.contentMode = .scaleAspectFill
            
            if isPad == true
            {
                headerCell.c_img_Ht_iPad.constant = 134
                headerCell.c_img_Wd_iPad.constant = 134
                headerCell.imgView.layer.cornerRadius = 67.0
            }
            
            headerCell.imgView.setImageUsingUrl(self.userImgUrl)
            
            headerCell.lblTitle.text = LoginUserID
            
            return headerCell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblViewMenu
        {
            // MENU
            if isPad
            {
                return 190
            }
            else
            {
                // phone
                return 150
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblViewMain
        {
            return arrMain.count
        }
        else
        {
            // MENU
            return arrMenu.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblViewMain
        {
            let strMain:String = arrMain[indexPath.row]
            
            if strMain == "Scroller"
            {
                if isPad == true
                {
                    return 260
                }
                else
                {
                    // Phone
                    return 180
                }
            }
            else if strMain == "Region"
            {
                return CGFloat(100 + (self.arrRegions.count * 160))
            }
            else if strMain == "Points"
            {
                return 420
            }
            else
            {
                // rest cases
                if isPad == true
                {
                    return 260
                }
                else
                {
                    // Phone
                    return 180
                }
            }
        }
        else
        {
            // MENU
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblViewMain
        {
            let strMain:String = arrMain[indexPath.row] 
            
            if strMain == "Scroller"
            {
                let cell:CellMain_Scroller = tblViewMain.dequeueReusableCell(withIdentifier: "CellMain_Scroller", for: indexPath) as! CellMain_Scroller
                cell.selectionStyle = .none
                cell.lblTitle.text = "...."
                cell.lblSubTitle.text = "...."
                cell.vTransBlack.isHidden = false
                
                if self.arrNews.count > 0
                {
                    let dic:[String:Any] = self.arrNews.first!
                    // print(dic)
                    if let type:Bool = dic["type"] as? Bool
                    {
                        if type == true
                        {
                            if let title:String = dic["title"] as? String
                            {
                                if title.count > 20
                                {
                                    cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                }
                                else
                                {
                                    cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
                                }
                                cell.lblTitle.text = title
                            }
                            if let subTitle:String = dic["content"] as? String
                            {
                                cell.lblSubTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                cell.lblSubTitle.text = subTitle
                            }
                        }
                        else
                        {
                            cell.vTransBlack.isHidden = true
                        }
                    }
                }
                
                if cell.carouselView.delegate == nil
                {
                    cell.carouselView.delegate = self
                    cell.carouselView.setCarouselData(paths: imgArray,  describedTitle: [], isAutoScroll: true, timer: 2.7, defaultImage: "ph")
                }
                
                //optional method
                cell.carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
                cell.carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
                
                cell.carouselView.indexChangeClosure = { (index) in
                    //   print("Change the Labels here - - - Scroller - ", index)
                    
                    cell.lblTitle.text = ""
                    cell.lblSubTitle.text = ""
                    
                    if self.arrNews.count > 0
                    {
                        let dic:[String:Any] = self.arrNews[index]
                        
                        cell.vTransBlack.isHidden = false
                        
                        if let type:Bool = dic["type"] as? Bool
                        {
                            if type == true
                            {
                                if let title:String = dic["title"] as? String
                                {
                                    if title.count > 20
                                    {
                                        cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                    }
                                    else
                                    {
                                        cell.lblTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
                                    }
                                    cell.lblTitle.text = title
                                }
                                if let subTitle:String = dic["content"] as? String
                                {
                                    cell.lblSubTitle.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                    //  padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
                                    cell.lblSubTitle.text = subTitle
                                }
                            }
                            else
                            {
                                cell.vTransBlack.isHidden = true
                            }
                        }
                    }
                    
                    self.caraouselIndexReff = index
                }
                
                carouselViewReff = cell.carouselView
                cell.btn.addTarget(self, action: #selector(self.btnCaraouselClick(btn:)), for: .touchUpInside)
                
                return cell
            }
            else if strMain == "Region"
            {
                let cell:CellMain_Regions = tblViewMain.dequeueReusableCell(withIdentifier: "CellMain_Regions", for: indexPath) as! CellMain_Regions
                cell.selectionStyle = .none
                cell.vBk.layer.cornerRadius = 5.0
                cell.vBk.layer.masksToBounds = true
                
                cell.lblTitle.text = strRegion_Title
                cell.lblSubTitle.text = strRegion_SubTitle
                cell.arrData = self.arrRegions
                
                return cell
            }
            else if strMain == "Detalles-Canjear"
            {
                let cell:CellPointsDetail_Header = tableView.dequeueReusableCell(withIdentifier: "CellPointsDetail_Header", for: indexPath) as! CellPointsDetail_Header
                cell.selectionStyle = .none
                
                cell.viewBk.layer.cornerRadius = 5.0
                cell.viewBk.layer.masksToBounds = true
                cell.btnDetails.layer.cornerRadius = 5.0
                cell.btnDetails.layer.masksToBounds = true
                cell.btnExchange.layer.cornerRadius = 5.0
                cell.btnExchange.layer.masksToBounds = true
                cell.lblTitle.text = ""
                cell.lblMessage.text = ""
                
                cell.btnDetails.tag = indexPath.row
                
                cell.btnDetails.addTarget(self, action: #selector(self.btnDetailsHeaderClick(btn:)), for: .touchUpInside)
                cell.btnExchange.addTarget(self, action: #selector(self.btnExchangeHeaderClick(btn:)), for: .touchUpInside)
                
                if let str:Int = dPointsHeader["balance"] as? Int
                {
                    var formatedCurrency = "\(str)".toCurrencyFormat()
                    formatedCurrency = formatedCurrency.components(separatedBy: ".").first!
                    formatedCurrency = formatedCurrency.replacingOccurrences(of: "$", with: "")
                    cell.lblTitle.text = formatedCurrency
                }
                
                cell.lblMessage.text = "Puntos Disponibles para Canjear"
                return cell
            }
            else if strMain == "PointBalance"
            {
                let cell:CellMain_PointBalance = tableView.dequeueReusableCell(withIdentifier: "CellMain_PointBalance", for: indexPath) as! CellMain_PointBalance
                cell.selectionStyle = .none
                
                cell.viewBk.layer.cornerRadius = 5.0
                cell.viewBk.layer.masksToBounds = true
                cell.btnDetails.layer.cornerRadius = 5.0
                cell.btnDetails.layer.masksToBounds = true
                cell.lblTitle.text = ""
                cell.lblPoints.text = ""
                
                cell.btnDetails.tag = isDetailClickViewForTokenBalanceTag
                
                cell.btnDetails.addTarget(self, action: #selector(self.btnDetailsHeaderClick(btn:)), for: .touchUpInside)
                
                cell.lblPoints.text = strTokenBalance
                
                cell.lblTitle.text = "Tokens Disponibles para Canjear"
                return cell
            }
            else if strMain == "Points"
            {
                let cell:CellMain_Points = tblViewMain.dequeueReusableCell(withIdentifier: "CellMain_Points", for: indexPath) as! CellMain_Points
                cell.selectionStyle = .none
                
                cell.viewBk.layer.cornerRadius = 5.0
                cell.viewBk.layer.masksToBounds = true
                cell.btnHistory.layer.cornerRadius = 5.0
                cell.btnHistory.layer.masksToBounds = true
                // cell.btnExchange.layer.cornerRadius = 5.0
                //  cell.btnExchange.layer.masksToBounds = true
                
                cell.btnHistory.addTarget(self, action: #selector(self.btnHistoryClick(btn:)), for: .touchUpInside)
                // cell.btnExchange.addTarget(self, action: #selector(self.btnExchangeClick(btn:)), for: .touchUpInside)
                
                cell.lblTitle.text = ""
                cell.lblMessage.text = ""
                cell.lblMonthlyFee.text = ""
                cell.lblScope.text = ""
                cell.lblActivation.text = ""
                cell.lblPoints.text = ""
                
                if let str:String = dMyPoints["period"] as? String
                {
                    cell.lblTitle.text = str
                }
                if let str:String = dMyPoints["message"] as? String
                {
                    cell.lblMessage.text = str
                }
                if let str:String = dMyPoints["kpis_str"] as? String
                {
                    cell.lblMonthlyFee.text = str
                }
                if let str:String = dMyPoints["performance_str"] as? String
                {
                    cell.lblScope.text = str
                }
                if let str:String = dMyPoints["user_registered_sales_quantity_str"] as? String
                {
                    cell.lblActivation.text = str
                }
                if let str:String = dMyPoints["user_registered_sales_points_str"] as? String
                {
                    cell.lblPoints.text = str
                }
                return cell
            }
            else
            {
                let cell:CellMain_Rest = tblViewMain.dequeueReusableCell(withIdentifier: "CellMain_Rest", for: indexPath) as! CellMain_Rest
                cell.selectionStyle = .none
                
                cell.viewBk.layer.cornerRadius = 5.0
                cell.viewBk.layer.masksToBounds = true
                cell.viewlayer.layer.cornerRadius = 5.0
                cell.viewlayer.layer.masksToBounds = true
                cell.viewlayer.isHidden = true
                cell.viewlayer.isUserInteractionEnabled = false
                
                cell.lblTitle.textColor = .white
                cell.lblSubTitle.textColor = k_baseColor
                
                cell.imgV_Bk.image = nil
                
                if strMain == "Ranking"
                {
                    // cell.viewlayer.isHidden = false
                    
                    cell.imgV_Bk.image = UIImage(named: "bk_Ranking")
                    
                    cell.viewBk.backgroundColor = UIColor(red: 252.0/255.0, green: 50.0/255.0, blue: 81.0/255.0, alpha: 1.0)
                    //  cell.viewBk.backgroundColor = UIColor.colorWithHexString("#EC5B67")
                    cell.imgView.image = UIImage(named: "icon_ RANKING")
                    cell.lblTitle.text = "RANKING"
                    cell.lblSubTitle.text = "DISTRIBUIDORES"
                }
                else if strMain == "Email"
                {
                    cell.imgV_Bk.image = UIImage(named: "bk_Correo")
                    
                    cell.viewBk.backgroundColor = UIColor.colorWithHexString("#4AA79A")
                    cell.imgView.image = UIImage(named: "icon_ CORREO")
                    cell.lblTitle.text = "BANDEJA DE"
                    cell.lblSubTitle.text = "CORREO"
                }
                else if strMain == "Entertainment"
                {
                    cell.imgV_Bk.image = UIImage(named: "bk_Capacitacion")
                    
                    cell.viewBk.backgroundColor = UIColor.white
                    cell.imgView.image = UIImage(named: "icon_ CAPACITACIÓN")
                    cell.lblTitle.text = "CENTRO DE"
                    cell.lblSubTitle.text = "CAPACITACIÓN"
                }
                if strMain == "Rewards"
                {
                    cell.imgV_Bk.image = UIImage(named: "bk_Recompensas")
                    
                    cell.viewBk.backgroundColor = UIColor.colorWithHexString("#2D2D2D")
                    cell.imgView.image = UIImage(named: "icon_ RECOMPENSAS")
                    cell.lblTitle.text = "MIS"
                    cell.lblSubTitle.text = "RECOMPENSAS"
                }
                else if strMain == "Faq"
                {
                    cell.imgV_Bk.image = UIImage(named: "bk_Respuestas")
                    
                    //cell.viewBk.backgroundColor = UIColor.colorWithHexString("#EC5B67")
                    cell.viewBk.backgroundColor = UIColor(red: 252.0/255.0, green: 50.0/255.0, blue: 81.0/255.0, alpha: 1.0)
                    cell.imgView.image = UIImage(named: "icon_ RESPUESTAS")
                    cell.lblTitle.text = "PREGUNTAS Y"
                    cell.lblSubTitle.text = "RESPUESTAS"
                }
                if strMain == "Objectives"
                {
                    cell.imgV_Bk.image = UIImage(named: "bk_Objectives")
                    
                    cell.viewBk.backgroundColor = UIColor.colorWithHexString("#564593")
                    cell.imgView.image = UIImage(named: "icon_ OBJETIVOS")
                    cell.lblTitle.text = "REGLAS Y"
                    cell.lblSubTitle.text = "OBJETIVOS"
                }
                
                return cell
            }
        }
        else
        {
            // MENU
            let cell:CellMenu_Rows = tblViewMenu.dequeueReusableCell(withIdentifier: "CellMenu_Rows", for: indexPath) as! CellMenu_Rows
            cell.selectionStyle = .none
            
            cell.lblTitle.textColor = .darkGray
            
            let strMenu:String = arrMenu[indexPath.row]
            
            cell.lblTitle.font = UIFont(name: CustomFont.semiBold, size: 17.0)
            
            if selectedMenu == strMenu
            {
                cell.lblTitle.textColor = k_baseColor
            }
            
            cell.lblTitle.text = strMenu
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == tblViewMain
        {
            let strMain:String = arrMain[indexPath.row]
            /*
             if strMain != "Ranking"
             {
             print("Tapped main -> ",strMain)
             navigateToVC(name: strMain)
             }
             */
            print("Tapped main -> ",strMain)
            navigateToVC(name: strMain)
        }
        else
        {
            // MENU
            let strMenu:String = arrMenu[indexPath.row]
            print("Tapped MENU -> ",strMenu)
            selectedMenu = strMenu
            slideViewTapped()
            navigateToVCFromMenu(name: strMenu)
        }
    }
    
    func navigateToVC(name:String)
    {
        if name == "Ranking"
        {
            let vc: RankingListVC = AppStoryBoards.Ranking.instance.instantiateViewController(withIdentifier: "RankingListVC_ID") as! RankingListVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
            
        }
        else if name == "Email"
        {
            let vc: EmailFavListVC = AppStoryBoards.EmailDetail.instance.instantiateViewController(withIdentifier: "EmailFavListVC_ID") as! EmailFavListVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Entertainment"
        {
            let vc: EntListVC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListVC_ID") as! EntListVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Rewards"
        {
            let vc: WalletVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "WalletVC_ID") as! WalletVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Faq"
        {
            let vc: FAQlistVC = AppStoryBoards.FAQ.instance.instantiateViewController(withIdentifier: "FAQlistVC_ID") as! FAQlistVC
            self.presentModal(vc: vc)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
        }
        else if name == "Objectives"
        {
            let vc: ObjectiveBaseVC = AppStoryBoards.Objectives.instance.instantiateViewController(withIdentifier: "ObjectiveBaseVC_ID") as! ObjectiveBaseVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
    }
    
    func navigateToVCFromMenu(name:String)
    {
        
        if name == "Contacto"
        {
            let vc: ContactVC = AppStoryBoards.Contact.instance.instantiateViewController(withIdentifier: "ContactVC_ID") as! ContactVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Mis Puntos"
        {
            let vc: PointsDetailVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "PointsDetailVC_ID") as! PointsDetailVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Entrenamiento"
        {
            let vc: EntListVC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListVC_ID") as! EntListVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Canjear"
        {
            let vc: ExchangeListVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ExchangeListVC_ID") as! ExchangeListVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Reglas y Objetivos"
        {
            let vc: ObjectiveBaseVC = AppStoryBoards.Objectives.instance.instantiateViewController(withIdentifier: "ObjectiveBaseVC_ID") as! ObjectiveBaseVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Foro de Discusión"
        {
            let vc: FAQlistVC = AppStoryBoards.FAQ.instance.instantiateViewController(withIdentifier: "FAQlistVC_ID") as! FAQlistVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Modificar mi información Personal"
        {
            let vc: ProfileVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "ProfileVC_ID") as! ProfileVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Cambiar Contraseña"
        {
            let vc: ChangePasswordVC = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Cambiar mi Correo"
        {
            let vc: ChangeEmailVC = ChangeEmailVC(nibName: "ChangeEmailVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Cambiar mi número de teléfono"
        {
            let vc: ChangePhoneNumberVC = ChangePhoneNumberVC(nibName: "ChangePhoneNumberVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalPresentationCapturesStatusBarAppearance = true
            self.presentModal(vc: vc)
        }
        else if name == "Cerrar sesión"
        {
            let alertController = UIAlertController(title: "Cerrar sesión", message: "Estás seguro de que quieres desconectarte?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "sí", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("Yes Logout Pressed")
                self.callLogoutApi()
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Logout Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: Scroller Delegate
extension DashobaordVC: AACarouselDelegate
{
    //require method
    func downloadImages(_ url: String, _ index:Int)
    {
        let imageView1 = UIImageView()
        
        imageView1.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "ph"), options: [.transition(.fade(1))], progressBlock: nil) { (downloadImage, error, cacheType, url) in
            if downloadImage != nil && self.carouselViewReff != nil
            {
                self.carouselViewReff.images[index] = downloadImage!
            }
        }
    }
    
    //optional method (show first image faster during downloading of all images)
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        
        imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "ph"))
    }
    
    //optional method (interaction for touch image)
    func didSelectCarouselView(_ view:AACarousel ,_ index:Int) {
        
        print(index)
        calltakeToNewsDetail()
    }
}

extension DashobaordVC
{
    // MARK: Stop Start Scroller on Leaving Page
    override func viewWillDisappear(_ animated: Bool) {
        self.carouselViewReff.stopScrollImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.carouselViewReff != nil
        {
            // self.carouselViewReff.startScrollImageView()
        }
        
        callGetDashboards()
    }
}

extension DashobaordVC
{
    @objc func btnHistoryClick(btn:UIButton)
    {
        print("Take to View History Module")
        
        let vc: HistoricalVC = AppStoryBoards.Dashboard.instance.instantiateViewController(withIdentifier: "HistoricalVC_ID") as! HistoricalVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.presentModal(vc: vc)
    }
    
    @objc func btnExchangeClick(btn:UIButton)
    {
        let vc: ExchangeListVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ExchangeListVC_ID") as! ExchangeListVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.presentModal(vc: vc)
    }
    
    @objc func btnCaraouselClick(btn:UIButton)
    {
        print("Caraosel Tapped at - ",self.caraouselIndexReff)
        
        calltakeToNewsDetail()
    }
}

extension DashobaordVC
{
    func callGetDashboards()
    {
        self.arrMain = ["Scroller", "Detalles-Canjear", "PointBalance", "Points", "Ranking", "Objectives", "Entertainment", "Rewards" , "Email", "Faq"]
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        var version:String = ""
        if appVersion != nil{
            version = appVersion!
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "ios_app_version": version, "android_app_version": "", "ios_notification_token": deviceToken_FCM]
        
        WebService.requestService(url: ServiceName.GET_Dashboards.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //       print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        self.strRegion_Title = ""
                        self.strRegion_SubTitle = ""
                        self.imgArray.removeAll()
                        self.arrNews.removeAll()
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let dRegion: [String:Any] = dict["regions_widget"] as? [String:Any]
                            {
                                if let check:Bool = dRegion["display_regions_widget"] as? Bool
                                {
                                    if check == true
                                    {
                                        // add a new widget in MainArray, if false then don't add
                                        
                                        self.arrMain[4] = "Region"
                                        
                                        if let arrRe: [[String:Any]] = dRegion["regions"] as? [[String:Any]]
                                        {
                                            self.arrRegions = arrRe
                                        }
                                        if let str: String = dRegion["description_1"] as? String
                                        {
                                            self.strRegion_Title = str
                                        }
                                        if let str: String = dRegion["description_2"] as? String
                                        {
                                            self.strRegion_SubTitle = str
                                        }
                                    }
                                }
                            }
                            
                            if let checkLogout: Bool = dict["force_logout"] as? Bool
                            {
                                if checkLogout == true{
                                    let alertController = UIAlertController(title: "Alerta", message: "Tu sesión ha expirado. Por favor inicia sesión de nuevo.", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        NSLog("Yes Logout Pressed")
                                        self.callLogoutApi()
                                    }
                                    alertController.addAction(okAction)
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                            
                            if let dToken: [String:Any] = dict["account_balance"] as? [String:Any]
                            {
                                if let str: String = dToken["tokens_balance_str"] as? String
                                {
                                    self.strTokenBalance = str
                                }
                            }
                            
                            if let arrDictNews: [[String:Any]] = dict["news"] as? [[String:Any]]
                            {
                                self.arrNews = arrDictNews
                                for d in arrDictNews
                                {
                                    if let imgStr:String = d["cover_url"] as? String
                                    {
                                        self.imgArray.append(imgStr)
                                    }
                                }
                            }
                            if let di: [String:Any] = dict["current_progress"] as? [String:Any]
                            {
                                self.dMyPoints = di
                            }
                            if let di: [String:Any] = dict["user_summary"] as? [String:Any]
                            {
                                if let str:String = di["profile_picture_full_res_url"] as? String
                                {
                                    self.userImgUrl = str
                                }
                            }
                            
                            if let checkUpdate:Int = dict["require_software_update"] as? Int
                            {
                                if checkUpdate == 1
                                {
                                    // Show Alert to update
                                    self.showAlertWithTitle(title: "Alerta", message: "Hay una nueva versión de la app disponible.", okButton: "Instalar", cancelButton: "Ahora No", okSelectorName: #selector(self.takeToStore))
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.callGetPointsDetail()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func takeToStore()
    {
        let urlStr = "itms-apps://itunes.apple.com/app/id1476927295" //"itms-apps://itunes.apple.com/app/radio-fm/id1004413147?mt=12"
        UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
        
        
        // var appID: String = infoDictionary["CFBundleIdentifier"]
        // var url = URL(string: "http://itunes.apple.com/lookup?bundleId=1476927295")
        // https://apps.apple.com/in/app/whatsapp-desktop/id1147396723?mt=12
        // Homechow : "itunes.apple.com/us/app/homechow/id1435002621?ls=1&mt=8"
    }
    
    func calltakeToNewsDetail()
    {
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan_id.rawValue) as? String
        {
            plan_id = id
        }
        if plan_id == ""
        {
            return
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_NewsDetail.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //   print(jsonString)
            if error != nil
            {
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        
                        if let arrresp:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            DispatchQueue.main.async {
                                let vc: NewsListVC = AppStoryBoards.NewsDetail.instance.instantiateViewController(withIdentifier: "NewsListVC_ID") as! NewsListVC
                                vc.arrData = arrresp
                                vc.modalPresentationStyle = .overFullScreen
                                vc.modalPresentationCapturesStatusBarAppearance = true
                                self.presentModal(vc: vc)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callLogoutApi()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["ios_notification_token":deviceToken_FCM]
        WebService.requestService(url: ServiceName.DELETE_Logout.rawValue, method: .delete, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //   print(jsonString)
            if error != nil
            {
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                print("USER LOGOUT - - - - - - - ")
                DispatchQueue.main.async {
                    k_userDef.setValue("", forKey: userDefaultKeys.uuid.rawValue)
                    k_userDef.setValue("", forKey: userDefaultKeys.plan_id.rawValue)
                    //                k_userDef.setValue("", forKey: userDefaultKeys.user_Loginid.rawValue) don't empty show in Login
                    k_userDef.synchronize()
                    
                    let vc: LoginVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "LoginVC_ID") as! LoginVC
                    k_window.rootViewController = vc
                }
            }
        }
    }
}

extension DashobaordVC
{
    func callGetPointsDetail()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        WebService.requestService(url: ServiceName.GET_PointsDetail.rawValue, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //  print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Error", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "Error", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.dictMain = dict
                            
                            k_helper.tempViewTransactionDictFromHistoryVC = dict
                            
                            if let bal: Int = dict["balance"] as? Int
                            {
                                self.dPointsHeader["balance"] = bal
                                self.balance = bal
                                k_helper.tempViewTransactionBalanceFromHistoryVC = bal
                            }
                            
                            /*
                             if let str: String = dict["kpis_str"] as? String
                             {
                             self.dPointsWidget["kpis_str"] = str
                             
                             if let str1: String = dict["performance_str"] as? String
                             {
                             self.dPointsWidget["performance_str"] = str1
                             }
                             if let str2: String = dict["user_registered_sales_quantity_str"] as? String
                             {
                             self.dPointsWidget["user_registered_sales_quantity_str"] = str2
                             }
                             if let str3: String = dict["user_registered_sales_points_str"] as? String
                             {
                             self.dPointsWidget["user_registered_sales_points_str"] = str3
                             }
                             if let str4: String = dict["message"] as? String
                             {
                             self.dPointsWidget["message"] = str4
                             }
                             if let str5: String = dict["period"] as? String
                             {
                             self.dPointsWidget["period"] = str5
                             }
                             }
                             */
                            
                            DispatchQueue.main.async {
                                if self.tblViewMain.delegate == nil
                                {
                                    self.tblViewMain.delegate = self
                                    self.tblViewMain.dataSource = self
                                }
                                self.tblViewMain.reloadData()
                                self.tblViewMenu.reloadData()
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func btnDetailsHeaderClick(btn:UIButton)
    {
        if btn.tag == isDetailClickViewForTokenBalanceTag
        {
            // its token balance widget
            if let arr: [[String:Any]] = dictMain["token_transactions"] as? [[String:Any]]
            {
                var balanceToken:Int = 0
                if let bal: Int = dictMain["tokens_balance"] as? Int
                {
                    balanceToken = bal
                }
                let vc: PointdetailTransactionsVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "PointdetailTransactionsVC_ID") as! PointdetailTransactionsVC
                vc.arrData = arr
                vc.balance = balanceToken
                vc.isDisableDetailClickOnTap = true
                
                if let str: String = dictMain["period"] as? String
                {
                    print(str)
                }
                vc.strBalanceSubHeader = "Tokens Disponibles para Canjear"
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                self.presentModal(vc: vc)
            }
        }
        else
        {
            if let arr: [[String:Any]] = dictMain["transactions"] as? [[String:Any]]
            {
                let vc: PointdetailTransactionsVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "PointdetailTransactionsVC_ID") as! PointdetailTransactionsVC
                vc.arrData = arr
                vc.balance = self.balance
                if let str: String = dictMain["period"] as? String
                {
                    print(str)
                    //
                }
                vc.modalPresentationStyle = .overFullScreen
                vc.modalPresentationCapturesStatusBarAppearance = true
                vc.strBalanceSubHeader = "Puntos Disponibles para Canjear"
                self.presentModal(vc: vc)
            }
        }
    }
    
    @objc func btnExchangeHeaderClick(btn:UIButton)
    {
        let vc: ExchangeListVC = AppStoryBoards.PointsDetail.instance.instantiateViewController(withIdentifier: "ExchangeListVC_ID") as! ExchangeListVC
        vc.check_From_PointsDetailVC_ForNotfCenter = false
        vc.modalPresentationStyle = .overFullScreen
        vc.modalPresentationCapturesStatusBarAppearance = true
        self.presentModal(vc: vc)
    }
}
