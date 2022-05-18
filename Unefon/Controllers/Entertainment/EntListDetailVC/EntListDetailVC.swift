//
//  EntListDetailVC.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class EntListDetailVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var collViewMain:UICollectionView!
    @IBOutlet weak var baseView:UIView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var arrData: [String] = ["Contenido", "Videos", "Archivos"]

    var selectedCellIndex:Int = 0
    var strTitle = ""
    var dictMain:[String:Any] = [:]
    var check_showTomarTest = false
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopBar()

        lblTitle.text = strTitle
        collViewMain.dataSource = self
        collViewMain.delegate = self
        
        loadSubViewControllerAt(index: 0)
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("viewWillAppear_Dashboard"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpTopBar()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_TopBar_Ht.constant = 90
        }
        else if strModel == "iPhone Max"
        {
            c_TopBar_Ht.constant = 90
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else{
            c_TopBar_Ht.constant = 110
        }
    }

    func loadSubViewControllerAt(index:Int)
    {
        for views in baseView.subviews
        {
            views.removeFromSuperview()
        }
        
        if index == 0
        {
           // Tab 1
            let controller: EntListSub1VC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListSub1VC_ID") as! EntListSub1VC
            
            if let arr:[[String:Any]] = dictMain["contents"] as? [[String:Any]]
            {
                controller.arrData = arr
            }
            
            if let d1:[String:Any] = dictMain["course_information"] as? [String:Any]
            {
                if let str:String = d1["subcover_url"] as? String
                {
                    controller.imgHeaderUrl = str
                }
                if let str:String = d1["course_id"] as? String
                {
                    controller.courseID = str
                }
            }
            if let diQ:[String:Any] = dictMain["quizz_information"] as? [String:Any]
            {
                controller.dictQuiz = diQ
            }
            controller.check_showTomarTest = self.check_showTomarTest
            
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 1
        {
            // Tab 2
            let controller: EntListSub2VC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListSub2VC_ID") as! EntListSub2VC

            if let arr:[[String:Any]] = dictMain["videos"] as? [[String:Any]]
            {
                controller.arrData = arr
            }
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 2
        {
            // Tab 3
            
            let controller: EntListSub3VC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListSub3VC_ID") as! EntListSub3VC

            if let arr:[[String:Any]] = dictMain["files"] as? [[String:Any]]
            {
                controller.arrData = arr
            }
            controller.view.frame = self.baseView.bounds;
            controller.willMove(toParent: self)
            self.baseView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)

        }
    }
}

extension EntListDetailVC
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

extension EntListDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let str:String = arrData[indexPath.item]
        
        let cell:CellColl_ObjBase = collViewMain.dequeueReusableCell(withReuseIdentifier: "CellColl_ObjBase", for: indexPath) as! CellColl_ObjBase
        cell.lblTitle.text = str.uppercased()
        cell.lblTitle.textColor = .black

        cell.viewLine.backgroundColor = UIColor.lightGray
        if selectedCellIndex == indexPath.item
        {
            cell.viewLine.backgroundColor = k_baseColor
            cell.lblTitle.textColor = k_baseColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // let str:String = arrData[indexPath.item]
        selectedCellIndex = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true) // to make cell in ceter on Tap
        collectionView.reloadData()
        loadSubViewControllerAt(index: indexPath.item)
    }
    
    //MARK: Use for interspacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //MARK: set Cell CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let str:String = arrData[indexPath.item]
        
        let width  = str.width(withConstrainedHeight: 30, font: UIFont(name: CustomFont.semiBold, size: 18.0)!, minimumTextWrapWidth: 130)
        return CGSize(width: width, height: 50)
    }
}
