//
//  ViewController.swift
//  CurrenyConverter
//
//  Created by Sevda Abbasi on 19.07.2024.
//
import UIKit

class ViewController: UIViewController, CountrySelectionDelegate {

    @IBOutlet weak var lblCountry1: UILabel!
    @IBOutlet weak var lblCountry2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    var currencies: [Currency] = []
    var selectedLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(label1Tapped))
        lblCountry1.isUserInteractionEnabled = true
        lblCountry1.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(label2Tapped))
        lblCountry2.isUserInteractionEnabled = true
        lblCountry2.addGestureRecognizer(tapGesture2)
        
        fetchData()
    }

    @objc func label1Tapped() {
        selectedLabel = lblCountry1
        performSegue(withIdentifier: "segueCountry", sender: self)
    }
    
    @objc func label2Tapped() {
        selectedLabel = lblCountry2
        performSegue(withIdentifier: "segueCountry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCountry" {
            if let destinationVC = segue.destination as? countrySelection {
                destinationVC.currencies = currencies
                destinationVC.delegate = self
                destinationVC.selectedLabel = selectedLabel
            }
        } else if segue.identifier == "segueCountry" {
            if let destinationVC = segue.destination as? countrySelection {
                destinationVC.currencies = currencies
                destinationVC.delegate = self
                destinationVC.selectedLabel = selectedLabel
            }
        }
    }
    
    func fetchData() {
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/CurrencyData/main/currency.json")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                if let data = data {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let rates = jsonResponse?["rates"] as? [String: Double] {
                            self.currencies = rates.map { Currency(name: $0.key, rate: $0.value) }
                            DispatchQueue.main.async {
                                // ViewController'da UI güncellemesi yapabilirsiniz
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "Data parsing error", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func didSelectCurrency(_ currency: Currency) {
        if let label = selectedLabel {
            label.text = "\(currency.name)"
        }
    }
}
