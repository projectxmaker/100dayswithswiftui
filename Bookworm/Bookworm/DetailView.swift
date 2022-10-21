//
//  DetailView.swift
//  Bookworm
//
//  Created by Pham Anh Tuan on 10/21/22.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    let book: Book

    func deleteBook() {
        moc.delete(book)

        try? moc.save()
        dismiss()
    }
    
    func getBookGenre() -> String {
        getDescription(of: book.genre, defaultString: "Fantasy")
    }
    
    func getDescription(of info: String?, defaultString: String) -> String {
        guard
            let val = info,
            !val.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return defaultString
        }
        
        return val
    }
    
    func getDateDescription() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        return dateFormatter.string(from: book.date ?? .now)
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(getBookGenre())
                    .resizable()
                    .scaledToFit()

                Text(getBookGenre().uppercased())
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(getDescription(of: book.author, defaultString: "Unknown author"))
                .font(.title)
                .foregroundColor(.secondary)

            Text(getDescription(of: book.review, defaultString: "No review"))
                .padding()

            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
            
            Text(getDateDescription())
                .padding()
                .font(.caption2)
        }
        .navigationTitle(getDescription(of: book.title, defaultString: "Unknown book"))
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }

}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."

        return NavigationView {
            DetailView(book: book)
        }
    }
}
