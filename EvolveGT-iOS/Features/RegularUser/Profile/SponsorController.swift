//
//  SponsorController.swift
//  EvolveGT-iOS
//
//  Created by Swapnil Jain on 06/07/25.
//  Copyright © 2025 YaraTech. All rights reserved.
//


import Foundation
import UIKit
import SkyFloatingLabelTextField

protocol SponsorControllerDelegate:AnyObject {
    func didSponsorSelected(sponsorId:String)
}

class SponsorController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:SponsorControllerDelegate?
    
    // Store values from each text field
    var arrSponsor: [Sponsor] = []
    var arrSelectedSponsor: [String] = []
    let interactor = RegisterInteractor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        btnSave.applyColorTheme()
        getSponsorData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSponsor.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SponsorCell.identifier, for: indexPath) as? SponsorCell else {
            return UITableViewCell()
        }
        let sponsor = arrSponsor[indexPath.row]
        let isSelected = arrSelectedSponsor.contains(String(sponsor.id))
        cell.configure(text: sponsor.name, isSelected: isSelected)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = arrSponsor[indexPath.row].id
        if let index = arrSelectedSponsor.firstIndex(of: String(id)) {
            arrSelectedSponsor.remove(at: index)
        } else {
            arrSelectedSponsor.append(String(id))
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print("Entered values:", arrSponsor)
        let strSponsorId = arrSelectedSponsor.joined(separator: ",")
        delegate?.didSponsorSelected(sponsorId: strSponsorId)
        self.navigationController?.popViewController(animated: true )
        // You can validate or send this data to API
    }
    
    func getSponsorData() {
        interactor.checkEmailVerification { result in
            switch result {
            case .success(let themeData):
                self.arrSponsor = themeData.allSponsors ?? []
                print(self.arrSponsor)
                self.tableView.reloadData()
            case .failure(let error):
                print("Failed to fetch theme: \(error.localizedDescription)")
            }
        }
    }
}
