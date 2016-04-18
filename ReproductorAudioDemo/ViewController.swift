//
//  ViewController.swift
//  ReproductorAudioDemo
//
//  Created by Jose Manuel Mora on 17/04/16.
//  Copyright © 2016 Comisión Federal de Electricidad DCS. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var txtTema: UITextField!
    @IBOutlet weak var txtArtista: UITextField!
    @IBOutlet weak var imgPortada: UIImageView!
    @IBOutlet weak var duracion: UITextField!
    @IBOutlet weak var actual: UITextField!
    private var lista = Array<Array<String>>()
    private var selec = ""
    private var reproductor : AVAudioPlayer!
    private let sonidoURL = NSBundle.mainBundle().URLForResource("", withExtension: "mp3")
    private var contador = 0
    private var aleatorio = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        llenaLista()
        
        cambiaTema(0)
    }
    
    func cambiaTema (row : Int){
        self.txtTema.text = self.lista[row][0]
        txtArtista.text = self.lista[row][1]
        
        imgPortada.image = UIImage(named: "\(self.lista[row][2]).jpg")
        self.selec = self.lista[row][2]
        
        let sonidoURL = NSBundle.mainBundle().URLForResource(self.selec, withExtension: "mp3")
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
        }catch {
            print("Error al cargar el archivo de sonido")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func llenaLista(){
        self.lista.append(["Y Tú Te Vas", "Chayanne", "c01"])
        self.lista.append(["Vuelve", "Ricky Martin", "c02"])
        self.lista.append(["Si no te hubieras ido", "Marco Antonio Solís", "c03"])
        self.lista.append(["Fuiste tú", "Ricardo Arjona feat. Gaby Moreno", "c04"])
        self.lista.append(["Qué Será De Ti", "Thalia", "c05"])
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lista.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.lista[row][0]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("Selección: \(self.lista[row][0])")
        cambiaTema(row)
        play()
    }
    
    @IBAction func volumen(sender: UIStepper) {
        //print("Volumen: \(sender.value)")
        reproductor.volume = Float(sender.value)
    }
    
    @IBAction func play() {
        //print (reproductor.volume)
        
        if !reproductor.playing {
            reproductor.play()
            let hilo=NSThread(target: self, selector: #selector(ViewController.tareaDeFondo), object: nil)
            let tmp1 : String = convierteMinutos(reproductor.duration)
            duracion.text = tmp1
            //print("Duración: \(tmp1)")
            hilo.start()
        }
    }

    @IBAction func azar() {
        
        let row = Int(arc4random_uniform(5))
        cambiaTema(row)
        
        if !reproductor.playing {
            reproductor.play()
            let hilo=NSThread(target: self, selector: #selector(ViewController.tareaDeFondo), object: nil)
            let tmp1 : String = convierteMinutos(reproductor.duration)
            duracion.text = tmp1
            hilo.start()
        }
    }
    
    @IBAction func pausa() {
        if reproductor.playing {
            reproductor.pause()
        }
    }
    
    @IBAction func stop() {
        if reproductor.playing {
            reproductor.stop()
            reproductor.currentTime = 0.0
        }
    }
    
    func tareaDeFondo(){
        self.contador = 1
        while (self.contador >= 0) {
            self.performSelectorOnMainThread( #selector(ViewController.incrementaContador), withObject: nil, waitUntilDone: false )
            sleep(1)
            contador += 1;
            if contador>=12{
                contador = -1
            }
        }
    }
    
    func incrementaContador(){
        let tmp2 : String = convierteMinutos(reproductor.currentTime)
        actual.text = tmp2
    }
    
    func convierteMinutos(segundos : Double) -> String{
        let minutos : Int = Int(segundos / 60)
        let temp1 = segundos - Double(minutos * 60)
        let segun2 : Int = Int(temp1)
        return "\(minutos):\(segun2)"
    }
    
}

