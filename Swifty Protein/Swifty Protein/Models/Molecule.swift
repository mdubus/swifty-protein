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
    let Id: Int!
    //let coordinate: simd_float3!
    
    init (name: String, Id: Int /*,coordinate: simd_float3*/){
        self.name = name
        self.Id = Id
        //self.coordinate = coordinate
    }
}

class Molecule: NSObject {
    let name: String!
    let ligandId: String!
    var structure: [Atom]
    var links: [(Int, Int)]!
    
    init (name: String, ligandId: String, structure: [Atom], links: [(Int, Int)] ){
        self.name = name
        self.ligandId = ligandId
        self.structure = structure
        self.links = links
    }
}
