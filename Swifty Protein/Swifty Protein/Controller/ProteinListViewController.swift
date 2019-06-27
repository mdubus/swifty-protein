//
//  ProteinListViewController.swift
//  Swifty Protein
//
//  Created by Morgane on 18/06/2019.
//  Copyright © 2019 Morgane DUBUS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProteinListViewController:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ligands = [String]()
    var searchedLigands = [String]()
    var selectedMolecule: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        deleteAllEntities("Molecules")
        let count = getCount("Molecules")
        print(count)
        if (count == 0) {
            loadProteinsIntoCoreData()
        } else {
            let molecules = fetchAllMolecules()
            for molecule in molecules {
                ligands.append(molecule.ligand_Id!)
            }
        }
    }
    
    func loadProteinsIntoCoreData() {
        let data = loadLigandsFile()
        for d in data {
            let molecule = Molecules(context: context)
            molecule.ligand_Id = d
            do {
                try context.save()
            } catch let error{
                print(error)
            }
        }
    }
    
    func loadLigandsFile() -> [String]{
        if let filepath = Bundle.main.path(forResource: "ligands", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let data = contents.components(separatedBy: "\n").filter({ $0 != ""})
                ligands = data
                return data
            } catch {
                print("Error : 'ligands.txt' couldn't be loaded")
            }
        } else {
            print("Error : 'ligands.txt.' wasn't found")
        }
        return []
    }
}

extension ProteinListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedLigands.count > 0 ? searchedLigands.count : ligands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProteinTableViewCell
        cell.ligand = searchedLigands.count > 0 ? searchedLigands[indexPath.row] : ligands[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMolecule = searchedLigands.count > 0 ? searchedLigands[indexPath.row] : ligands[indexPath.row]
        self.performSegue(withIdentifier: "tapedCellSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tapedCellSegue") {
            let viewController = segue.destination as! ProteinViewController
            guard let molecule:Molecules = createMolecule(ligand: selectedMolecule, view: self) else {
                alert(view: self, message: "unable to create molecule in core data") ;
                return
            }
            viewController.molecule = molecule
        }
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
