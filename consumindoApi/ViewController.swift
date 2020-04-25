//
//  ViewController.swift
//  consumindoApi
//
//  Created by Alexandre de Oliveira Nepomuceno on 25/04/20.
//  Copyright © 2020 Alexandre de Oliveira Nepomuceno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var atualizarTexto: UIButton!
    @IBOutlet weak var legendaLabel: UILabel!
    
    @IBAction func btnAtualizar(_ sender: Any) {
         self.Atualizar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Atualizar()
    }
    
    func formatarPreco(preco: NSNumber)-> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        if let retornoPreco = nf.string(from: preco){
            return retornoPreco
        }
        return ""
    }
    
    
    func Atualizar(){
        
        self.atualizarTexto.setTitle("Atualizando...", for: .normal)
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            let tarefa = URLSession.shared.dataTask(with: url){
                (dados,requicao,erro) in
                
                if erro != nil {
                    print("Erro ao solicitar requisição")
                    DispatchQueue.main.async(execute: {
                         self.atualizarTexto.setTitle("Atualizar", for: .normal)
                    })
                   
                }else{
                    
                    if let dadosRetorno = dados {
                        do{
                            if let objetojson = try JSONSerialization.jsonObject(with: dadosRetorno,  options: [])
                                as? [String: Any] {
                                
                                if let brl = objetojson["BRL"] as? [String: Any]{
                                    if let preco = brl["buy"] as? Double {
                                        let formartarPreco = self.formatarPreco(preco: NSNumber(value: preco))
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.legendaLabel.text = "R$ " + formartarPreco
                                            self.atualizarTexto.setTitle("Atualizar", for: .normal)
                                        })
                                    }
                                }
                            }
                        }catch{
                            print("erro ao converter dados")
                        }
                    }
                    
                }
            }
            tarefa.resume()
        }
    }
}

