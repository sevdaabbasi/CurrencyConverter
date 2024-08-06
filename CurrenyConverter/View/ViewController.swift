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
    
    private let viewModel = CurrencyViewModel()
    var selectedLabel: UILabel?
    var firstOperand: String = ""
    var secondOperand: String = ""
    var currentOperation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        
        viewModel.onCurrenciesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.setDefaultCurrencies()
            }
        }
        
        viewModel.onConversionUpdated = { [weak self] convertedAmount in
            DispatchQueue.main.async {
                self?.label2.text = String(format: "%.2f", convertedAmount)
            }
        }
        
        viewModel.fetchData()
    }
    
    private func setupGestures() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(label1Tapped))
        lblCountry1.isUserInteractionEnabled = true
        lblCountry1.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(label2Tapped))
        lblCountry2.isUserInteractionEnabled = true
        lblCountry2.addGestureRecognizer(tapGesture2)
    }

    @objc private func label1Tapped() {
        selectedLabel = lblCountry1
        performSegue(withIdentifier: "segueCountry", sender: self)
    }
    
    @objc private func label2Tapped() {
        selectedLabel = lblCountry2
        performSegue(withIdentifier: "segueCountry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCountry" {
            if let destinationVC = segue.destination as? CountrySelectionViewController {
                destinationVC.viewModel = viewModel
                destinationVC.delegate = self
                destinationVC.selectedLabel = selectedLabel
            }
        }
    }
    
    @IBAction func clearBtnClick(_ sender: Any) {
        label1.text = "0"
        label2.text = "0"
        firstOperand = ""
        secondOperand = ""
    }
    
    @IBAction func removeBtnClick(_ sender: Any) {
        if var text = label1.text, !text.isEmpty {
            text.removeLast()
            if text.isEmpty {
                text = "0"
            }
            label1.text = text
            if let amount = Double(text) {
                viewModel.updateConvertedValue(amount: amount)
            }
        }
    }
    
    @IBAction func switchBtnClick(_ sender: Any) {
        // Text değerlerini geçici bir değişkende sakla
        let tempCountryText = lblCountry1.text
        lblCountry1.text = lblCountry2.text
        lblCountry2.text = tempCountryText

        // ViewModel içindeki para birimlerini de yer değiştir
        let tempCurrency = viewModel.selectedCurrency1
        viewModel.selectedCurrency1 = viewModel.selectedCurrency2
        viewModel.selectedCurrency2 = tempCurrency

        // Label1'deki text'i double olarak al ve güncellenmiş para birimlerine göre dönüşümü hesapla
        if let amount = Double(label1.text ?? "0") {
            viewModel.updateConvertedValue(amount: amount)
        }
    }
    
    @IBAction func partitionBtnClick(_ sender: Any) { setOperation("/") }
    @IBAction func btnClick1(_ sender: Any) { appendToLabel1("1") }
    @IBAction func btnClick2(_ sender: Any) { appendToLabel1("2") }
    @IBAction func btnClick3(_ sender: Any) { appendToLabel1("3") }
    @IBAction func multiplicationBtnClick(_ sender: Any) { setOperation("*") }
    @IBAction func btnClick4(_ sender: Any) { appendToLabel1("4") }
    @IBAction func btnClick5(_ sender: Any) { appendToLabel1("5") }
    @IBAction func btnClick6(_ sender: Any) { appendToLabel1("6") }
    @IBAction func extractionBtnClick(_ sender: Any) { setOperation("-") }
    @IBAction func btnClick7(_ sender: Any) { appendToLabel1("7") }
    @IBAction func btnClick8(_ sender: Any) { appendToLabel1("8") }
    @IBAction func btnClick9(_ sender: Any) { appendToLabel1("9") }
    @IBAction func additionBtnClick(_ sender: Any) { setOperation("+") }
    @IBAction func btnClick0(_ sender: Any) { appendToLabel1("0") }
    @IBAction func commaBtnClick(_ sender: Any) { appendToLabel1(".") }
    @IBAction func percentBtnClick(_ sender: Any) { setOperation("%") }
    @IBAction func equalsBtnClick(_ sender: Any) { calculateResult() }
    
    private func appendToLabel1(_ value: String) {
        if let text = label1.text {
            if text == "0" {
                label1.text = value
            } else {
                label1.text = text + value
            }
        } else {
            label1.text = value
        }
        if let amount = Double(label1.text ?? "0") {
            viewModel.updateConvertedValue(amount: amount)
        }
    }
    
    private func setOperation(_ operation: String) {
        if let text = label1.text, !text.isEmpty {
            firstOperand = text
            currentOperation = operation
            label1.text = ""
        }
    }
    
    private func calculateResult() {
        if let text = label1.text, !text.isEmpty {
            secondOperand = text
            if let firstValue = Double(firstOperand), let secondValue = Double(secondOperand) {
                var result: Double = 0
                switch currentOperation {
                case "+":
                    result = firstValue + secondValue
                case "-":
                    result = firstValue - secondValue
                case "*":
                    result = firstValue * secondValue
                case "/":
                    result = firstValue / secondValue
                case "%":
                    result = firstValue.truncatingRemainder(dividingBy: secondValue)
                default:
                    break
                }
                label1.text = "\(result)"
                if let amount = Double(label1.text ?? "0") {
                    viewModel.updateConvertedValue(amount: amount)
                }
            }
        }
    }
    
    func didSelectCurrency(_ currency: Currency) {
        if selectedLabel == lblCountry1 {
            viewModel.selectedCurrency1 = currency
            lblCountry1.text = "\(currency.name)"
        } else if selectedLabel == lblCountry2 {
            viewModel.selectedCurrency2 = currency
            lblCountry2.text = "\(currency.name)"
        }
        if let amount = Double(label1.text ?? "0") {
            viewModel.updateConvertedValue(amount: amount)
        }
    }
    
    private func setDefaultCurrencies() {
        if let tryCurrency = viewModel.currencies.first(where: { $0.name == "TRY" }),
           let eurCurrency = viewModel.currencies.first(where: { $0.name == "EUR" }) {
            viewModel.selectedCurrency1 = tryCurrency
            viewModel.selectedCurrency2 = eurCurrency
            lblCountry1.text = "TRY"
            lblCountry2.text = "EUR"
            if let amount = Double(label1.text ?? "0") {
                viewModel.updateConvertedValue(amount: amount)
            }
        }
    }
}
