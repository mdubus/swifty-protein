//
//  Molecule.swift
//  Swifty Protein
//
//  Created by Adrien Fourcade on 18/06/2019.
//  Copyright © 2019 Morgane DUBUS. All rights reserved.
//

import Foundation

class Atom: NSObject {
    let name: String!
    let Id: String!
    let links: [String]!
    //let coordinate: simd_float3!
    
    init (name: String, Id: String, links: [String] /*,coordinate: simd_float3*/){
        self.name = name
        self.Id = Id
        self.links = links
        //self.coordinate = coordinate
    }
}

class Molecule: NSObject {
    let name: String!
    let ligandId: String!
    let structure: [Atom]
    
    init (name: String, ligandId: String, structure: [Atom]){
        self.name = name
        self.ligandId = ligandId
        self.structure = structure
    }
}

