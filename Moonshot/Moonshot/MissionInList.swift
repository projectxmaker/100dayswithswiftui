//
//  MissionInList.swift
//  Moonshot
//
//  Created by Pham Anh Tuan on 10/12/22.
//

import SwiftUI

struct MissionInList<T: View>: View {
    let content: () -> T

    let columns = [
        GridItem(.flexible(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                content()
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct MissionInList_Previews: PreviewProvider {
    static var previews: some View {
        MissionInList {
            Text("Hello world")
        }
    }
}
