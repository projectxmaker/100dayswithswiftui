//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Pham Anh Tuan on 10/19/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var orderManager = OrderManager()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $orderManager.order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper("Number of cakes: \(orderManager.order.quantity)", value: $orderManager.order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $orderManager.order.specialRequestEnabled.animation())

                    if orderManager.order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $orderManager.order.extraFrosting)

                        Toggle("Add extra sprinkles", isOn: $orderManager.order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(orderManager: orderManager)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
