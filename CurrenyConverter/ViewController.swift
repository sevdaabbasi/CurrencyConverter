//
//  ViewController.swift
//  CurrenyConverter
//
//  Created by Sevda Abbasi on 19.07.2024.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Label1 için Tap Gesture Recognizer ekleyin
               let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(label1Tapped))
               label1.isUserInteractionEnabled = true
               label1.addGestureRecognizer(tapGesture1)
               
               // Label2 için Tap Gesture Recognizer ekleyin
               let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(label2Tapped))
               label2.isUserInteractionEnabled = true
               label2.addGestureRecognizer(tapGesture2)
           }
    
    // Label1 tıklandığında çağrılacak işlev
      @objc func label1Tapped() {
          performSegue(withIdentifier: "segueCountry", sender: self)
      }
      
      // Label2 tıklandığında çağrılacak işlev
      @objc func label2Tapped() {
          performSegue(withIdentifier: "segueCountry", sender: self)
      }
      
      // prepare(for:sender:) işlevini override ederek segue sırasında veri aktarımı yapabilirsiniz
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "segueToFirstViewController" {
              // İlk view controller için geçiş işlemleri
          } else if segue.identifier == "segueToSecondViewController" {
              // İkinci view controller için geçiş işlemleri
          }
      }
  }



