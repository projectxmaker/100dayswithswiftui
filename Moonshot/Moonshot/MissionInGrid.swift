//
//  MissionInGrid.swift
//  Moonshot
//
//  Created by Pham Anh Tuan on 10/12/22.
//

import SwiftUI

struct MissionInGrid<T: View>: View {
    let content: () -> T
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
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

struct MissionInGrid_Previews: PreviewProvider {
    static var previews: some View {
        MissionInGrid {
            Text("Hello world")
        }
    }
}
