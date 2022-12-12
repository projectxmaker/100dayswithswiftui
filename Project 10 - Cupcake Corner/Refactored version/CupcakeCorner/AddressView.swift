//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Pham Anh Tuan on 10/19/22.
//

import SwiftUI

struct AddressView: View {
    @EnvironmentObject var orderManager: OrderManager
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orderManager.order.name)
                TextField("Street Address", text: $orderManager.order.streetAddress)
                TextField("City", text: $orderManager.order.city)
                TextField("Zip", text: $orderManager.order.zip)
            }

            Section {
                NavigationLink {
                    CheckoutView()
                } label: {
                    Text("Check out")
                }
            }
            .disabled(orderManager.order.hasValidAddress == false)

        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView()
            .environmentObject(OrderManager())
    }
}
