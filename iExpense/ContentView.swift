//
//  ContentView.swift
//  iExpense
//
//  Created by Sree on 02/10/21.
//

import SwiftUI


// This type can be identified uniquely
struct ExpenseItem: Identifiable,Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}


class Expenses : ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try?
                encoder.encode(items) {
                UserDefaults.standard.set(encoded,forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            //obj.self refer to the type of the object 
            if let decoded = try? decoder.decode([ExpenseItem].self, from:items){
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

// SwiftUi needs ID
// UUID is supported

// Codable PROTOCAL
// USER DEFAULTS


struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationView {
            List {
                // We can remove the id thing
                    ForEach(expenses.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name).font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            if item.amount <= 10 {
                                Text("$\(item.amount)").foregroundColor(.green)
                            }
                            if item.amount <= 100 {
                                Text("$\(item.amount)").foregroundColor(.blue)
                            }
                            
                            if item.amount > 100 {
                                Text("$\(item.amount)").foregroundColor(.red)
                            }
                            
                        }.accessibilityElement(children: .ignore).accessibilityLabel("\(item.name) amount \(item.amount)")
                            .accessibility(hint:Text("type \(item.type)"))
                        

                    }
                    .onDelete(perform: { indexSet in
                        remvoeItems(at: indexSet)
                    })
            }.navigationTitle("iExpense")
            .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
                        }
                    }
            .navigationBarItems(trailing: HStack{
                Button(action: {
                    self.showingAddExpense.toggle()
                }){
                    Image(systemName:"plus")
                }
                
            } )
        }.sheet(isPresented: $showingAddExpense, content: {
            AddView(expense: self.expenses)
        })
    }

    func remvoeItems(at offSets: IndexSet){
        expenses.items.remove(atOffsets: offSets)
    }

}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



