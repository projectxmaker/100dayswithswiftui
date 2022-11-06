//
//  FaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceView: View {
    @ObservedObject private var viewModel = ListView.ViewModel()
    
    @State private var showFace = false
    @State private var flipDegree: Double = 0
    @State private var tappedOnDeletionIcon = false
    @State private var showDeleteAlert = false
    
    @Binding var face: Face
    @Binding var needToRefreshFaceList: Bool
    @Binding var showDeleteOption: Bool
    var showDetailAction: @MainActor (Face) -> Void
    var showEditNameAction: @MainActor (Face) -> Void
    
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
                runDeleteFaceAction()
            } else {
                if !showDeleteOption {
                    withAnimation(.easeIn(duration: 0.2)) {
                        flipDegree = flipDegree == 360 ? 0 : 360
                    }
                    showDetailAction(face)
                } else {
                    showDeleteOption = false
                }
            }
        }
    }
    
    private func runDeleteFaceAction() {
        viewModel.tappedFace = face
        showDeleteAlert.toggle()
        tappedOnDeletionIcon = false
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
                        .shadow(color: .white, radius: 10, x: 1, y: 1)
                        .rotation3DEffect(.degrees(flipDegree), axis: (x: 0, y: 1, z: 0))
                        .overlay(alignment: .topLeading) {
                            if showDeleteOption {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red.opacity(0.8))
                                    .onTapGesture {
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
                                runDeleteFaceAction()
                            } label: {
                                Label("Delete", systemImage: "minus.circle")
                                    .font(.title)
                            }
                        })
                }
                Text(face.name)
                    .lineLimit(2)
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5, x: 1, y: 1)
            }
            .onTapGesture(count: 1, perform: {})
        }
        .simultaneousGesture(tapOnFace())
        .scaleEffect(showFace ? 1 : 0)
        .animation(.easeIn(duration: 0.3), value: showFace)
        .alert("Delete", isPresented: $showDeleteAlert, actions: {
            Button(role: .cancel, action: {
            }) {
                Text("Cancel")
            }
            
            Button(role: .destructive, action: {
                showFace = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    viewModel.deleteFace { succeeded, faces in
                        needToRefreshFaceList.toggle()
                    }
                }
            }) {
                Text("Delete")
            }
        }, message: {
           Text(viewModel.deleteMessage)
        })
        .onAppear {
            showFace = true
        }
        .onDisappear {
            showFace = false
        }
        
    }
}
