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
        if !AppEngine.sharedInstance.isEvApp(){
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
        
        eventDate.text = "Event Date: \(eventDetails?.eventDate?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
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

class TrainingItemCell : UITableViewCell{

    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var selectRedioImg: UIImageView!
    @IBOutlet weak var radiobutton: UIButton!
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
        selectRedioImg.image = (training?.isSelected ?? false) ? UIImage(named: "radio-on-button") : UIImage(named: "radio-off-button")
    }
    
}

protocol RentalDelegate{
    func didChangeRentalSelection(rental: RentalDatum, indexPath: IndexPath, checkedStatus : Bool)
}
class RentItemCell : UITableViewCell, CheckboxButtonDelegate, RadioButtonDelegate {
    func radioButtonDidSelect(_ button: MBRadioCheckboxButton.RadioButton) {
        delegate?.didChangeRentalSelection(rental: self.rentalItem!, indexPath: self.indexPath, checkedStatus: true)
    }
    
    func radioButtonDidDeselect(_ button: MBRadioCheckboxButton.RadioButton) {
        delegate?.didChangeRentalSelection(rental: self.rentalItem!, indexPath: self.indexPath, checkedStatus: false)
    }
    
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
    func didChangeEventClassSelection(eventClass: EventClass, raceClass : EventRaceClass, indexPath: IndexPath, checkedStatus : Bool)
}

class EventClassCell: UITableViewCell , CheckboxButtonDelegate,  UITextFieldDelegate{
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var tfBikeData: SkyFloatingLabelTextField!
    
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        self.delegate?.didChangeEventClassSelection(eventClass: self.eventClass, raceClass: self.raceClass!, indexPath: self.indexPath!, checkedStatus: true)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        self.delegate?.didChangeEventClassSelection(eventClass: self.eventClass, raceClass: self.raceClass!, indexPath: self.indexPath!, checkedStatus: false)
    }
    
    var delegate : EventClassCellDelegate?
    
    @IBOutlet weak var selectionBox: CheckboxButton!
    
    @IBOutlet weak var eventClassTitle: UILabel!
    
    var indexPath: IndexPath?
    var raceClass : EventRaceClass?
    var eventClass: EventClass = EventClass()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tfBikeData.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == tfBikeData{
            
            if(textField.text == raceClass?.bikeData ?? ""){
                
            }else{
                self.raceClass?.bikeData = tfBikeData.text
                _ = self.eventClass.validateRaceClasses()
                
                self.delegate?.didChangeEventClassSelection(eventClass: self.eventClass, raceClass: self.raceClass!, indexPath: self.indexPath!, checkedStatus: true)
            }
        }
    }
    
    func showData(eventClass: EventClass, raceClass : EventRaceClass, indexPath: IndexPath){
        self.indexPath = indexPath
        self.raceClass = raceClass
        self.eventClass = eventClass
        
        eventClassTitle.text = raceClass.className
        price.text = "$ \(raceClass.classPrice ?? 0)"
        tfBikeData.text = raceClass.bikeData
        selectionBox.delegate = nil
        selectionBox.isEnabled = !(raceClass.specialCase ?? false) || (raceClass.specialCase ?? false && eventClass.canSelectSpecialClass())
        selectionBox.isOn = raceClass.checked ?? false
        selectionBox.applyCheckboxTheme()
        selectionBox.delegate = self
        tfBikeData.isEnabled = selectionBox.isOn
        if raceClass.hasError{
            tfBikeData.errorMessage = "Bike data required."
        }
        
        
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
    
    
    func showData(racerStatus : String, skillRegistered : String){
        radio1.setTitle("Amateur", for: .normal)
        radio2.setTitle("Expert", for: .normal)
        
        radio1.isOn = racerStatus == radio1.title(for: .normal)
        radio2.isOn = racerStatus == radio2.title(for: .normal)
        
        radio1.delegate = self
        radio2.delegate = self
        
        if skillRegistered.lowercased() == "expert"{
            radio1.isEnabled = false
            radio2.isEnabled = false
        }else{
            radio1.isEnabled = true
            radio2.isEnabled = true
        }
        
        radio1.applyRadioButtonTheme()
        radio2.applyRadioButtonTheme()
    }
}

protocol TransponderCellDelegate{
    //    func didSelectTransponderForRent(transponder: Transponder, indexPath: IndexPath, _ checked : Bool)
    func didEnterTransponderNumber(transponderNumber: String, indexPath: IndexPath)
    func didEnterBikeNumber(bikeNumber: String, indexPath: IndexPath)
}

class TransponderCell: UITableViewCell,  UITextFieldDelegate{
    
    @IBOutlet weak var tfBikeNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var transponderTF: SkyFloatingLabelTextField!
    
    var indexPath : IndexPath?
    
    var delegate : TransponderCellDelegate?
    
    func showData( transponderNumber: String, bikeNumber: String, indexPath: IndexPath){
        self.indexPath = indexPath
        
        transponderTF.isEnabled = true//!(transponderRent.isOn)
        transponderTF.text = transponderNumber
        transponderTF.applyColorTheme()
        
        tfBikeNumber.text = bikeNumber
        tfBikeNumber.applyColorTheme()
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transponderTF.delegate = self
        tfBikeNumber.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == transponderTF{
            delegate?.didEnterTransponderNumber(transponderNumber: textField.text!, indexPath: indexPath!)
        }else{
            delegate?.didEnterBikeNumber(bikeNumber: textField.text!, indexPath: indexPath!)
        }
    }
    
    
}

protocol TrackDayCellDelegate{
    func didPressAddTrackDayToCart(event: Event)
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
        delegate?.didPressAddTrackDayToCart(event: trackDay!)
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
        
        //        eventDate.text = "Date: \(trackDay?.eventDate?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        price.text = trackDay?.price?.formatToAmount(prefix: "Price: ")
        hostedBy.text = "Hosted By: \(trackDay?.eventType ?? "")"
        rootView.setCardView()
        
        if trackDay?.isPrivateEvent ?? false{
            if !AppEngine.sharedInstance.isEvApp(){
                addToCartButton?.setImage(UIImage(named: "private-event-green"), for: .normal)
            }else{
                addToCartButton?.setImage(UIImage(named: "private-event-blue"), for: .normal)
                
            }
        }else if trackDay?.external != nil{
            if !AppEngine.sharedInstance.isEvApp(){
                addToCartButton?.setImage(UIImage(named: "cart-globe-ev"), for: .normal)
            }else{
                addToCartButton?.setImage(UIImage(named: "cart-globe-moto"), for: .normal)
                
            }
        }else{
            addToCartButton?.setImage(UIImage(named: "cart"), for: .normal)
        }
    }
}
class EventClassHeader: UITableViewCell{
    static let identifier = "EventClassHeader"
    
    
    @IBOutlet weak var classHeader: UILabel!
    
    func setHeader(title: String){
        classHeader.text = "  \(title)"
    }
}
class MrlLicenceCell: UITableViewCell{
    static let identifier = "MrlLicenceCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var season: UILabel!
    @IBOutlet weak var btnPurchase: UIButton!
    
    
    var purchaseHandler :((_ mrlData: MrlData) -> Void )? = nil
    @IBAction func didTapPurchaseButton(_ sender: UIButton) {
        if let handler = purchaseHandler{
            handler(self.mrlData)
        }
    }
    
    var mrlData = MrlData()
    
    func updateUi(mrlData: MrlData){
        self.mrlData = mrlData
        title.text = mrlData.title
        price.text = "Price: \(mrlData.price?.formatToAmount() ?? "$0.0")"
        season.text = "\(mrlData.season ?? "") Season"
    }
}
