//
//  EventInfoCell.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 15/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import MBRadioCheckboxButton
import SkyFloatingLabelTextField

class EventInfoCell: UITableViewCell{
    
    @IBOutlet weak var bannerCanclled: UIImageView!
    
    @IBOutlet weak var eventBanner: UIImageView!
    
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var roleBasedPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    func applyTheme() {
        if AppEngine.sharedInstance.isEvApp(){
            roleBasedPrice.backgroundColor = UIColor.init(hexFromString: UIColor.GREEN_EV_LITE)
            totalPrice.backgroundColor = UIColor.init(hexFromString: UIColor.GREEN_EV_DARK)
        }else{
            roleBasedPrice.backgroundColor = UIColor.init(hexFromString: UIColor.BLUE_MOTO_LITE)
            totalPrice.backgroundColor = UIColor.init(hexFromString: UIColor.BLUE_MOTO_DARK)
        }
    }
    func showData(eventDetails : EventDetails?){
        applyTheme()
        if  let url = URL(string : eventDetails?.eventBanner ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            eventBanner.kf.setImage(with: url,
                                   placeholder: fallbackImage,
                                   options: [.transition(ImageTransition.fade(1))])
            
        }
       
        eventDate.text = "Event Date: \(eventDetails?.eventDate?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        let role = AppEngine.sharedInstance.userRole
        roleBasedPrice.text = "\(role.capitalized) :\(eventDetails?.getRoleBasedPrice(role: role).formatToAmount() ?? String.DEFAULT_AMOUNT)"
        
        totalPrice.text = "Total: \(String(eventDetails?.total ?? 0.0).formatToAmount())"
        
        bannerCanclled.isHidden = eventDetails?.isCancelled ?? true
    }
}

class AboutEventCell : UITableViewCell{
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    
     func showData(eventDetails : EventDetails?){
        content.attributedText = eventDetails?.productInfo?.toAttributedText(with: 15.0)
    }
}


protocol TrainingDelegate{
    func didChangeTrainingSelection(training: TrainingDatum, checkedStatus : Bool)
}
class TrainingItemCell : UITableViewCell, CheckboxButtonDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        delegate?.didChangeTrainingSelection(training: self.training!, checkedStatus: button.isOn)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
         delegate?.didChangeTrainingSelection(training: self.training!, checkedStatus: button.isOn)
    }
    
    
    var delegate :TrainingDelegate?
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var selectionView: CheckBox!
    
    @IBOutlet weak var seelctionCheckBox: CheckboxButton!
    @IBOutlet weak var titleView: UILabel!
    
    var training : TrainingDatum?{
        didSet{
            showData()
        }
    }
    private func showData(){
        //selectionView.applyColorTheme()
        priceView.textColor = UIColor.getAppThemeColor()
        titleView.text = training?.title
        priceView.text = training?.price?.formatToAmount(prefix: "Price: ")
        seelctionCheckBox.isOn = training?.isSelected ?? false
        seelctionCheckBox.delegate = self
        seelctionCheckBox.applyCheckboxTheme() 
    }
    
}

protocol RentalDelegate{
    func didChangeRentalSelection(rental: RentalDatum, indexPath: IndexPath, checkedStatus : Bool)
}
class RentItemCell : UITableViewCell, CheckboxButtonDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        delegate?.didChangeRentalSelection(rental: self.rentalItem!, indexPath: self.indexPath, checkedStatus: true)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
         delegate?.didChangeRentalSelection(rental: self.rentalItem!, indexPath: self.indexPath, checkedStatus: false)
    }
    
    
    var delegate: RentalDelegate?
  
    @IBOutlet weak var selectionCheckBox: CheckboxButton!
    @IBOutlet weak var rentalTitle: UILabel!
    
    @IBOutlet weak var priceView: UILabel!
    
    @IBOutlet weak var selectedSize: UILabel!
    var indexPath = IndexPath()
    var rentalItem : RentalDatum?
    
    func showData(rentalItem: RentalDatum, indexPath: IndexPath){
        self.rentalItem = rentalItem
        self.indexPath = indexPath
        selectionCheckBox.applyCheckboxTheme()
       
        priceView.textColor = UIColor.getAppThemeColor()
        rentalTitle.text = rentalItem.title
        
        selectionCheckBox.delegate = nil
        selectionCheckBox.isOn = rentalItem.selectedVariant != nil
        selectionCheckBox.delegate = self
       
        if let selectedVariant = rentalItem.selectedVariant{
            selectedSize.text = "\(selectedVariant.attributeName?.capitalized ?? "") : \(selectedVariant.attributeValue?.capitalized ?? "")"
             priceView.text = selectedVariant.price?.formatToAmount(prefix: "Price: ")
        }else{
            selectedSize.text = ""
            priceView.text = ""
        }
       
    }
    
    
    
    
}

protocol EventClassCellDelegate{
    func didChangeEventClassSelection(eventClass: EventClass, indexPath: IndexPath, checkedStatus : Bool)
}

class EventClassCell: UITableViewCell , CheckboxButtonDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        self.delegate?.didChangeEventClassSelection(eventClass: self.eventClass!, indexPath: self.indexPath!, checkedStatus: true)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
         self.delegate?.didChangeEventClassSelection(eventClass: self.eventClass!, indexPath: self.indexPath!, checkedStatus: false)
    }
    
    var delegate : EventClassCellDelegate?
    
    @IBOutlet weak var selectionBox: CheckboxButton!
    
    @IBOutlet weak var eventClassTitle: UILabel!
    
    var indexPath: IndexPath?
    var eventClass : EventClass?
    
    func showData(eventClass : EventClass, indexPath: IndexPath){
        self.indexPath = indexPath
        self.eventClass = eventClass
        
        eventClassTitle.text = eventClass.eventClassName
        selectionBox.delegate = nil
        selectionBox.isEnabled = !(eventClass.inCart ?? false)
        selectionBox.isOn = eventClass.isSelected || (eventClass.inCart ?? false)
        selectionBox.applyCheckboxTheme()
        selectionBox.delegate = self
    }
}


protocol SkillLevelCellDelegate{
    func didChangeSkillSet(skill: String)
}

class SkillLevelCell: UITableViewCell, RadioButtonDelegate{
    func radioButtonDidSelect(_ button: RadioButton) {
        delegate?.didChangeSkillSet(skill: button.title(for: .normal)!)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        
    }
    
    var delegate : SkillLevelCellDelegate?
    @IBOutlet weak var radio1: RadioButton!

    
    @IBOutlet weak var radio2: RadioButton!
  
    
    func showData(amateur : SkillSet, expert : SkillSet, hasSkillRegistered : Bool){
        radio1.setTitle(amateur.skill, for: .normal)
        radio2.setTitle(expert.skill, for: .normal)

        radio1.isOn = amateur.active ?? true
        radio2.isOn = expert.active ?? false
        
        radio1.delegate = self
        radio2.delegate = self
        
        radio1.isEnabled = !hasSkillRegistered
        radio2.isEnabled = !hasSkillRegistered
        
        radio1.applyRadioButtonTheme()
        radio2.applyRadioButtonTheme()
    }
}

protocol TransponderCellDelegate{
    func didSelectTransponderForRent(transponder: Transponder, indexPath: IndexPath, _ checked : Bool)
    func didEnterTransponderNumber(transponderNumber: String, transponder: Transponder, indexPath: IndexPath)
}

class TransponderCell: UITableViewCell, CheckboxButtonDelegate, UITextFieldDelegate{
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        delegate?.didSelectTransponderForRent(transponder: transponder!, indexPath: indexPath!, true)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
       delegate?.didSelectTransponderForRent(transponder: transponder!, indexPath: indexPath!, false)
    }
    
    
    @IBOutlet weak var transponderImage: UIImageView!
    @IBOutlet weak var transponderRent: CheckboxButton!
    @IBOutlet weak var transponderTF: SkyFloatingLabelTextField!
    
    var transponder: Transponder?
    var indexPath : IndexPath?
    
    var delegate : TransponderCellDelegate?
    func showData(transponder: Transponder, indexPath: IndexPath){
        self.indexPath = indexPath
        self.transponder = transponder
        
        
        if  let url = URL(string : transponder.imageURL ?? ""){
            let fallbackImage = UIImage(named: "fallback_transponder")
            transponderImage.kf.setImage(with: url,
                                   placeholder: fallbackImage,
                                   options: [.transition(ImageTransition.fade(1))])
            
        }
        transponderRent.delegate = nil
        transponderRent.setTitle("Transponder Rent \(String(transponder.price ?? 0).formatToAmount())", for: .normal)
        transponderRent.isOn = transponder.isSelected
        transponderTF.isEnabled = !(transponderRent.isOn)
        transponderTF.text = transponder.number
        
       
         transponderRent.delegate = self
        transponderRent.applyCheckboxTheme()
        
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transponderTF.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         delegate?.didEnterTransponderNumber(transponderNumber: textField.text!, transponder: transponder!, indexPath: indexPath!)
    }
    
    
}

protocol TrackDayCellDelegate{
    func didPressAddToCart(event: Event)
}
class TrackDayCell : UITableViewCell{
    
    static let identifier = "TrackDayCell"
    var delegate : TrackDayCellDelegate?
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    
    @IBOutlet weak var bannerCancelled: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var hostedBy: UILabel!
    
    @IBAction func didPressAddToCart(_ sender: UIButton) {
        delegate?.didPressAddToCart(event: trackDay!)
    }
    
    var trackDay : Event?{
        didSet{
            showData()
        }
    }
    
    private func showData(){
        if  let url = URL(string : trackDay?.eventLogo ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            imageLogo.kf.setImage(with: url,
                                   placeholder: fallbackImage,
                                   options: [.transition(ImageTransition.fade(1))])
            
        }
        bannerCancelled.isHidden = !(trackDay?.isCancelled ?? false)
        addToCartButton.isHidden = trackDay?.isCancelled ?? false
        eventName.text = trackDay?.title
        
        eventDate.text = "Date: \(trackDay?.eventDate?.formattedDate(outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        price.text = trackDay?.price?.formatToAmount(prefix: "Price: ")
        hostedBy.text = "Hosted By: \(trackDay?.eventType ?? "")"
        rootView.setCardView()
    }
}
