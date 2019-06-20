# swifty-protein

## Liens utiles : 

- https://rest.rcsb.org/apidocs/index.jsp#/
- Download pdb : http://file.rcsb.org/ligands/download/[ligand_name]_model.pdb
- View pdb : https://files.rcsb.org/ligands/view/HEM_model.pdb
- http://www.rcsb.org/pdb/rest/ligandInfo?structureId=4HHB
- http://rest.rcsb.org/apidocs/index.jsp#!/Chemical_components/getLigandById
- Understanding pdb model files : https://pdb101.rcsb.org/learn/guide-to-understanding-pdb-data/beginner%E2%80%99s-guide-to-pdb-structures-and-the-pdbx-mmcif-format
- Modelisation moleculaire : https://fr.wikipedia.org/wiki/Mod%C3%A9lisation_mol%C3%A9culaire
- Couleurs des molecules : https://en.wikipedia.org/wiki/CPK_coloring?oldid=753391981

## Tutoriels :
- https://www.raywenderlich.com/2243-scene-kit-tutorial-getting-started


## Modelisation de la BDD : 

**Molécule :**
- LigandID (HEM)
- Nom (ex: H2O, eau)

**Atomes :**
- AtomeID (ex : C2C, B3C, ...)
- Nom (C, H, N, ...)
- LigandID (ref)
- Coordonnées (x, y, z)
- Couleur ?

**Liens :**
- LigandID (ref)
- Atome1ID (ref)
- Atome2ID (ref)
