//
//  RecommendViewController.swift
//  AllStars
//
//  Created by Kenyi Rodriguez Vergara on 11/05/16.
//  Copyright © 2016 Belatrix SF. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController , OSPOptionListDelegate, UITextViewDelegate {

    @IBOutlet weak var viewHeader                   : UIView!
    @IBOutlet weak var imgAvatar                    : UIImageView!
    @IBOutlet weak var lblFullName                  : UILabel!
    @IBOutlet weak var lblPlaceHolder               : UILabel!
    @IBOutlet weak var lblUserName                  : UILabel!
    @IBOutlet weak var txtCategory                  : UITextField!
    @IBOutlet weak var activityCategory             : UIActivityIndicatorView!
    @IBOutlet weak var txtSubCategory               : UITextField!
    @IBOutlet weak var txtKeyword                   : UITextField!
    @IBOutlet weak var activityKeyword              : UIActivityIndicatorView!
    @IBOutlet weak var constraitHeightDescription   : NSLayoutConstraint!
    @IBOutlet weak var constraintBottonScroll       : NSLayoutConstraint!
    @IBOutlet weak var txtDescription               : UITextView!
    @IBOutlet weak var activityRate                 : UIActivityIndicatorView!
    
    var objUser                 : User?
    var objCategorySelected     : CategoryBE?
    var objSubCategorySelected  : SubCategoryBE?
    var objKeywordSelected      : KeywordBE?
    var arrayCategories         = NSMutableArray()
    var arraykeyWords           = NSMutableArray()
    
    func getHeightToTextDescripcion() -> CGFloat{
        
        let maximumSize = CGSizeMake(self.txtDescription.frame.size.width, CGFloat.max)
        let height = self.txtDescription.sizeThatFits(maximumSize).height
        return height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecommendViewController.keyboardWillShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RecommendViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        setViews()
        
        self.lblFullName?.text = "\(self.objUser!.user_first_name!) \(self.objUser!.user_last_name!)"
        self.lblUserName?.text = "\(self.objUser!.user_username!)"
        
        if let url_photo = self.objUser!.user_avatar{
            if (url_photo != "") {
                OSPImageDownloaded.descargarImagenEnURL(url_photo, paraImageView: self.imgAvatar, conPlaceHolder: self.imgAvatar.image) { (correct : Bool, nameImage : String!, image : UIImage!) in
                    if nameImage == url_photo {
                        self.imgAvatar?.image = image
                    }
                }
            } else {
                self.imgAvatar!.image = UIImage(named: "ic_user.png")
            }
        } else {
            self.imgAvatar!.image = UIImage(named: "ic_user.png")
        }
        
        self.listAllCategories()
        self.listKeywords()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - UI
    func setViews() {
        OSPCrop.makeRoundView(self.imgAvatar)
        
        viewHeader.backgroundColor = UIColor.colorPrimary()
    }
    
    // MARK: - Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - IBActions
    @IBAction func tapToCloseKeyboard(sender: AnyObject) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func clickBtnBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clickBtnDone(sender: AnyObject) {
        
        let rateUser = RateUserBE()
        
        rateUser.rate_category = self.objCategorySelected
        rateUser.rate_subCategory = self.objSubCategorySelected
        rateUser.rate_keyword = self.objKeywordSelected
        rateUser.rate_toUser = self.objUser
        rateUser.rate_comment = self.txtDescription.text
        
        self.activityRate.startAnimating()
        self.view.userInteractionEnabled = false
        
        RecommendBC.rateUser(rateUser, withController: self) { (isCorrect) in
            
            self.activityRate.stopAnimating()
            self.view.userInteractionEnabled = true
            
            if (isCorrect == true) {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func clickBtnCategory(sender: AnyObject) {
        
        if self.arrayCategories.count == 0 {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Categories no availables", conBotonCancelar: "Accept", enController: self, conCompletion: nil)
            return
        }
        
        self.view.endEditing(true)
        
        let arrayItems = NSMutableArray()
        
        self.arrayCategories.enumerateObjectsUsingBlock { (obj, idx, stop) in
            
            let objBE = obj as! CategoryBE
            
            let item = OSPOptionListItem()
            item.estaSeleccionado = objBE.category_pk == self.objCategorySelected?.category_pk ? 1 : 0
            item.titulo = objBE.category_name
            item.objeto = objBE
            arrayItems.addObject(item)
        }
        
        let list = NSBundle.mainBundle().loadNibNamed("OSPOptionList", owner: self, options: nil)[0] as! OSPOptionList
        list.frame = self.view.bounds
        list.delegate = self
        list.tag = 0
        list.arrayItemList = arrayItems as [AnyObject]
        list.mostrarEnVista(self.view)
    }
    
    @IBAction func clickBtnSubCategory(sender: AnyObject) {
        
        if self.objCategorySelected == nil {
            OSPUserAlerts.showSimpleAlert("app_name".localized, withMessage: "category_empty".localized, withAcceptButton: "ok".localized)
            return
        }
        
        self.view.endEditing(true)
        
        let arrayItems = NSMutableArray()
        
        self.objCategorySelected?.category_arraySubCategories.enumerateObjectsUsingBlock { (obj, idx, stop) in
            
            let objBE = obj as! SubCategoryBE
            
            let item = OSPOptionListItem()
            item.estaSeleccionado = objBE.subCategory_pk == self.objSubCategorySelected?.subCategory_pk ? 1 : 0
            item.titulo = objBE.subCategory_name
            item.objeto = objBE
            arrayItems.addObject(item)
        }
        
        let list = NSBundle.mainBundle().loadNibNamed("OSPOptionList", owner: self, options: nil)[0] as! OSPOptionList
        list.frame = self.view.bounds
        list.delegate = self
        list.tag = 1
        list.arrayItemList = arrayItems as [AnyObject]
        list.mostrarEnVista(self.view)
    }
    
    @IBAction func clickBtnKeyword(sender: AnyObject) {
        
        if self.arraykeyWords.count == 0 {
            OSPUserAlerts.mostrarAlertaConTitulo("Error", conMensaje: "Keywords no availables", conBotonCancelar: "Accept", enController: self, conCompletion: nil)
            return
        }
        
        self.view.endEditing(true)
        
        let arrayItems = NSMutableArray()
        
        self.arraykeyWords.enumerateObjectsUsingBlock { (obj, idx, stop) in
            
            let objBE = obj as! KeywordBE
            
            let item = OSPOptionListItem()
            item.estaSeleccionado = objBE.keyword_pk == self.objKeywordSelected?.keyword_pk ? 1 : 0
            item.titulo = objBE.keyword_name
            item.objeto = objBE
            arrayItems.addObject(item)
        }
        
        let list = NSBundle.mainBundle().loadNibNamed("OSPOptionList", owner: self, options: nil)[0] as! OSPOptionList
        list.frame = self.view.bounds
        list.delegate = self
        list.tag = 2
        list.arrayItemList = arrayItems as [AnyObject]
        list.mostrarEnVista(self.view)
    }
    
    // MARK: - UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let count = textView.text.characters.count + (text == "" ? -range.length : text.characters.count)
        self.lblPlaceHolder.alpha = CGFloat(!Bool(count))
        
        self.constraitHeightDescription.constant = self.getHeightToTextDescripcion()
        self.view.layoutIfNeeded()
        
        return true
    }
    
    // MARK: - OSPOptionListDelegate
    func optionListSeleccionarItem(aItem: OSPOptionListItem!, enOptionList aOptionList: OSPOptionList!) {
        
        if aOptionList.tag == 0 {
            
            self.txtCategory.text = aItem.titulo
            self.objCategorySelected = aItem.objeto as? CategoryBE
            self.objSubCategorySelected = nil
            self.txtSubCategory.text = ""
            
        } else if aOptionList.tag == 1 {
            
            self.txtSubCategory.text = aItem.titulo
            self.objSubCategorySelected = aItem.objeto as? SubCategoryBE
            
        } else if aOptionList.tag == 2 {
            
            self.txtKeyword.text = aItem.titulo
            self.objKeywordSelected = aItem.objeto as? KeywordBE
        }
    }
    
    // MARK: - WebServices
    func listAllCategories() {
        
        self.activityCategory.startAnimating()
        
        RecommendBC.listAllCategoriesToUser(self.objUser!) { (arrayCategories) in
            
            self.activityCategory.stopAnimating()
            self.arrayCategories = arrayCategories
        }
    }
    
    func listKeywords() {
        
        self.activityKeyword.startAnimating()
        
        RecommendBC.listKeyWordsWithCompletion { (arrayKeywords) in
            
            self.activityKeyword.stopAnimating()
            self.arraykeyWords = arrayKeywords
        }
    }
    
    // MARK: - Keyboard Notification
    func keyboardWillShown(notification : NSNotification) {
        
        let info : NSDictionary = notification.userInfo!
        let kbSize : CGSize = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size)!
        let durationkeyboardAnimation = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue
        
        UIView.animateWithDuration(durationkeyboardAnimation!) {
            
            self.constraintBottonScroll.constant = kbSize.height
            self.view.layoutIfNeeded()
            
        }
    }
    
    func keyboardWillBeHidden(notification : NSNotification) {
        
        let info : NSDictionary = notification.userInfo!
        let durationkeyboardAnimation = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue
        
        UIView.animateWithDuration(durationkeyboardAnimation!) {
            
            self.constraintBottonScroll.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}