//
//  NewsDetailVC.swift
//  Unefon
//
//  Created by Abhishek Visa on 3/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnShare:UIButton!
    var webView: WKWebView!
    @IBOutlet weak var viewWeb:UIView!
    @IBOutlet weak var c_TopBar_Ht:NSLayoutConstraint!

    var strTitle = ""
    var pdfFilePath = ""
    var check_backToWalletForNotCenter = false
    var check_backToEntertainmentDetailScreen = false
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearTempFolderDocDirectory()
        setUpTopBar()
        
        lblTitle.text = strTitle
      //  self.perform(#selector(self.loadWebV), with: nil, afterDelay: 0.2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadWebV()
    }
    
    @IBAction func backClicked(btn:UIButton)
    {
        if check_backToEntertainmentDetailScreen == true
        {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if check_backToWalletForNotCenter == true
        {
            // back to Wallet VC
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_WalletVC"), object: nil)
        }
        else
        {
            // back to ExcahngeDetail
            NotificationCenter.default.post(name: Notification.Name("viewWillAppear_ExchangeDetailVC"), object: nil)
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadWebV()
    {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: viewWeb.frame.size.width, height: viewWeb.frame.size.height))
        
        self.webView.navigationDelegate = self
        print(pdfFilePath)
//        let pdfFilePath = "http://www.fao.org/3/i2469e/i2469e00.pdf"
        let urlRequest = URLRequest.init(url: URL(string: pdfFilePath)!)
        webView.load(urlRequest)
        self.viewWeb.addSubview(webView)
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
    
    @IBAction func backShareClick(btn:UIButton)
    {
        loadPDFAndShare()
    }
}

extension NewsDetailVC
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

extension NewsDetailVC : WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation:
        WKNavigation!) {        
        self.hideSpinner()
        savePdfToDocDir()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation
        navigation: WKNavigation!) {
        self.showSpinnerWith(title: "Cargando...")
    }
    
    func webView(_ webView: WKWebView, didFail navigation:
        WKNavigation!, withError error: Error) {
        self.hideSpinner()
    }
    
    func savePdfToDocDir(){
        // Need to save Pdf to Doc Dir, before opening UIActivityViewController
        let fileManager = FileManager.default
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        paths = paths.appendingPathComponent("documento.pdf") as NSString

        let pdfDoc = NSData(contentsOf:URL(string: pdfFilePath)!)
        fileManager.createFile(atPath: paths as String, contents: pdfDoc as Data?, attributes: nil)
    }
    
    func loadPDFAndShare(){

       let fileManager = FileManager.default
     //  let documentoPath = (self.getDirectoryPath() as NSString).appendingPathComponent("documento.pdf")
        
        var documentoPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        documentoPath = documentoPath.appendingPathComponent("documento.pdf") as NSString


        if fileManager.fileExists(atPath: documentoPath as String){
            let documento = NSData(contentsOfFile: documentoPath as String)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView=self.view
            present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("document was not found")
        }
    }
    
    func clearTempFolderDocDirectory()
    {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}
