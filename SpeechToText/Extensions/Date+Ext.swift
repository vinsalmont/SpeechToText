//
//  Date+Ext.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import Foundation


extension Date {
    func toString(with format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
