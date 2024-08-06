//
//  CountrySelectionViewController.swift
//  CurrenyConverter
//
//  Created by Sevda Abbasi on 6.08.2024.
//

import UIKit

class CountrySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CurrencyViewModel!
    weak var delegate: CountrySelectionDelegate?
    var selectedLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let currency = viewModel.currencies[indexPath.row]
        cell.textLabel?.text = currency.name
        cell.detailTextLabel?.text = String(currency.rate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency = viewModel.currencies[indexPath.row]
        delegate?.didSelectCurrency(selectedCurrency)
        self.dismiss(animated: true, completion: nil)
    }
}
