//
//  Currency.swift
//  CurrenyConverter
//
//  Created by Sevda Abbasi on 19.07.2024.
//

import Foundation

struct Currency {
    let name: String
    let rate: Double
}


protocol CountrySelectionDelegate: AnyObject {
    func didSelectCurrency(_ currency: Currency)
}
