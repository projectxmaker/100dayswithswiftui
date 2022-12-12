//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Pham Anh Tuan on 10/19/22.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var orderManager: OrderManager
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(orderManager.order) else {
            showAlert(title: "Oops!", message: "Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            let alertMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            
            showAlert(title: "Thank you!", message: alertMessage)
        } catch {
            showAlert(title: "Oops!", message: "Checkout failed.")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total is \(orderManager.order.cost, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
            .environmentObject(OrderManager())
    }
}
