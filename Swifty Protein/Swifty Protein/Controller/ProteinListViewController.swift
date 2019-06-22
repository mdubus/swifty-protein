//
//  ProteinListViewController.swift
//  Swifty Protein
//
//  Created by Morgane on 18/06/2019.
//  Copyright © 2019 Morgane DUBUS. All rights reserved.
//

import Foundation
import UIKit


// TODO : Check if ligands are already in database
// If not, push them

class ProteinListViewController:UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ligands = [String]()
    var searchedLigands = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLigandsFile()
    }
    
    func loadLigandsFile(){
        if let filepath = Bundle.main.path(forResource: "ligands", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                ligands = contents.components(separatedBy: "\n").filter({ $0 != ""})
            } catch {
                print("Error : 'ligands.txt' couldn't be loaded")
            }
        } else {
            print("Error : 'ligands.txt.' wasn't found")
        }
    }
}

extension ProteinListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchedLigands.count > 0) {
            return searchedLigands.count
        }
        else {
            return ligands.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProteinTableViewCell

        if (searchedLigands.count > 0)
        {
            cell.ligand = searchedLigands[indexPath.row]
        }
        else {
            cell.ligand = ligands[indexPath.row]
        }
        return cell
    }
}


extension ProteinListViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedLigands = ligands.filter({$0.contains(searchText)})
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedLigands = []
        tableView.reloadData()
    }
}
