//
//  ContentViewModel.swift
//  WordScramble
//
//  Created by Pham Anh Tuan on 12/8/22.
//

import Foundation
import UIKit

@MainActor
class ContentViewModel: ObservableObject {
    // MARK: - Published variables
    @Published var usedWords = [String]()
    @Published var newWord = ""
    @Published var showingError = false
    @Published var totalLetters = 0
    
    // MARK: - Other variables
    var rootWord = ""
    var errorTitle = ""
    var errorMessage = ""
    var allWords = [String]()
    
    // MARK: - Functions
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // exit if the remaining string is empty
        guard answer.count > 0 else { return }

        guard isValidLength(word: answer) else {
            wordError(title: "Word length is invalid", message: "Be equal or greater than 3 characters")
            return
        }
        
        guard isDifferentFromStartWord(word: answer) else {
            wordError(title: "Word is simiar to start word", message: "Be different from start word")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        usedWords.insert(answer, at: 0)
        totalLetters += answer.count
        
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                restartGame()

                // If we are here everything has worked, so we can exit
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func restartGame() {
        usedWords.removeAll(keepingCapacity: true)
        rootWord = allWords.randomElement() ?? "silkworm"
        newWord = ""
        totalLetters = 0
    }

    func isValidLength(word: String) -> Bool {
        word.count >= 3
    }
    
    func isDifferentFromStartWord(word: String) -> Bool {
        !word.elementsEqual(rootWord)
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}
