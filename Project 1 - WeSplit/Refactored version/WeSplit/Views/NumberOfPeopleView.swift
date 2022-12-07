//
//  NumberOfPeopleView.swift
//  WeSplit
//
//  Created by Pham Anh Tuan on 12/7/22.
//

import SwiftUI

struct NumberOfPeopleView: View {
    @Binding var numberOfPeople: Int
    
    var body: some View {
        Picker("Number of people", selection: $numberOfPeople) {
            ForEach(2..<100, id:\.self) { element in
                Text("\(element) people")
            }
        }
    }
}

struct NumberOfPeopleView_Previews: PreviewProvider {
    struct SampleView: View {
        @State var numberOfPeople: Int = 2
        
        var body: some View {
            NumberOfPeopleView(numberOfPeople: $numberOfPeople)
        }
    }
    
    static var previews: some View {
        SampleView()
    }
}
