//
//  ProfileController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class ProfileController : ETViewController{
    @IBOutlet weak var btnSave: UIButton!
    
    private var userSelectedImage: UIImage? = nil
    @IBOutlet weak var profileViewContainer: UITableView!
    
    let interactor = ProfileInteractor()
    var sections = [ProfileSections]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.applyColorTheme()
        profileViewContainer.dataSource = self
        interactor.viewDelegate = self
        interactor.profileViewDelegate = self
        
        
        self.navigationController?.title = getScreenTitle()
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_PROFILE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ext.hideNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.computeProfileSections()
    }
    @IBAction func didPressSaveButton(_ sender: Any) {
        saveProfile()
    }
    
    func saveProfile(){
        interactor.updateProfile(profileImage: userSelectedImage?.jpegData(compressionQuality: 0.0))
    }
}
extension ProfileController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .pic:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfilePicCell.identifier, for: indexPath) as! ProfilePicCell
            cell.showData(user: AppEngine.sharedInstance.userDetails!, selectedImage: userSelectedImage)
            cell.delegate = self
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoCell.identifier, for: indexPath) as! ProfileInfoCell
            cell.showData(user: AppEngine.sharedInstance.userDetails!)
            return cell
        case .motorcycle:
            let cell = tableView.dequeueReusableCell(withIdentifier: MotorCycleInfoCell.identifier, for: indexPath) as! MotorCycleInfoCell
            cell.showData(user: AppEngine.sharedInstance.userDetails!)
            return cell
        case .mailingAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.identifier, for: indexPath) as! AddressCell
            var address = AppEngine.sharedInstance.userDetails?.shippingAddress ?? ""
            let hasAddress = !address.isEmpty
            address = address.isEmpty ? ValidationErrors.mailingAddressRequired : address
            cell.showData(type: "Mailing Address", addressContent: address, hasAddress: hasAddress)
            cell.setAction{ hasAddress in
                let addressVC = self.ext.getViewController(storyBoard: "Address", VCIdentifier: "AddressVC") as! AddressViewController
                addressVC.hasAddress = hasAddress
                addressVC.addressType = .shipping
                self.ext.pushViewController(viewController: addressVC)
            }
            return cell
        case .billingAddress:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.identifier, for: indexPath) as! AddressCell
            var address = AppEngine.sharedInstance.userDetails?.billingAddress ?? ""
            let hasAddress = !address.isEmpty
            address = address.isEmpty ? ValidationErrors.billingAddressRequired : address
            cell.showData(type: "Billing Address", addressContent: address, hasAddress: hasAddress)
            cell.setAction{ hasAddress in
                           let addressVC = self.ext.getViewController(storyBoard: "Address", VCIdentifier: "AddressVC") as! AddressViewController
                           addressVC.hasAddress = hasAddress
                           addressVC.addressType = .billing
                           self.ext.pushViewController(viewController: addressVC)
                       }
            return cell
        case .skillLevel:
            let cell = tableView.dequeueReusableCell(withIdentifier: SkillInfo.identifier, for: indexPath) as! SkillInfo
            cell.showData(user: AppEngine.sharedInstance.userDetails!)
            return cell
        case .moto:
            let cell = tableView.dequeueReusableCell(withIdentifier: MotoGladiatorInfoCell.identifier, for: indexPath) as! MotoGladiatorInfoCell
            cell.showData(user: AppEngine.sharedInstance.userDetails!)
            return cell
        case .emergency:
            let cell = tableView.dequeueReusableCell(withIdentifier: EmergencyContactCell.identifier, for: indexPath) as! EmergencyContactCell
            cell.showData(user: AppEngine.sharedInstance.userDetails!)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections[section] == .motorcycle{
            return "Your Motor Cycle"
        }else if sections[section] == .moto{
            return "MotoGladiator Info"
        }else if sections[section] == .skillLevel{
            return "Skill Level"
        }else if sections[section] == .emergency{
            return "Emergency Contact"
        }else{
            return nil
        }
    }
}
extension  ProfileController: ProfileViewDelegate{
    
    func validationError(message: String, section: ProfileSections) {
        let sectionIndex = sections.index(of: section) ?? 0
        profileViewContainer.reloadData()
        profileViewContainer.scrollToRow(at: IndexPath(row: 0, section: sectionIndex), at: .bottom, animated: true)
        
    }
    
    func availableSections(sections: [ProfileSections]) {
        self.sections = sections
        profileViewContainer.reloadData()
    }
    
    
}

extension  ProfileController: ProfilePicCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
       
        self.userSelectedImage = image.fixOrientation()
        picker.dismiss(animated: true, completion: {
            let row = IndexPath(row: 0, section: 0)
            self.profileViewContainer.reloadRows(at: [row], with: .none)
        })
    }
    
    
    func pickProfileImage() {
        
        let options = [ "Camera", "Photo Library"]
        self.ext.presentOptions(title: "Choose Image", message: "", options: options, selected: nil, preferredStyle: .actionSheet){selected in
            
            if selected == "Camera"{
                if(UIImagePickerController.isSourceTypeAvailable(.camera))
                {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .camera
                    imagePickerController.delegate = self
                    DispatchQueue.main.async {
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
                }else{
                    self.showErrorToastMessage(message: "Not supported in this device.")
                }
            }else if selected == "Photo Library"{
                if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
                {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    DispatchQueue.main.async {
                        self.present(imagePickerController, animated: true, completion: nil)
                    }
                }else{
                    self.showErrorToastMessage(message: "Not supported in this device.")
                }
            }
        }
        
    }
    
}
