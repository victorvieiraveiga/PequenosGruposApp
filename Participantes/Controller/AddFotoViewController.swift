//
//  AddFotoViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 18/09/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage



class AddFotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var btnSelefoto: UIButton!
    @IBOutlet weak var btnAddFoto: UIButton!
    
    @IBOutlet weak var lblCarregando: UILabel!
    var imagePicker = UIImagePickerController()
   
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var lblIdImagem: UILabel!
    
    @IBOutlet weak var lblurlImagem: UILabel!
    
    
    var idImagem = NSUUID().uuidString
    var url : String?
    
    var index : Int = 0
    
    var participantes : [Participante] = []
  
    
    //var viewInclui : IncluirParticipantes = UIViewController() as! IncluirParticipantes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddFoto.isEnabled = false
        imagePicker.delegate = self
        lblCarregando.text = ""
    }
    
    
    
    @IBAction func sele_foto(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
        
      
    }
    
    @IBAction func teste(_ sender: Any) {
        print("testando")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[ UIImagePickerController.InfoKey.originalImage] as! UIImage
        foto.image = imagemRecuperada
        
        self.btnAddFoto.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func addFoto(_ sender: Any) {
        self.btnAddFoto.isEnabled = false
        self.btnSelefoto.isEnabled = false
        self.lblCarregando.text = "Carregando..."
        print("2")
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
        if let imagemSelecionada = foto.image {
            
            if let imagemDados =  imagemSelecionada.jpegData(compressionQuality: 0.5) {
                //UIImageJPEGRepresentation(imagemSelecionada,0.5) //UIImage.jpegData(imagemSelecionada)
                
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil) { (metaDados, erro) in
                    if erro == nil {
                        
                  
                        
                       self.idImagem =  "\(self.idImagem).jpg"
                        
                        
                        //self.incluiView.lblIdImagem.text = "\(self.idImagem).jpg"
                        print ("sucesso ao subir arquivo")
//                        self.performSegue(withIdentifier: "addFotoSegue", sender: self.idImagem)
                        //self.viewInclui.idImagem = "\(self.idImagem).jpg"
//                        if self.index != -1 {
//
//                            //self.participantes[self.index].idImagem = "\(self.idImagem).jpg"
//
//                        }
                        imagens.child("\(self.idImagem).jpg").downloadURL(completion: { (url, erro) in
                            if let urlImagem = url?.absoluteString {
                               // if self.index != -1 {
                                    //self.participantes[self.index].urlImagem = urlImagem
                               
                                self.lblurlImagem.text = urlImagem
                                
                                    //self.url = urlImagem
                                    
                                    
                                    //self.viewInclui.urlImagem = self.url
                             //   }
                                //self.performSegue(withIdentifier: "addFotoSegue", sender: urlImagem)
                                
                                
                            }
                        })
                        self.btnAddFoto.isEnabled = true
                        self.btnSelefoto.isEnabled = true
                        self.lblCarregando.text = ""
                        
                    }else {
                        print ("Erro ao subir arquivo")
                    }
                }
            }
        }
    }
    
//    func passaDadosIncluir(segue: UIStoryboardSegue) {
//        guard let telaController = segue.destination as? IncluirParticipantes
//        {return}
//        telaController.idImagem = self.idImagem
//        telaController.urlImagem = self.url
//}
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       let DestinoView = segue.destination as! IncluirParticipantes
//        //if segue.identifier == "addFotoSegue" {
//
//            DestinoView.idImagem =  idImagem
//            DestinoView.urlImagem = url //sender as! String
//           // DestinoView.participantes = self.participantes
//            //DestinoView.index = self.index
//        //}
//    }
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}
