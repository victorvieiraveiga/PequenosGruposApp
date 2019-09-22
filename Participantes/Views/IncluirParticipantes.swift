//
//  IncluirParticipantes.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 19/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class IncluirParticipantes: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtIdCelula: UILabel!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtTelefone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var dtDataNascimento: UIDatePicker!
    @IBOutlet weak var txtDataNascimento: UILabel!
    
    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var btnSeleFoto: UIButton!
    
    @IBOutlet weak var btnAddFoto: UIButton!
    var urlImagem : String?
    //var idImagem : String?
    var idImagem = NSUUID().uuidString
    
    var  dataNasc : String = ""
    var participantes : [Participante] = []
    var index : Int = -1
    
    var idParticipante : String = ""
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        btnAddFoto.isEnabled = false
        
        
        //Carregar o id da celula do usuario logado
        if participantes.count == 0 {
        
        var autenticacao = Auth.auth()
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            
            let usuarioLogado = usuario?.uid
            let database = Database.database().reference()
            let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
            
            celula.observeSingleEvent(of: DataEventType.childAdded, with: { (CelulaSnapshot) in
                let dadosCel = CelulaSnapshot.value as! NSDictionary
                do {
                    self.txtIdCelula.text = dadosCel["idCelula"] as? String
                   }
                catch {
                    print ("Erro")
                }
            })
        }
        } else {
            
            let participanteDados = self.participantes[index]
            
            //self.txtIdCelula = 
            self.txtNome.text = participanteDados.nome
            self.txtEndereco.text = participanteDados.endereco
            self.txtTelefone.text = participanteDados.telefone
            self.txtEmail.text = participanteDados.email
            self.dtDataNascimento.date =  dataFormatada(data: participanteDados.dataNascimento ) 
            self.txtDataNascimento.text = participanteDados.dataNascimento
            self.txtIdCelula.text = participanteDados.idCelula
            self.idParticipante = participanteDados.idParticipante
            self.idImagem = participanteDados.idImagem
            self.urlImagem = participanteDados.urlImagem
            
        }
        

        
    }
    

    @IBAction func salvar_participante(_ sender: Any) {
        
        
        if self.participantes.count > 0 {
            self.Alterar ()
        } else {
            self.Salvar ()
        }
    }
    
    func Alterar () {
        do  {
            let database = Database.database().reference()
            let participantes = database.child("participantes")
        
           
           // self.chave = partiSnapshot.key
                self.dtDataNascimento.date = Date()
            let idCelula = self.txtIdCelula.text
            let nome  =  self.txtNome.text
            let endereco = self.txtEndereco.text
            let email = self.txtEmail.text
            
            let partDados = ["idCelula" : idCelula, "nome": nome, "endereco" : endereco, "email" : email, "telefone" : self.txtTelefone.text, "dataNascimento" : self.txtDataNascimento.text, "idImagem" : self.idImagem, "urlImagem" : self.urlImagem] as [String : Any]
            
            participantes.child(self.idParticipante).setValue(partDados)
            
            self.performSegue(withIdentifier: "cadastroParticipanteSegue", sender: nil)
            
            self.txtNome.text = ""
            self.txtEndereco.text = ""
            self.txtTelefone.text = ""
            self.txtEmail.text = ""
            self.txtDataNascimento.text = ""
         
            }catch {
                self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Erro ao salvar participante ")
            }
        
    }
    
    func Salvar () {
        var partipOk : Bool = true
        
        if txtNome.text!.isEmpty {
            exibeMensagemCancela(titulo: "Erro.", mensagem: "Favor Preencher o nome.")
            partipOk = false
        }else {partipOk=true}
        if txtEndereco.text!.isEmpty{
            exibeMensagemCancela(titulo: "Erro.", mensagem: "Favor Preencher o endereco.")
            partipOk = false
        }else {partipOk=true}
        if txtEmail.text!.isEmpty{
            exibeMensagemCancela(titulo: "Erro.", mensagem: "Favor Preencher o email.")
            partipOk = false
        }else {partipOk=true}
        
        if txtDataNascimento.text!.isEmpty {
            exibeMensagemCancela(titulo: "Erro.", mensagem: "Favor Preencher a data de nascimento.")
            partipOk = false
        }else {partipOk=true}

        if partipOk
            {
                    do  {
                    let database = Database.database().reference()

                        if self.idImagem == nil {
                            self.idImagem = ""
                        }
                        if self.urlImagem == nil {
                            self.urlImagem = ""
                        }
                        
                        
                        //let urlCont = containerView.lblurlImagem.text as! String
                       // let idImagemCont = containerView.lblIdImagem.text
//                        let nome = self.txtNome.text
//                        let endereco = self.txtEndereco.text
//                        let email = self.txtEmail.text
//                        let telefone = self.txtTelefone.text
                        
                    let participantes = database.child("participantes")
//                        let partDados = ["idCelula" : self.txtIdCelula.text, "nome": nome, "endereco" : endereco, "email" : email, "telefone" : self.txtTelefone.text, "dataNascimento" : self.txtDataNascimento.text, "idImagem" : idImagemCont, "urlImagem":urlCont ] as [String : Any]
                        
                    let partDados = ["idCelula" : self.txtIdCelula.text, "nome": self.txtNome.text, "endereco" : self.txtEndereco.text, "email" : self.txtEmail.text, "telefone" : self.txtTelefone.text, "dataNascimento" : self.txtDataNascimento.text, "idImagem" : self.idImagem, "urlImagem":self.urlImagem ] as [String : Any]
                    
                    participantes.childByAutoId().setValue(partDados)
                    //self.exibeMensagemAlerta(titulo: "Sucesso.", mensagem: "Participante salvo.")
                        
                    self.performSegue(withIdentifier: "cadastroParticipanteSegue", sender: nil)

                    self.txtNome.text = ""
                    self.txtEndereco.text = ""
                    self.txtTelefone.text = ""
                    self.txtEmail.text = ""
                    self.txtDataNascimento.text = ""
                    self.dtDataNascimento.date = Date()
                        
                    }catch {
                        self.exibeMensagemAlerta(titulo: "Erro", mensagem: "Erro ao salvar participante ")
                    }
            }
        }
    
    func dataFormatada (data: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let dataFormatada = dateFormatter.date(from: data) else {return Date()}
        return dataFormatada
    }

    
    @IBAction func datePickerChange(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtDataNascimento.text = dateFormatter.string(from: self.dtDataNascimento.date)
    }
    
    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }

    func exibeMensagemCancela (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let CancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil)
        myAlert.addAction(CancelAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func esconde_teclado_nome(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func esconde_teclado_end(_ sender: Any) {
         self.resignFirstResponder()
    }
    
    @IBAction func esconde_teclado_tel(_ sender: Any) {
         self.resignFirstResponder()
    }
    
    @IBAction func esconde_teclado_email(_ sender: Any) {
         self.resignFirstResponder()
    }
    
    @IBAction func esconde_picker(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFoto" {
           // if self.index == -1 {carregaArrayParticipante(indice: 0)}
        let DestinoView = segue.destination as! AddFotoViewController
            DestinoView.participantes = self.participantes
            DestinoView.index = self.index
            
        }
        
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[ UIImagePickerController.InfoKey.originalImage] as! UIImage
        foto.image = imagemRecuperada
        
        self.btnAddFoto.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func sele_foto(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func add_foto(_ sender: Any) {
        self.btnAddFoto.isEnabled = false
        self.btnSeleFoto.isEnabled = false
        //self.lblCarregando.text = "Carregando..."
       
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
        if let imagemSelecionada = foto.image {
            
            if let imagemDados =  imagemSelecionada.jpegData(compressionQuality: 0.5) {
                
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil) { (metaDados, erro) in
                    if erro == nil {
 
                        self.idImagem =  "\(self.idImagem).jpg"
                        print ("sucesso ao subir arquivo")
                        
                        imagens.child("\(self.idImagem).jpg").downloadURL(completion: { (url, erro) in
                            print (url?.absoluteString)
                        })
                        
//                        imagens.downloadURL(completion: { (url, erro) in
//                            if let urlImagemN = url?.absoluteString {
//                                // if self.index != -1 {
//                                //self.participantes[self.index].urlImagem = urlImagem
//
//                                self.urlImagem = urlImagemN
//                            }
//                        })
                        
//                        imagens.child("\(self.idImagem).jpg").downloadURL(completion: { (url, erro) in
//
//                            if let urlImagemN = url?.absoluteString {
//                                // if self.index != -1 {
//                                //self.participantes[self.index].urlImagem = urlImagem
//
//                                self.urlImagem = urlImagemN
//                            }
//                        })
                        
                        
                       // imagens.child("\(self.idImagem).jpg").downloadURL(completion: { (url, erro) in
                            
                       //     if let urlImagemN = url?.absoluteString {
                                // if self.index != -1 {
                                //self.participantes[self.index].urlImagem = urlImagem
                                
                       //         self.urlImagem = urlImagemN
 
                        //    }
                     //   })
                        self.btnAddFoto.isEnabled = true
                        self.btnSeleFoto.isEnabled = true
                        //self.lblCarregando.text = ""
                        
                    }else {
                        print ("Erro ao subir arquivo")
                    }
                }
            }
        }
    }
}


