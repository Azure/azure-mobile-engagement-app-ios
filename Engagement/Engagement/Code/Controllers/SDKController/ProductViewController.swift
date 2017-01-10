//
//  ProductViewController.swift
//  Engagement
//
//  Created by Microsoft on 17/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import UIKit

enum ProductViewType{
  case dataPush, coupon
  
  var title: String{
    switch self{
    case .dataPush:
      return L10n.tr("product.discount.title")
    case .coupon:
      return L10n.tr("product.title")
    }
  }
}

class ProductViewController: EngagementViewController {
  
  @IBOutlet weak var ibProductImage: UIImageView!
  @IBOutlet weak var ibProductName: UILabel!
  @IBOutlet weak var ibProductPrice: UILabel!
  @IBOutlet weak var ibRadioButton: UIButton!
  
  @IBOutlet weak var ibReductionButton: AzButton!
  
  var productViewType = ProductViewType.coupon
  var discountApplied = false
  var discountRateInPercent = 0
  
  let formatter = NumberFormatter()
  
  init(productViewType : ProductViewType = .coupon){
    super.init(nibName: nil, bundle: nil)
    self.productViewType = productViewType
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  //MARK: Overriding
  override func engagementActivityName() -> String! {
    return AnalyticsMonitor.Activities.ProductDiscount
  }
  
  //MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self,
      selector: #selector(ProductViewController.getDataPushValues(_:)),
      name: NSNotification.Name(rawValue: Config.Notifications.dataPushValuesUpdated),
      object: nil)
    
    self.title = L10n.tr("product.discount.title")
    
    formatter.numberStyle = .currency
    let toto = NSLocalizedString("product.name", comment: "")
    ibProductName.text = toto //L10n.tr("product.name")
    
    ibReductionButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.lightGrey)),
      for: .highlighted)
    
    ibProductName.font = UIFont(named: UIFont.AppFont.Light, size: 35)
    ibProductPrice.font = UIFont(named: UIFont.AppFont.Regular, size: 30)
    ibRadioButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.secondaryOrange)),
      for: UIControlState())
    ibReductionButton.titleLabel?.font = UIFont(named: UIFont.AppFont.Bold, size: 17)
    ibReductionButton.titleLabel?.numberOfLines = 0
    ibReductionButton.titleLabel?.lineBreakMode = .byWordWrapping
    
    if self.productViewType == .coupon {
      let attributed = NSMutableAttributedString(string: "20% off on your purchase\n",
        attributes: [NSFontAttributeName : UIFont(named: UIFont.AppFont.Bold, size: 16)])
      attributed.append(NSAttributedString(string: "Use coupon code 59AXCD when checking out",
        attributes: [NSFontAttributeName : UIFont(named: UIFont.AppFont.Medium, size: 13)]))
      self.ibRadioButton.contentMode = .left
      self.ibRadioButton.setAttributedTitle(attributed, for: UIControlState())
    }
    getDataPushValues(nil)
  }
  
  func getDataPushValues(_ notification: Notification?) {
    let defaults = UserDefaults.standard
    discountApplied = defaults.bool(forKey: Config.Product.DataPush.isDiscountAvailable)
    if defaults.object(forKey: Config.Product.DataPush.discountRateInPercent) != nil {
      let discountRateInPercentValue = defaults.integer(forKey: Config.Product.DataPush.discountRateInPercent)
      discountRateInPercent = discountRateInPercentValue < 0 ? 0 : discountRateInPercentValue > 100 ? 100 : discountRateInPercentValue
    } else {
      discountRateInPercent = Config.Product.defaultReductionRatio()
    }
    updatePriceButtonStyle()
  }
  
  //MARK: Actions
  @IBAction func didTapReductionButton(_ sender: AnyObject) {
    self.discountApplied = !self.discountApplied
    
    AnalyticsMonitor.sendActivityNamed(self.discountApplied ? AnalyticsMonitor.Events.ProductDiscount.applyDiscount : AnalyticsMonitor.Events.ProductDiscount.removeDiscount, extras: nil)
    
    if self.discountApplied == false {
      let defaults = UserDefaults.standard
      defaults.removeObject(forKey: Config.Product.DataPush.isDiscountAvailable)
      defaults.removeObject(forKey: Config.Product.DataPush.discountRateInPercent)
      defaults.synchronize()
      getDataPushValues(nil)
    } else {
      updatePriceButtonStyle()
    }
  }
  
  //MARK: Private methods
  fileprivate func updatePriceButtonStyle() {
    
    if self.productViewType == .dataPush {
      ibRadioButton.isHidden = !self.discountApplied
      let title = String(discountRateInPercent) + "% off"
      let attributed = NSAttributedString(string: title,
        attributes: [NSFontAttributeName : UIFont(named: UIFont.AppFont.Bold, size: 16)])
      self.ibRadioButton.contentMode = .center
      self.ibRadioButton.setAttributedTitle(attributed, for: UIControlState())
    } else {
      ibRadioButton.isHidden = false
      ibReductionButton.isHidden = true
    }
    
    if discountApplied == true {
      ibReductionButton.setTitle(L10n.tr("product.discount.remove.discount.title"), for: UIControlState())
      ibReductionButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.secondaryPurple)),
        for: UIControlState())
      
        let price = NSMutableAttributedString(string: formatter.string(from: NSNumber(value: Config.Product.defaultPrice))!,
        attributes: [NSForegroundColorAttributeName : UIColor(named: UIColor.Name.generalText),
          NSStrikethroughStyleAttributeName : NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)])
        
        let somme = Config.Product.defaultPrice - (Config.Product.defaultPrice * discountRateInPercent / 100)
        
        let newPrice = NSMutableAttributedString(string: " " + formatter.string(from: NSNumber(value: somme))!,
        attributes: [NSForegroundColorAttributeName : UIColor(named: UIColor.Name.secondaryOrange)])
      
      price.append(newPrice)
      
      ibProductPrice.attributedText = price
    } else {
      ibReductionButton.setTitle(L10n.tr("product.discount.apply.discount.title"), for: UIControlState())
      ibReductionButton.setBackgroundImage(UIColor.imageWithColor(UIColor(named: UIColor.Name.secondaryOrange)),
        for: UIControlState())
      let price = NSMutableAttributedString(string: formatter.string(from: NSNumber(value: Config.Product.defaultPrice))!,
        attributes: [NSForegroundColorAttributeName : UIColor(named: UIColor.Name.generalText)])
      ibProductPrice.attributedText = price
    }
    
  }
  
}
