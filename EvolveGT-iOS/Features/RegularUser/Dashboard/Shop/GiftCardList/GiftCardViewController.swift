//
//  GiftCardViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 01/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit

class GiftCardViewController: ETViewController,GiftCardListDelegate {
    @IBOutlet weak var giftCardTableView: UITableView!
    func didFetchGiftCardList(giftCardList: [GiftCard]) {
        self.giftCardList = giftCardList
        giftCardTableVIew.reloadData()
        print("gotGiftCards")
        
    }
    
    
    var giftCardList = [GiftCard]()
  
    @IBOutlet weak var giftCardTableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftCardTableView.delegate = self
        giftCardTableView.dataSource = self
        
        let giftCardInteractor = GiftCardInteractor()
        giftCardInteractor.viewDelegate = self
        giftCardInteractor.giftCardListDelegate = self
        giftCardInteractor.getGiftCardList()
        self.ext.showBackButton()
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_GIFT_CARDS
    }

  
}

extension GiftCardViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        giftCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "giftCardCell", for: indexPath) as! GiftCardCell
        cell.showData(giftCard: giftCardList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "giftCardDetailsVC")as! GiftCardDetailsViewController
        
        let selectedGiftCard = giftCardList[indexPath.row]
        VC.slug = selectedGiftCard.slug ?? ""
        VC.screenTitle = selectedGiftCard.title ?? ""
        
        
        navigationController?.pushViewController(VC, animated: true)
               
    }
    
    
    
}


