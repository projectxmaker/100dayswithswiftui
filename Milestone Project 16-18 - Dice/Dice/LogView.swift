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
            
            HStack(alignment: .center) {
                Text("\(log.sumOfResult)")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: 60)
                
                Text("=")
                    .frame(maxWidth: 10)
                
                ScrollView(.vertical) {
                    LazyVGrid(columns: vGridLayout, spacing: 15) {
                        ForEach(0..<log.dices, id: \.self) { index in
                            Text("\(getValueOfDiceByIndex(index))")
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(color: .white, radius: 5, x: 1, y: 1)
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .frame(maxWidth: .infinity, maxHeight: 120)
            }

            Text("\(log.dices) dices | \(log.posibilities) posibilities per dice")
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(of: RollingLog(dices: 1, posibilities: 1, result: "1", sumOfResult: 1))
    }
}
