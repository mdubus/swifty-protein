import UIKit
import SceneKit
import Accelerate

class ProteinViewController: UIViewController {
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var molecule: Molecule!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
                spawnAtom()
//        CreateMolecule(moleculePdb: "ATOM      1  CHA HEM A   1       2.748 -19.531  39.896  1.00 10.00           C")
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
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 60)
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnAtom() {
        // 1
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
        
        // 4
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
        // 5
        
        scnScene.rootNode.addChildNode(geometryNode1)
        scnScene.rootNode.addChildNode(geometryNode2)
        scnScene.rootNode.addChildNode(geometryNode3)
        
        
    }
    
    func createAtom(atomPdb: Array<Substring>) -> Atom{
        let atom = Atom(
                    name: String(atomPdb[11]),
                    Id: Int(atomPdb[1])!)
        return atom
    }
    
    func createLink(newLink: Array<Substring>){
        /*
            newLink[1] est l atom de ref, les suivant sont ses connections.
            si l'id des suivant est superieur a celui de ref alors ont inscrit une nouvelle connection.
            sinon elle a logiquement deja été inscrite
        */
        
        let firstId = Int(newLink[1])!
        for secondId in 2..<newLink.count{
            if (firstId < Int(secondId)){
                molecule.links.append((firstId, Int(secondId)))
            }
        }
    }
    
    func CreateMolecule(moleculePdb: String){
        
        //separation du fichier pdb par ligne
        let moleculePdbLines = moleculePdb.split(separator: "\n")
        var lineTmp: Array<Substring>!
        
        for line in moleculePdbLines{
            lineTmp = line.split(separator: " ")
            
            if (lineTmp[0] == "ATOM"){
                molecule.structure.append(createAtom(atomPdb: lineTmp))
            }
            else if (lineTmp[0] == "CONECT"){
                createLink(newLink: lineTmp)
            }
            else{
                print("End of file\n")
            }
        }
//        var geometry: SCNGeometry
//
//        geometry = SCNSphere(radius: 0.6)
//        let geometryNode1 = SCNNode(geometry: geometry)
//        geometryNode1.position = SCNVector3(x:2, y:5, z:6)
//        scnScene.rootNode.addChildNode(geometryNode1)
        
    }
    
}



