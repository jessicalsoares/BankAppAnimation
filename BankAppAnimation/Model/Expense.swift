//
//  Expense.swift
//  BankAppAnimation
//
//  Created by Jessica Soares on 31/10/2023.
//

import SwiftUI

// Expense Model

struct Expense: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var amountSpent : String
    var product : String
    var productIcon : String
    var spendType : String
}


