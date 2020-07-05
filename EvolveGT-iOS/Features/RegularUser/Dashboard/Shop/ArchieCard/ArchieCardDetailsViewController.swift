//
//  ArchieCardDetailsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 28/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit
import Kingfisher

class ArchieCardDetailsViewController: ETViewController,ArchieCardDetailsDelegate {
    var archieCardDetails = ArchieCardDetails()
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var archieCardImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var btnAddToCart: UIButton!
    
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        
        archieCardInteractor.addArchieCardToCart(archieCard: archieCardDetails, quantity: quantity)
        
        
    }
    var quantity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        computeTotal()
        
        archieCardInteractor.archieCardDetailsDelegate = self
        archieCardInteractor.viewDelegate = self
        
        archieCardInteractor.getArchieCardDetails(slug: slug)
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        btnPlus.applyPlusButtonTheme()
        btnMinus.applyMinusButtonTheme()
        priceLabel.textColor = .getAppThemeColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnAddToCart.applyColorTheme()
    }
    func computeTotal(){
        let selectedPrice = archieCardDetails.price?.toDouble() ?? 0
        let total = Double(quantity) * selectedPrice
        totalLabel.text! = String(total).formatToAmount(prefix: "Total: ")
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        
        quantity = quantity + 1
        quantityLabel.text = String(quantity)
        computeTotal()
        
        
    }
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        if quantity != 1 { quantity = quantity - 1}
        quantityLabel.text = String(quantity)
        computeTotal()
    }
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stockMessageLabel: UILabel!
    
    func didFetchArchieCardDetails(archieCardDetails: ArchieCardDetails) {
        self.archieCardDetails = archieCardDetails
        titleLabel.text = archieCardDetails.content
        priceLabel.text = archieCardDetails.price?.formatToAmount(prefix: "Price: ")
        computeTotal()
        
        if  let url = URL(string :archieCardDetails.image?.toValidatedImageUrl() ?? ""){
            let fallbackImage = UIImage(named: "et_fallback_image")
            archieCardImage.kf.setImage(with: url,
                                        placeholder: fallbackImage,
                                        options: [.transition(ImageTransition.fade(1))])
            
        }
        
        
    }
    
    var slug = ""
    var selectedArchieTitle = ""
    var archieCardInteractor = ArchieCardInteractor()
    
    override func getScreenTitle() -> String? {
        selectedArchieTitle.capitalized
    }
    
}
