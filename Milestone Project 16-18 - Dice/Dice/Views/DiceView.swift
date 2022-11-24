//
//  DiceView.swift
//  Dice
//
//  Created by Pham Anh Tuan on 11/15/22.
//

import SwiftUI

struct DiceView: View {
    @ObservedObject var dice: Dice
    @EnvironmentObject private var diceListVM: DiceListViewModel
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    var rollingLogManager = RollingLogManager.shared
    var valueColor = Color.black
    var valueColorWhenDiceIsRolling = Color.black
    var backgroundColor = Color.white
    var shadowColor = Color.white
    var shadowColorIfPressingSwitcher = Color.white
    var shadowColorWhenDiceIsRolling = Color.black
    var width: CGFloat = 80
    var height: CGFloat = 80
    var arrowLeftColor = Color.gray
    var arrowLeftColorWhenDiceIsRolling = Color.black.opacity(0.5)
    var arrowRightColor = Color.gray
    var arrowRightColorWhenDiceIsRolling = Color.black.opacity(0.5)
    var switcherForgroundColorEnabled = Color.black
    var switcherForgroundColorDisabled = Color.gray
    
    @State private var isShowingValue = true // just for animation
    @State private var diceRollTimer: Timer?
    @State private var isSwitcherDisabled = false
    
    @State private var longPressTimer: Timer?
    @State private var longPressCounter: Double = DiceView.longPressMinimumDuration
    static let longPressMinimumDuration: Double = 1
    let longPressTimerTimeInterval: Double = 0.5
    
    @State private var isPressingSwitcher = false
    @State private var makeVisibleValueSmaller = false
    
    @State private var changeDiceAppearance = false
    
    var isShowingArrowIndicator: Bool {
        return makeVisibleValueSmaller
    }

    private func moveToNextValue(isShowingValue: Bool, loopAnimationDuration: Double) {
        withAnimation(.easeInOut(duration: loopAnimationDuration)) {
            // for animation and synchronize w/ similar value in each Dice
            self.isShowingValue = isShowingValue
        }
    }

    private func rollDice(fastRollingInSeconds: Double? = nil, postAction: @escaping (UUID, Int) -> Void) {
        if !isSwitcherDisabled {
            withAnimation {
                isSwitcherDisabled = true
            }

            dice.roll(fastRollingInSeconds: fastRollingInSeconds, actionInEveryLoop: moveToNextValue) { id, visibleValue in
                withAnimation {
                    isSwitcherDisabled = false
                    makeVisibleValueSmaller.toggle()
                    
                    // do postAction
                    postAction(id, visibleValue)
                }
            }
        }
    }
    
    func preActionOfSingleTapOnSwitcher() {
        if !isSwitcherDisabled {
            withAnimation {
                isPressingSwitcher.toggle()
                makeVisibleValueSmaller.toggle()
            }

            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                withAnimation {
                    isPressingSwitcher.toggle()
                    isSwitcherDisabled = true
                }
            }
        }
    }
    
    func postActionOfSingleTapOnSwitcher() {
        if isSwitcherDisabled {
            withAnimation {
                isSwitcherDisabled = false
                makeVisibleValueSmaller.toggle()
            }
        }
    }
    
    var singleTapOnSwitcher: some Gesture {
        TapGesture()
            .onEnded { _ in
                let newId = self.rollingLogManager.generateNewGroup(
                    numberOfDices: 1,
                    numberOfPossibilities: diceListVM.numberOfPossibilities
                )
                
                dice.runSingleTapOnDice(groupId: newId)
            }
    }
    
    private func startLongPressingOnSwitcher() {
        if !isSwitcherDisabled {
            // effect of pressing on switcher
            withAnimation {
                isPressingSwitcher.toggle()
                makeVisibleValueSmaller.toggle()
            }
        }
    }
    
    private func stopLongPressingOnSwitcher() {
        if !isSwitcherDisabled {
            // effect of pressing on switcher
            withAnimation {
                isPressingSwitcher.toggle()
                isSwitcherDisabled.toggle()
            }
        }
    }
    
    var longPressOnSwitcher: some Gesture {
        LongPressGesture(minimumDuration: DiceView.longPressMinimumDuration)
            .sequenced(before: DragGesture(minimumDistance: 0))
            .onChanged({ value in
                if value == .first(true) {
                    dice.startLongPressOnSwitcher()
                }
            })
            .onEnded({ value in
                let newId = self.rollingLogManager.generateNewGroup(
                    numberOfDices: 1,
                    numberOfPossibilities: diceListVM.numberOfPossibilities
                )
                
                dice.stopLongPressOnSwitcher(groupId: newId)
            })
    }

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                if isShowingArrowIndicator {
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(isShowingArrowIndicator ? .subheadline : .largeTitle)
                        .foregroundColor(isShowingArrowIndicator ? arrowLeftColorWhenDiceIsRolling : arrowLeftColor)
                        .transition(.move(edge: .leading))
                }

                if isShowingValue {
                    Text("\(dice.visibleValue)")
                        .font(makeVisibleValueSmaller ? .title2.bold() :  .largeTitle.bold() )
                        .foregroundColor(makeVisibleValueSmaller ? valueColorWhenDiceIsRolling : valueColor)
                        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .move(edge: .bottom).combined(with: .opacity)))
                }

                if isShowingArrowIndicator {
                    Image(systemName: "arrowtriangle.left.fill")
                        .font(isShowingArrowIndicator ? .subheadline : .largeTitle)
                        .foregroundColor(isShowingArrowIndicator ? arrowRightColorWhenDiceIsRolling : arrowRightColor)
                        .transition(.move(edge: .trailing))
                }
            }
            .frame(width: width, height: height)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: isPressingSwitcher ? shadowColorIfPressingSwitcher : (isSwitcherDisabled ? shadowColorWhenDiceIsRolling : shadowColor), radius: isPressingSwitcher ? 25 : 10, x: 1, y: 1)
            .gesture(voiceOverEnabled ? singleTapOnSwitcher : nil)
            .gesture(voiceOverEnabled ? longPressOnSwitcher : nil)
            .accessibilityElement()
            .accessibilityLabel("Dice at position \(dice.orderNumber) is  \(dice.isSwitcherDisabled ? "rolling" : "\(dice.visibleValue)")")
            .accessibilityHint(dice.isSwitcherDisabled ? "" : "Tap to roll the Dice at position \(dice.orderNumber)")
            
            if !voiceOverEnabled {
                Image(systemName: "square.dashed.inset.filled")
                    .font(.largeTitle)
                    .foregroundColor(isSwitcherDisabled ? switcherForgroundColorDisabled :  switcherForgroundColorEnabled)
                    .scaleEffect(isPressingSwitcher ? 0.8 : 1)
                    .gesture(singleTapOnSwitcher)
                    .gesture(longPressOnSwitcher)
            }

        }
        .onAppear {
            self.isSwitcherDisabled = dice.isSwitcherDisabled
            self.isPressingSwitcher = dice.isPressingSwitcher
            self.makeVisibleValueSmaller = dice.makeVisibleValueSmaller
        }
        .onChange(of: dice.isShowingValue) { newValue in
            moveToNextValue(isShowingValue: newValue, loopAnimationDuration: dice.currentAnimationDurationOfShowingValue)
        }
        .onChange(of: dice.runPreActionForSingleTapOnSwitcher) { newValue in
            preActionOfSingleTapOnSwitcher()
        }
        .onChange(of: dice.runWhileRollingForSingleTapSwitcher, perform: { newValue in
            moveToNextValue(isShowingValue: dice.isShowingValue, loopAnimationDuration: dice.currentAnimationDurationOfShowingValue)
        })
        .onChange(of: dice.runPostActionForSingleTapOnSwitcher) { newValue in
            postActionOfSingleTapOnSwitcher()
        }
        .onChange(of: dice.doingLongPressingOnSwitcher) { newValue in
            if newValue {
                // start pressing on switcher
                startLongPressingOnSwitcher()
            } else {
                // stop pressing on switcher
                stopLongPressingOnSwitcher()
            }
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(
            dice: Dice.sample
        )
    }
}
