//
//  FaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceView: View {
    @State private var showFace = false
    @State private var flipDegree: Double = 0
    @State private var tappedOnDeletionIcon = false
    
    var face: Face
    var showDeleteOptionOnEachFace: Bool
    var showDeleteOptionOnEachFaceAction: (Bool) -> Void
    var showDetailAction: (Face) -> Void
    var showEditNameAction: (Face) -> Void
    var showDeleteAction: (Face) -> Void
//
//    private func longPressOnFace() -> some Gesture {
//        let minimumLongPressDuration: Double = 2
//        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
//            .onEnded { value in
//                DispatchQueue.main.async {
//                    withAnimation {
//                        flipDegree = flipDegree == 360 ? 0 : 360
//                    }
//                    
//                    showDeleteOptionOnEachFaceAction(true)
//                }
//            }
//        return longPressDrag
//    }
    
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
                print("tap on face")
                if !showDeleteOptionOnEachFace {
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
                                        print("tap on deletion icon")
                                        tappedOnDeletionIcon = true
                                    }
                            }
                        }
                        .contentShape(.contextMenuPreview, Circle())
                        .contextMenu(menuItems: {
                            Button() {
                                showEditNameAction(face)
                            } label: {
                                Label("Change Name", systemImage: "pencil")
                                    .font(.title)
                            }

                            Button(role: .destructive) {
                                showDeleteAction(face)
                            } label: {
                                Label("Delete", systemImage: "minus.circle")
                                    .font(.title)
                            }
                        })
                }
                Text(face.name)
                    .lineLimit(2)
                    .font(.caption)
            }
            .onTapGesture(count: 1, perform: {})
            //.gesture(longPressOnFace())
        }
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
    }
}
