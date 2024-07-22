//
//  countrySelection.swift
//  CurrenyConverter
//
//  Created by Sevda Abbasi on 19.07.2024.
//
import UIKit

class countrySelection: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currencies: [Currency] = []
    weak var delegate: CountrySelectionDelegate?
    var selectedLabel: UILabel? // Bu satırı ekleyin
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let currency = currencies[indexPath.row]
        cell.textLabel?.text = currency.name
        cell.detailTextLabel?.text = String(currency.rate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = currencies[indexPath.row]
        delegate?.didSelectCurrency(selectedCurrency)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
