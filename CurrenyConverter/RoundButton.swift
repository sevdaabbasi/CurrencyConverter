//
//  RoundButton.swift
//  CurrenyConverter
//
//  Created by Sevda Abbasi on 19.07.2024.
//

import Foundation
import UIKit

@IBDesignable
class RoundButton: UIButton{
    
    @IBInspectable var roundButton: Bool = false{
        didSet{
            if roundButton{
                layer.cornerRadius = frame.height/1.75
            }
        }
    }
    override func prepareForInterfaceBuilder() {
        if roundButton{
            layer.cornerRadius = frame.height/3
        }
    }
}
