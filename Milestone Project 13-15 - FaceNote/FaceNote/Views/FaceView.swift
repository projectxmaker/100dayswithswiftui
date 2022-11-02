//
//  FaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceView: View {
    enum DragState {
        case inactive
        case pressingInOneSecond
        case pressingInThreeSecond
    }
    
    @GestureState var dragState = DragState.inactive
    
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
    
    private func switchActionDialog() {
        withAnimation {
            flipDegree = flipDegree == 360 ? 0 : 360
        }
        showActionDialog.toggle()
    }

    private func longPressOnFace() -> some Gesture {
        
        let minimumLongPressDuration: Double = 3
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: LongPressGesture(minimumDuration: 1))
            .updating($dragState, body: { value, state, transaction in
                switch value {
                case .first(true):
                    state = .pressingInOneSecond
                case .second(true, nil):
                    state = .pressingInThreeSecond
                default:
                    state = .inactive
                }
            })
        return longPressDrag
    }
    
    private func runActionForLongPressOnFace(newValue: DragState) {
        if newValue == .pressingInOneSecond {
            // show Action Dialog
            switchActionDialog()
            
        } else if newValue == .pressingInThreeSecond {
            // close Action Dialog
            switchActionDialog()
            
            showDeleteOptionOnEachFaceAction(true)
        }
    }
    
    private func tapOnFace() -> some Gesture {
        let onTap = TapGesture()
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
                        }
                    }
            }
            Text(face.name)
                .lineLimit(2)
                .font(.caption)
        }
        .onTapGesture {  }
        .gesture(longPressOnFace())
        .onChange(of: dragState, perform: runActionForLongPressOnFace)
        .simultaneousGesture(tapOnFace())
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
