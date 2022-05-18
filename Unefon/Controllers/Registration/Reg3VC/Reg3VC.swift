//
//  Reg3VC.swift
//  Unefon
//
//  Created by Abhishek Visa on 27/6/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Reg3VC: UIViewController {
    
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var lbl3:UILabel!
    @IBOutlet weak var lbl4:UILabel!
    @IBOutlet weak var lbl5:UILabel!
    
    @IBOutlet weak var vHeader:UIView!
    @IBOutlet weak var vBk:UIView!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var c_Header_Ht:NSLayoutConstraint!
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var btnNext:UIButton!
    
    let k_lblRadiusHeader:CGFloat = 20.0
    var img_UserPicture:UIImage!
    var temporal_media_id = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vBk.layer.cornerRadius = 5.0
        vBk.layer.masksToBounds = true
        setUpTopBar()
        lblHeader.text = "Imagen de Perfil"
        
        setupRoundViews()
        btnNext.isUserInteractionEnabled = false
        
        btnNext.backgroundColor = .clear
        btnNext.setTitleColor(UIColor.lightGray, for: .normal)
        
        btnNext.layer.cornerRadius = 25.0
        btnNext.layer.borderColor = UIColor.lightGray.cgColor
        btnNext.layer.borderWidth = 1.0
        btnNext.layer.masksToBounds = true
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(self.userImageTapped))
        imgView.addGestureRecognizer(pictureTap)
        imgView.isUserInteractionEnabled = true
    }
    
    func setupRoundViews()
    {
        lbl1.layer.cornerRadius = k_lblRadiusHeader
        lbl1.layer.borderWidth = 2.0
        lbl1.layer.masksToBounds = true
        
        lbl2.layer.cornerRadius = k_lblRadiusHeader
        lbl2.layer.borderWidth = 2.0
        lbl2.layer.masksToBounds = true
        
        lbl3.layer.cornerRadius = k_lblRadiusHeader
        lbl3.layer.borderColor = k_baseColor.cgColor
        lbl3.layer.borderWidth = 2.0
        lbl3.layer.masksToBounds = true
        
        lbl4.layer.cornerRadius = k_lblRadiusHeader
        lbl4.layer.borderWidth = 2.0
        lbl4.layer.masksToBounds = true
        
        lbl5.layer.cornerRadius = k_lblRadiusHeader
        lbl5.layer.borderWidth = 2.0
        lbl5.layer.masksToBounds = true
        
        btnNext.layer.cornerRadius = 5.0
        btnNext.layer.masksToBounds = true
        
        imgView.layer.cornerRadius = 5.0
       // imgView.layer.borderWidth = 0.5
        imgView.layer.masksToBounds = true
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_Header_Ht.constant = 90
            setHeadGradient(height: 90)
        }
        else if strModel == "iPhone Max"
        {
            c_Header_Ht.constant = 90
            setHeadGradient(height: 90)
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else{
            c_Header_Ht.constant = 110
            setHeadGradient(height: 110)
        }
    }
    
    func setHeadGradient(height:Int){
        let fistColor = UIColor(named: "App_DarkBlack")!
        let lastColor = UIColor(named: "App_LightBlack")!
        
        let gradient: CAGradientLayer = CAGradientLayer()
        //        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.colors = [fistColor.cgColor, lastColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.size.width), height: height)
        vHeader.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func btnBack(btn:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func userImageTapped() {
        pickAnImage()
    }
    
    @IBAction func nextClick(btn:UIButton)
    {
        let vc: Reg4VC = AppStoryBoards.Register.instance.instantiateViewController(withIdentifier: "Reg4VC_ID") as! Reg4VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension Reg3VC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .all : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}

extension Reg3VC :UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func pickAnImage()
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "AT&T", message: "Elija una opción", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Tomar la foto", style: .default) { action -> Void in
            if(  UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.allowsEditing = true
                self.present(myPickerController, animated: true, completion: nil)
            }
            else
            {
                let actionController: UIAlertController = UIAlertController(title: "La cámara no está disponible.",message: "", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void     in
                    //Just dismiss the action sheet
                }
                
                actionController.addAction(cancelAction)
                self.present(actionController, animated: true, completion: nil)
                
            }
        }
        
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Elegir de la galería", style: .default) { action -> Void in
            
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.allowsEditing = true
            myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let editedImage = info[.editedImage] as? UIImage
        {
            self.img_UserPicture = editedImage
            self.imgView.image = self.img_UserPicture
            callUploadProfileImgApi(img: self.img_UserPicture)
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            self.img_UserPicture = originalImage
            self.imgView.image = self.img_UserPicture
            callUploadProfileImgApi(img: self.img_UserPicture)
        }
        else{
            print("Something went wrong!! NO IMAGE PICKED - - ")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: API CALLS
extension Reg3VC
{
    func callUploadProfileImgApi(img:UIImage)
    {
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.uploadImage(url: ServiceName.POST_UploadProfileImageTemp.rawValue, method: .post, parameter: [:], header: [:], image: img, viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //    print(jsonString)
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let str:String = dict["temporal_uploaded_media_id"] as? String
                            {
                                self.temporal_media_id = str
                            }
                        }
                        self.perform(#selector(self.callAnalyseImage), with: nil, afterDelay: 0.2)
                    }
                }
            }
        }
        
    }
    
    @objc func callAnalyseImage()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["temporal_media_id":self.temporal_media_id]
        
        k_helper.tempRegisterDict["badge_evidence_temporal_media_id"] = self.temporal_media_id
        
        WebService.requestService(url: ServiceName.PUT_AnalyseBadgePic.rawValue, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //  print(jsonString)
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let status:Int = dict["acceptance_status"] as? Int
                            {
                                k_helper.tempRegisterDict["badge_evidence_auto_acceptance_status"] = status
                            }
                            if let score:Int = dict["acceptance_score"] as? Int
                            {
                                k_helper.tempRegisterDict["badge_evidence_auto_acceptance_score"] = score
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.showAlertWithTitle(title: "AT&T", message: "Imagen cargada correctamente, haga clic en Siguiente", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            
                            self.btnNext.isUserInteractionEnabled = true
                            self.btnNext.setTitleColor(UIColor(named: "App_Blue")!, for: .normal)
                            self.btnNext.layer.borderColor = UIColor(named: "App_Blue")!.cgColor
                            self.btnNext.layer.masksToBounds = true
                        }
                    }
                }
            }
        }
    }
}
