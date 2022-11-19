//
//  LogView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/19/22.
//

import SwiftUI

struct LogView: View {
    private var log: RollingLog
    
    private var results: [String]
    
    let vGridLayout: [GridItem] = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    func getValueOfDiceByIndex(_ index: Int) -> String {
        return results[index]
    }
    
    init(of log: RollingLog) {
        self.log = log
        
        self.results = log.result.components(separatedBy: ",")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(log.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.headline.bold())
                .opacity(0.8)
            
            Text("\(log.posibilities)-sided \(log.dices) dices |  Sum: \(log.sumOfResult) | Highest: \(log.highestResult) | Lowest: \(log.lowestResult)")
                .font(.subheadline)
                .opacity(0.5)
                    
            ScrollView(.vertical) {
                LazyVGrid(columns: vGridLayout, spacing: 15) {
                    ForEach(0..<log.dices, id: \.self) { index in
                        Text("\(getValueOfDiceByIndex(index))")
                            .foregroundColor(.black).bold()
                            .frame(width: 50, height: 50)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .white, radius: 2, x: 0, y: 0)
                            
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 120)
        }
        .foregroundColor(.white)
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(of: RollingLog(dices: 1, posibilities: 1, result: "1", sumOfResult: 1, highestResult: 1, lowestResult: 1))
    }
}
