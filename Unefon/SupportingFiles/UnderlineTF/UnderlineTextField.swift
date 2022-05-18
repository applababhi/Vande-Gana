//
//  UnderlineTextField.swift
//  PlannerDiary
//
//  Created by sama73 on 2018. 12. 31..
//  Copyright © 2018년 sama73. All rights reserved.
//

import UIKit

class UnderlineTextField: UITextField, UITextFieldDelegate {
	
	var vUnderline : UIView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
   //     delegate = self
        createBorder()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
//        delegate = self
        createBorder()
    }
    
    func dullBorder(){
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.textColor = .lightGray
    }
    
    // TextField에 Bottom Under Line뷰 추가 시켜준후 오토레이아웃 설정해준다.
    func createBorder(){

        self.backgroundColor = UIColor.clear
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true

        addLeftView()
        /*
		self.vUnderline = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
		self.vUnderline.backgroundColor = UIColor.lightGray
		self.addSubview(self.vUnderline)
		
		// VFL AutoLayout
		let dicViews : [String : Any] = ["vUnderline": self.vUnderline]
		self.vUnderline.translatesAutoresizingMaskIntoConstraints = false
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vUnderline]|", options: [], metrics: nil, views: dicViews))
		self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vUnderline(1)]|", options: NSLayoutConstraint.FormatOptions.alignAllBottom, metrics: nil, views: dicViews))
        */
    }
    
    /** 슬라이더 정보 갱신
     * isFocus 값이 true 일때는 underline color red
     * isFocus 값이 false 일때는 underline color gray
     */
    public func updateFocus(isFocus: NSNumber) {
        if let vBottomLine = self.vUnderline {
            if isFocus.boolValue == true {
                vBottomLine.backgroundColor = k_baseColor
            }
            else {
                vBottomLine.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - UITextFieldDelegate
    // 언더라인 선택 색상 적용
    // 다른쪽에서 UITextFieldDelegate를 정의 했다면 꼭 이쪽을 타도록 코딩을 적용해 준다.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("focused")
        
        updateFocus(isFocus: true)
    }
    
    // 언더라인 미선택 생상 적용
    // 다른쪽에서 UITextFieldDelegate를 정의 했다면 꼭 이쪽을 타도록 코딩을 적용해 준다.
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("lost focus")
        
        updateFocus(isFocus: false)
    }
    
    func addLeftView()
    {
        let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewT.backgroundColor = .clear
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = viewT
    }
}
