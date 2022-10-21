//
//  AddBookView.swift
//  Bookworm
//
//  Created by Pham Anh Tuan on 10/21/22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = AddBookView.genres[0]
    @State private var review = ""
    
    static let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    @Environment(\.dismiss) var dismiss
    
    func isAllFieldsValid() -> Bool {
        let isBookTitleValid = !title.trimmingCharacters(in: .whitespaces).isEmpty
        let isAuthorNameValid = !author.trimmingCharacters(in: .whitespaces).isEmpty
        let isGenreValid = AddBookView.genres.contains(genre)
        
        return isBookTitleValid && isAuthorNameValid && isGenreValid
    }
    
    func save() {
        let newBook = Book(context: moc)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.rating = Int16(rating)
        newBook.genre = genre
        newBook.review = review
        
        try? moc.save()
        
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Book's title", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(AddBookView.genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }

                Section {
                    HStack {
                        Spacer()
                        Button("Save") {
                            save()
                        }
                        .disabled(!isAllFieldsValid())
                        Spacer()
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
