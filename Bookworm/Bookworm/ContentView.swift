//
//  ContentView.swift
//  Bookworm
//
//  Created by Pham Anh Tuan on 10/20/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>

    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        Text(book.title ?? "Unknown Title")
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
           .navigationTitle("Bookworm")
           .toolbar {
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button {
                       showingAddScreen.toggle()
                   } label: {
                       Label("Add Book", systemImage: "plus")
                   }
               }
           }
           .sheet(isPresented: $showingAddScreen) {
               AddBookView()
           }
       }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
