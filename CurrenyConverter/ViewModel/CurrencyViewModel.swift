//
//  CurrencyViewModel.swift
//  CurrenyConverter
//
//  Created by Sevda Abbasi on 6.08.2024.
//

import Foundation

class CurrencyViewModel {
    var currencies: [Currency] = []
    var selectedCurrency1: Currency?
    var selectedCurrency2: Currency?
    
    var onCurrenciesUpdated: (() -> Void)?
    var onConversionUpdated: ((Double) -> Void)?
    
    func fetchData() {
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/CurrencyData/main/currency.json")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { [weak self] (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    // Error handling (could be updated to use a delegate or callback)
                }
            } else {
                if let data = data {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let rates = jsonResponse?["rates"] as? [String: Double] {
                            self?.currencies = rates.map { Currency(name: $0.key, rate: $0.value) }
                            DispatchQueue.main.async {
                                self?.onCurrenciesUpdated?()
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            // Error handling (could be updated to use a delegate or callback)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func convert(amount: Double, from currency1: Currency, to currency2: Currency) -> Double {
        let rate1 = currency1.rate
        let rate2 = currency2.rate
        return amount * (rate2 / rate1)
    }
    
    func updateConvertedValue(amount: Double) {
        guard let currency1 = selectedCurrency1, let currency2 = selectedCurrency2 else { return }
        let convertedAmount = convert(amount: amount, from: currency1, to: currency2)
        onConversionUpdated?(convertedAmount)
    }
}

