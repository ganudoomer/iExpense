//
//  AddView.swift
//  iExpense
//
//  Created by Sree on 03/10/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expense: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showError = false
    static let types = ["Business","Personal"]
    var body: some View {
        NavigationView {
            Form {
                TextField("Name",text:$name)
                Picker("Type",selection: $type){
                    ForEach(Self.types,id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount",text:$amount).keyboardType(.numberPad)
            }.navigationTitle("Add new expense").navigationBarItems(leading: Button("Save"){
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expense.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                    
                } else {
                    showError.toggle()
                }
            })
        }.alert(isPresented: $showError, content: {
            Alert(title: Text("Error"), message: Text("Enter a valid number"), dismissButton: .default(Text("Okay boss")))
        })
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expense: Expenses())
    }
}
