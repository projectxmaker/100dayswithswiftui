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
//    @State var dice = Dice()
    
    var rollingLogManager = RollingLogManager.shared
    
    @Binding var triggerSingleTapOnSwitcher: Bool
    @Binding var triggerLongPressOnSwitcher: Bool
    var notifyOfGettingFinalResult: (UUID, Int) -> Void
    
//    @State private var visibleValue: Int = 1
    
    @State private var sideValues = [Int]()
    
//    var id = UUID()
    var id: UUID {
        dice.id
    }
    
    var numberOfSides: Int = 4
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
    
    @State private var isShowingValue = true
    @State private var diceRollTimer: Timer?
    @State private var isSwitcherDisabled = false
    
    @State private var longPressTimer: Timer?
    @State private var longPressCounter: Double = DiceView.longPressMinimumDuration
    static let longPressMinimumDuration: Double = 1
    let longPressTimerTimeInterval: Double = 0.5
    
//    let rollingFastest = 0.08
//    let rollingSlowest = 1.34
//    let rollingTimerDelay = 0.045
//    let rollingStepChangeRate = 0.15
//    let fastRollingStep = 0.5
    @State private var isPressingSwitcher = false
    @State private var makeVisibleValueSmaller = false
    
    @State private var changeDiceAppearance = false
    
    var isShowingArrowIndicator: Bool {
        return makeVisibleValueSmaller
    }

//    private func moveToNextSideValue() {
//        dice.moveToNextSideValue { newIsShowingSideValue, newVisibleValue in
//            print("\(newIsShowingSideValue) ... \(newVisibleValue)")
//            print("\(dice.showingSideValue) ... \(dice.currenVisibleValue)")
//
//            changeDiceAppearance.toggle()
//            self.isShowingSideValue = newIsShowingSideValue
//            self.visibleValue = newVisibleValue

//            withAnimation(.easeIn(duration: 0.3)) {
//                self.isShowingSideValue = newIsShowingSideValue
//                self.visibleValue = newVisibleValue
//            }

//            print("\(self.isShowingSideValue) ... \(self.visibleValue)")
//        }
//    }
    private func moveToNextValue(isShowingValue: Bool, loopAnimationDuration: Double) {
//        print("run moveToNextSideValue: \(isShowingSideValue) - \(dice.visibleValue)")
        withAnimation(.easeInOut(duration: loopAnimationDuration)) {
            if isShowingValue {
                self.isShowingValue.toggle()
            } else {
                dice.increaseValue()
                self.isShowingValue.toggle()
            }
        }
//        print("run moveToNextSideValue: \(isShowingSideValue) - \(dice.visibleValue)")
    }
//    private func moveToNextSideValue() {
//        print("run moveToNextSideValue: \(isShowingSideValue) - \(dice.visibleValue)")
//        if isShowingSideValue {
//            isShowingSideValue.toggle()
//        } else {
//            dice.increaseSideValue()
//            isShowingSideValue.toggle()
//        }
//        print("run moveToNextSideValue: \(isShowingSideValue) - \(dice.visibleValue)")
//    }
//
//    private func increaseSideValue() {
//        if visibleValue < numberOfSides {
//            visibleValue += 1
//        } else {
//            visibleValue = 1
//        }
//    }
    
//    private func generateLoops(fastRollingInSeconds: Double? = nil) -> [RollingTime] {
//        var rollingLoops = [RollingTime]()
//
//        var loopCounter: Int = 0
//        
//        var timerInterval: Double = 0
//        var animationDuration: Double = rollingSlowest
//        
//        while animationDuration >= rollingFastest {
//            animationDuration -= loopCounter == 0 ? 0 :  animationDuration * rollingStepChangeRate
//            animationDuration = round(animationDuration * 100)/100.0
//            
//            let rollingLoop = RollingTime(timerInterval: timerInterval, animationDuration: animationDuration)
//            rollingLoops.append(rollingLoop)
//            
//            timerInterval += animationDuration + rollingTimerDelay
//            timerInterval = round(timerInterval * 100)/100.0
//            
//            loopCounter += 1
//        }
//        
//        var fastRollingCount: Double = 0
//        var fastRollingLimit = fastRollingStep
//        
//        if let fastRollingInSeconds = fastRollingInSeconds {
//            fastRollingLimit = fastRollingInSeconds
//        }
//        
//        while fastRollingCount <= fastRollingLimit {
//            // random loop before being reversed
//            for _ in 0..<Int.random(in: 0...10) {
//                let rollingLoop = RollingTime(timerInterval: timerInterval, animationDuration: animationDuration)
//                rollingLoops.append(rollingLoop)
//                
//                timerInterval += animationDuration + rollingTimerDelay
//                timerInterval = round(timerInterval * 100)/100.0
//            }
//            
//            fastRollingCount += fastRollingStep
//        }
//        
//        let reversedLoops = rollingLoops.reversed()
//        
//        // reverse
//        for eachRolling in reversedLoops {
//            let rollingLoop = RollingTime(timerInterval: timerInterval, animationDuration: eachRolling.animationDuration)
//            rollingLoops.append(rollingLoop)
//            
//            timerInterval += eachRolling.animationDuration + rollingTimerDelay
//            timerInterval = round(timerInterval * 100)/100.0
//        }
//
//        return rollingLoops
//    }
//    
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
//            // create loops
//            let runLoops = dice.generateLoops(fastRollingInSeconds: fastRollingInSeconds)
//
//            var lastInterval: Double = 0
//            for eachLoop in runLoops {
//                lastInterval = eachLoop.timerInterval + eachLoop.animationDuration
//
//                Timer.scheduledTimer(withTimeInterval: eachLoop.timerInterval, repeats: false) { timer in
//                    print("go")
//                    withAnimation(.easeInOut(duration: eachLoop.animationDuration)) {
//                        moveToNextSideValue()
//                    }
//                }
//            }
//
//            // re-enable Switcher
//            Timer.scheduledTimer(withTimeInterval: lastInterval, repeats: false) { timer in
//                withAnimation {
//                    isSwitcherDisabled = false
//
//                    // do postAction
//                    postAction()
//                }
//            }
        }
    }
    
    private func saveLog() {
        let parsedVisibleValue = Int(dice.visibleValue)
        
        let rollingLog = RollingLog(
            dices: 1,
            posibilities: sideValues.count,
            result: String(parsedVisibleValue),
            sumOfResult: parsedVisibleValue,
            highestResult: parsedVisibleValue,
            lowestResult: parsedVisibleValue
        )
        
        rollingLogManager.insertLog(rollingLog)
    }
    
    // postAction: input Int is the final result value visible on Dice after it finished rolling
//    private func invokeSingleTapOnSwitchForOnEnded(postAction: ((UUID, Int) -> Void)? = nil) {
    func invokeSingleTapOnSwitchForOnEnded(postAction: ((UUID, Int) -> Void)? = nil) {
        if !isSwitcherDisabled {
            
            withAnimation {
                isPressingSwitcher.toggle()
                makeVisibleValueSmaller.toggle()
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                withAnimation {
                    isPressingSwitcher.toggle()
                }
                
                rollDice { id, visibleValue in
                    if let postAction = postAction {
                        postAction(id, visibleValue)
                    }
                }
            }
        }
    }
    
    var singleTapOnSwitcher: some Gesture {
        TapGesture()
            .onEnded { _ in
                invokeSingleTapOnSwitchForOnEnded { _, _ in
                    saveLog()
                }
            }
    }
    
    private func invokeLongPressOnSwitcherForOnChangeEvent() {
        if !isSwitcherDisabled {
            // effect of pressing on switcher
            withAnimation {
                isPressingSwitcher.toggle()
                makeVisibleValueSmaller.toggle()
            }
            
            // start long press timer
            // reset counter
            longPressCounter = DiceView.longPressMinimumDuration
            
            // start timer to track how long the user presses on this button
            longPressTimer = Timer.scheduledTimer(withTimeInterval: longPressTimerTimeInterval, repeats: true, block: { timer in
                longPressCounter += longPressTimerTimeInterval
            })
        }
    }
    
    // postAction: input Int is the final result value visible on Dice after it finished rolling
    private func invokeLongPressOnSwitcherForOnEndedEvent(postAction: ((UUID, Int) -> Void)? = nil) {
        if !isSwitcherDisabled {
            // effect of pressing on switcher
            withAnimation {
                isPressingSwitcher.toggle()
            }
            
            // end timer to get how long the user presses on this button
            longPressTimer?.invalidate()
            
            rollDice(fastRollingInSeconds: longPressCounter) { id, visibleValue in
                if let postAction = postAction {
                    postAction(id, visibleValue)
                }
            }
        }
    }
    
    var longPressOnSwitcher: some Gesture {
        LongPressGesture(minimumDuration: DiceView.longPressMinimumDuration)
            .sequenced(before: DragGesture(minimumDistance: 0))
            .onChanged({ value in
                if value == .first(true) {
                    invokeLongPressOnSwitcherForOnChangeEvent()
                }
            })
            .onEnded({ value in
                invokeLongPressOnSwitcherForOnEndedEvent { _, _ in
                    saveLog()
                }
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
//                if dice.showingSideValue {
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
            
            Image(systemName: "square.dashed.inset.filled")
                .font(.largeTitle)
                .foregroundColor(isSwitcherDisabled ? switcherForgroundColorDisabled :  switcherForgroundColorEnabled)
                .scaleEffect(isPressingSwitcher ? 0.8 : 1)
                .gesture(singleTapOnSwitcher)
                .gesture(longPressOnSwitcher)
        }
        .task {
            sideValues = Array(1...numberOfSides)
            
        }
        .onChange(of: triggerSingleTapOnSwitcher) { newValue in
            invokeSingleTapOnSwitchForOnEnded{id, finalResult in
                notifyOfGettingFinalResult(id, finalResult)
            }
        }
        .onChange(of: triggerLongPressOnSwitcher) { newValue in
            if triggerLongPressOnSwitcher == true {
                invokeLongPressOnSwitcherForOnChangeEvent()
            } else {
                invokeLongPressOnSwitcherForOnEndedEvent{id, finalResult in
                    notifyOfGettingFinalResult(id, finalResult)
                }
            }
        }
//        .onChange(of: changeDiceAppearance) { newValue in
//            isShowingSideValue = dice.showingSideValue
//            visibleValue = dice.currenVisibleValue
//            
//            print("LALALA \(self.isShowingSideValue) ... \(self.visibleValue)")
//        }
//        .onAppear {
//            isShowingSideValue = diceListVM.showingSideValue
//            visibleValue = diceListVM.currenVisibleValue
//        }
//        .onChange(of: diceListVM.showingSideValue) { newValue in
//            print("showing side value: \(diceListVM.showingSideValue) - \(diceListVM.currenVisibleValue)")
//            isShowingSideValue = newValue
//        }
//        .onChange(of: diceListVM.currenVisibleValue) { newValue in
//            print("change visibleValue: \(diceListVM.showingSideValue) - \(diceListVM.currenVisibleValue)")
//            visibleValue = newValue
//        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(
            dice: Dice.sample,
            triggerSingleTapOnSwitcher: .constant(true),
            triggerLongPressOnSwitcher: .constant(true),
            notifyOfGettingFinalResult: { id, result in
                //
            })
    }
}
