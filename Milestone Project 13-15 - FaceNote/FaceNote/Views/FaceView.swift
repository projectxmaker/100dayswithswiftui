//
//  FaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceView: View {
    enum LongPressActionType {
        case nothing, showActionDialog, showDeletionOption
    }
    
    @GestureState var longPressState = false
    @State private var longPressType = LongPressActionType.nothing
    @State private var showFace = false
    @State private var flipDegree: Double = 0
    @State private var showActionDialog = false
    @State private var tappedOnDeletionIcon = false
    
    var face: Face
    var showDeleteOptionOnEachFace: Bool
    var showDeleteOptionOnEachFaceAction: (Bool) -> Void
    var showDetailAction: (Face) -> Void
    var showEditNameAction: (Face) -> Void
    var showDeleteAction: (Face) -> Void
    var longPressOnFaceAction: (Bool) -> Void
    
    private func switchActionDialog() {
        withAnimation {
            flipDegree = flipDegree == 360 ? 0 : 360
        }
        showActionDialog.toggle()
    }

    private func longPressOnFace() -> some Gesture {
        let minimumLongPressDuration: Double = 1
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: LongPressGesture(minimumDuration: 1))
            .updating($longPressState, body: { value, state, transaction in
                print("\(value) --- \(state)")
                
                switch value {
                case .first(true):
                    print("start")
                case .second(true, let done) where done == nil:
                    DispatchQueue.main.async {
                        longPressType = .showActionDialog
                    }
                default:
                    print("default")
                }
            })
            .onEnded { value in
                DispatchQueue.main.async {
                    longPressType = .showDeletionOption
                }
                
            }
        return longPressDrag
    }
    
    private func runActionForLongPressOnFace(newValue: LongPressActionType) {
        print("long press on face UPDATED ")
        switch newValue {
        case .showActionDialog:
            print("here 1")
            longPressOnFaceAction(true)

            // show Action Dialog
            switchActionDialog()
        case .showDeletionOption:
            print("here 2")
            longPressOnFaceAction(true)

            // close Action Dialog
            switchActionDialog()

            showDeleteOptionOnEachFaceAction(true)
        case .nothing:
            print("here 3")
            longPressOnFaceAction(false)
        }
    }
    
    private func tapOnFace() -> some Gesture {
        let onTap = TapGesture(count: 1)
            .onEnded({ ended in
                runActionForTapOnFace()
            })

        return onTap
    }
    
    private func runActionForTapOnFace() {
        let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
            if tappedOnDeletionIcon {
                print("tap on deletion icon")
                showDeleteAction(face)
                tappedOnDeletionIcon = false
            } else {
                print("tap on scroller")
                if showDeleteOptionOnEachFace {
                    showDeleteOptionOnEachFaceAction(false)
                } else {
                    withAnimation {
                        flipDegree = flipDegree == 360 ? 0 : 360
                    }

                    showDetailAction(face)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                if let loadedUIImage = UIImage.getUIImage(url: FileManager.default.getFileURL(fileName: face.thumbnail)) {
                    Image(uiImage: loadedUIImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 10, x: 1, y: 1)
                        .rotation3DEffect(.degrees(flipDegree), axis: (x: 0, y: 1, z: 0))
                        .overlay(alignment: .topLeading) {
                            if showDeleteOptionOnEachFace {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red.opacity(0.8))
                                    .onTapGesture {
                                        tappedOnDeletionIcon = true
                                    }
                                    .onChange(of: showDeleteOptionOnEachFace) { newValue in
                                        if !showDeleteOptionOnEachFace {
                                            tappedOnDeletionIcon = false
                                        }
                                    }
                            }
                        }
                }
                Text(face.name)
                    .lineLimit(2)
                    .font(.caption)
            }
            .onTapGesture(count: 2, perform: {})
            //.gesture(longPressOnFace())
            .highPriorityGesture(longPressOnFace())
        }
        .simultaneousGesture(tapOnFace())
        .onChange(of: longPressType, perform: runActionForLongPressOnFace)
        .scaleEffect(showFace ? 1 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.7)) {
                showFace.toggle()
            }
        }
        .onDisappear {
            showFace = false
        }
        .confirmationDialog("\(face.name)".uppercased(), isPresented: $showActionDialog) {
            Button("Change Name") {
                showEditNameAction(face)
            }
            
            Button("Delete", role: .destructive) {
                showDeleteAction(face)
            }
            
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text(String("\(face.name)").uppercased())
        }
    }
}
