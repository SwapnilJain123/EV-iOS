//
//  ArchieCardViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 26/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit

class ArchieCardViewController: ETViewController, ArchieCardListDelegate , BaseViewDelegate {
    func didFetchArchieCardList(archieCardList: [ArchieCard]) {
        self.archieCardList = archieCardList
        archieCardTableView.reloadData()
    }
    
    
    var archieCardList = [ArchieCard]()
    
    @IBOutlet weak var archieCardTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        archieCardTableView.dataSource = self
        archieCardTableView.delegate = self
        
        let archieCardInteractor = ArchieCardInteractor()
        archieCardInteractor.archieCardListDelegate = self
        archieCardInteractor.viewDelegate = self
        archieCardInteractor.getArchieCards()
        
        
        
        
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_ARCHIE_CARDS
    }
    
    
    
    
    
    
}
extension ArchieCardViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        archieCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archieCardCell", for: indexPath) as! ArchiCardCell
        cell.showData(archieCard: archieCardList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "archieCardDetailsVC")as! ArchieCardDetailsViewController
        
        var selectedArchieCard = archieCardList[indexPath.row]
        VC.slug = selectedArchieCard.slug ?? ""
        VC.selectedArchieTitle = selectedArchieCard.title ?? ""
        
        
        
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
}
