//
//  MGSettingsPanel.swift
//  MultiplicationGame
//
//  Created by Pham Anh Tuan on 10/8/22.
//

import Foundation
import SwiftUI

struct MGSettingsPanel: View {
    var panelTitle: String
    var multiplicationTableSettingTitle: String
    var multiplicationTableOptionRange: [Int]
    @Binding var selectedMultiplicationTable: Int
    @Binding var showMenuOfMultiplicationTableSelection: Bool
    
    var numberOfRoundSettingTitle: String
    var numberOfRoundOptionRange: [Int]
    @Binding var selectedNumberOfRound: Int
    @Binding var showMenuOfNumberOfRoundSelection: Bool
    
    var body: some View {
        VStack () {
            Spacer()
            VStack {

                Text(panelTitle)
                    .padding(0)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 8, x: 5, y: 5)
                
                MGPicker(
                    title: multiplicationTableSettingTitle,
                    options: multiplicationTableOptionRange,
                    selectFrameWidth: 100,
                    selectFrameHeight: 380,
                    selectFrameOffsetX: -20,
                    selectFrameOffsetY: -210,
                    selectedOption: $selectedMultiplicationTable,
                    showOptionList: $showMenuOfMultiplicationTableSelection) {
                        withAnimation() {
                            showMenuOfMultiplicationTableSelection.toggle()
                            showMenuOfNumberOfRoundSelection = false
                        }
                    }
//                            HStack {
//                                Text(multiplicationTableSettingTitle)
//                                    .font(.system(size: 18))
//                                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
//                                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
//
//                                Spacer()
//
//                                HStack {
//                                    Text("\(selectedMultiplicationTable)")
//                                        .font(.system(size: 18))
//                                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
//                                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
//                                        .frame(width: 50, height: 20, alignment: .trailing)
//
//                                    Image(systemName: "list.number")
//                                        .scaleEffect(CGSize(width: 1, height: 1))
//                                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
//                                }
//                                .gesture (
//                                    TapGesture(count: 1)
//                                        .onEnded { _ in
//                                            withAnimation() {
//                                                showMenuOfMultiplicationTableSelection.toggle()
//                                                showMenuOfNumberOfRoundSelection = false
//                                            }
//                                        }
//                                )
//                                .overlay {
//                                    if showMenuOfMultiplicationTableSelection == true {
//                                        MGSelector(
//                                            options: multiplicationTableOptionRange,
//                                            width: 100,
//                                            height: 380,
//                                            offsetX: -20,
//                                            offsetY: -210,
//                                            selectedOption: $selectedMultiplicationTable,
//                                            show: $showMenuOfMultiplicationTableSelection
//                                        )
//                                    }
//                                }
//                            }
//                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                MGPicker(
                    title: numberOfRoundSettingTitle,
                    options: numberOfRoundOptionRange,
                    selectFrameWidth: 100,
                    selectFrameHeight: 120,
                    selectFrameOffsetX: -20,
                    selectFrameOffsetY: -80,
                    selectedOption: $selectedNumberOfRound,
                    showOptionList: $showMenuOfNumberOfRoundSelection) {
                        withAnimation() {
                            showMenuOfNumberOfRoundSelection.toggle()
                            showMenuOfMultiplicationTableSelection = false
                        }
                    }
//
//                            HStack {
//                                Text("\(numberOfRoundSettingTitle)")
//                                    .font(.system(size: 18))
//                                    .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
//                                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
//
//                                Spacer()
//
//                                HStack {
//                                    Text("\(selectedNumberOfRound)")
//                                        .font(.system(size: 18))
//                                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
//                                        .shadow(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), radius: 10, x: 0, y: 1)
//                                        .frame(width: 50, height: 20, alignment: .trailing)
//
//                                    Image(systemName: "clock.arrow.circlepath")
//                                        .scaleEffect(CGSize(width: 1, height: 1))
//                                        .foregroundColor(Color(UIColor.hexStringToUIColor(hex: "ffff00")))
//                                }
//                                .gesture(
//                                    TapGesture(count: 1)
//                                        .onEnded { _ in
//                                            withAnimation() {
//                                                showMenuOfNumberOfRoundSelection.toggle()
//                                                showMenuOfMultiplicationTableSelection = false
//                                            }
//                                        }
//                                )
//                                .overlay {
//                                    if showMenuOfNumberOfRoundSelection == true {
//                                        MGSelector(
//                                            options: numberOfRoundOptionRange,
//                                            width: 100,
//                                            height: 120,
//                                            offsetX: -20,
//                                            offsetY: -80,
//                                            selectedOption: $selectedNumberOfRound,
//                                            show: $showMenuOfNumberOfRoundSelection
//                                        )
//                                    }
//                                }
//                            }
//                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
//
            }
            .frame(maxWidth: .infinity, minHeight: 130)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .fill(
                            LinearGradient(stops: [
                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0),
                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.12),
                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0.217),
                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), location: 0.218),
                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 0.31),
                                Gradient.Stop(color: Color(UIColor.hexStringToUIColor(hex: "f99d07")), location: 1)
                            ], startPoint: .top, endPoint: .bottom)
                         )
                    .shadow(color: Color(UIColor.hexStringToUIColor(hex: "ffff00")), radius: 10, x: 0, y: 1)
            )
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
            .offset(y: -10)
        }
    }
}
