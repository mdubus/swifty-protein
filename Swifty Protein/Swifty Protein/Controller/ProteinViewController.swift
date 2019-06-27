import UIKit
import SceneKit
import Accelerate
import CoreData

class ProteinViewController: UIViewController {
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var moleculeName: String  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupScene()
        setupCamera()
        createMolecule(ligand: moleculeName)
        
//        spawnAtom()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = (self.view as! SCNView)
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnAtom() {
        var geometry: SCNGeometry
        var geometry2: SCNGeometry
        let pos1 = simd_float3(x:2, y:5, z:6)
        let pos2 = simd_float3(x:10, y:1, z:3)
        let yAxis = simd_float3(x:0, y:1, z:0)
        let diff = pos2 - pos1
        let norm = simd_normalize(diff)
        let dot = simd_dot(yAxis, norm)
        
        geometry = SCNSphere(radius: 0.6)
        geometry2 = SCNCylinder(radius: 0.3, height: 1)
        
        let geometryNode1 = SCNNode(geometry: geometry)
        let geometryNode2 = SCNNode(geometry: geometry)
        let geometryNode3 = SCNNode(geometry: geometry2)
        
        if (abs(dot) < 0.999999)
        {
            let cross = simd_cross(yAxis, diff)
            let quaternion = simd_quatf(vector: simd_float4(x: cross.x, y: cross.y, z: cross.z, w: 1 + dot))
            geometryNode3.simdOrientation = simd_normalize(quaternion)
        }
        
        geometryNode1.simdPosition = pos1
        geometryNode2.simdPosition = pos2
        geometryNode3.simdPosition = diff / 2 + pos1
        geometryNode3.simdScale = simd_float3(x: 1, y: simd_length(diff), z: 1)
        
        scnScene.rootNode.addChildNode(geometryNode1)
        scnScene.rootNode.addChildNode(geometryNode2)
        scnScene.rootNode.addChildNode(geometryNode3)
    }
    
    func createAtom(splitAtomLine: [String], molecule : Molecules){
        let atom = Atoms(context: context)
        
        atom.type = splitAtomLine[11]
        atom.atom_Id = Int16(splitAtomLine[1])!
        atom.name = splitAtomLine[2]
        atom.coor_X = Float(splitAtomLine[6])!
        atom.coor_Y = Float(splitAtomLine[7])!
        atom.coor_Z = Float(splitAtomLine[8])!
        
//        print(atom)
        molecule.addToAtom(atom)
        AddOneSphere(atom: atom)
    }
    
    func createLink(newLink: [String], molecule : Molecules){
        /*
         newLink[1] est l atom de ref, les suivant sont ses connections.
         si l'id des suivant est superieur a celui de ref alors ont inscrit une nouvelle connection.
         sinon elle a logiquement deja été inscrite
         */

        let firstId = Int16(newLink[1])!
        for index in 2..<newLink.count{
            let link = Links(context: context)
            if (firstId < Int16(newLink[index])!){
                link.atome1_ID = firstId
                link.atome2_ID = Int16(newLink[index])!
                molecule.addToLinks(link)
            }
        }
    }
    
    func AddOneSphere(atom: Atoms){
        
        var geometry: SCNGeometry
        
        geometry = SCNSphere(radius: 0.4)
        let geometryNode1 = SCNNode(geometry: geometry)
        geometryNode1.position = SCNVector3(x: atom.coor_X, y: atom.coor_Y, z: atom.coor_Z)
        scnScene.rootNode.addChildNode(geometryNode1)
    }
    
    func createMolecule(ligand: String){
        let molecule = Molecules(context: context)
        molecule.name = "Ma molecule"
        molecule.ligand_Id = ligand
        
        guard let moleculePdb = parseHtml(ligand: ligand) else {alert(view: self, message: "Impossible de recuperer la molecule"); return}
        let pdbLines = moleculePdb.components(separatedBy: "\n").filter({$0 != ""})
        
        for line in pdbLines{
            let lineTmp = line.components(separatedBy: " ").filter({$0 != ""})
            
            if (lineTmp[0] == "ATOM"){
                createAtom(splitAtomLine: lineTmp, molecule: molecule)
            }
            else if (lineTmp[0] == "CONECT"){
                createLink(newLink: lineTmp, molecule: molecule)
            }
            else{
                print("End of file\n")
            }
        }
        
        do {
            try context.save()
            print("bien sauvegardé")
        } catch let error{
            print(error)
        }
//        print(molecule.links?.allObjects)
    }
    
    func parseHtml(ligand: String) -> String?{
        let url = URL(string: "https://files.rcsb.org/ligands/view/" + ligand + "_ideal.pdb")
        do{
            let richText = try String(contentsOf: url!)
            //            print(richText)
            return richText
        }catch let error{
            print(error)
        }
        return nil
    }
}


//    func createLink(newLink: Array<Substring>){
//        /*
//            newLink[1] est l atom de ref, les suivant sont ses connections.
//            si l'id des suivant est superieur a celui de ref alors ont inscrit une nouvelle connection.
//            sinon elle a logiquement deja été inscrite
//        */
//
//        let firstId = Int(newLink[1])!
//        for secondId in 2..<newLink.count{
//            if (firstId < Int(secondId)){
//                molecule.links.append((firstId, Int(secondId)))
//            }
//        }
//    }
//
//    func AddOneSphere(moleculePdb: String){
//
//        var geometry: SCNGeometry
//
//        geometry = SCNSphere(radius: 0.6)
//        let geometryNode1 = SCNNode(geometry: geometry)
//        geometryNode1.position = SCNVector3(x:2, y:5, z:6)
//        scnScene.rootNode.addChildNode(geometryNode1)
//
//    }


