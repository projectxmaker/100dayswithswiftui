//
//  FaceView.swift
//  FaceNote
//
//  Created by Pham Anh Tuan on 10/31/22.
//

import SwiftUI

struct FaceView: View {
    @EnvironmentObject var faceList: FaceList
    
    @State private var showFace = false
    @State private var flipDegree: Double = 0
    @State private var tappedOnDeletionIcon = false
    @State private var showDeleteAlert = false
    
    @Binding var face: Face
    
    private func runActionForTapOnFace() {
        if tappedOnDeletionIcon {
            runDeleteFaceAction()
        } else {
            if !faceList.showDeleteOption {
                withAnimation(.easeIn(duration: 0.2)) {
                    flipDegree = flipDegree == 360 ? 0 : 360
                }
                faceList.showFaceDetail(face: face)
            } else {
                faceList.showDeleteOption = false
            }
        }
    }
    
    private func runDeleteFaceAction() {
        faceList.tappedFace = face
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
                            if faceList.showDeleteOption {
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
                                faceList.showEditNameView(face: face)
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
        .simultaneousGesture(
            TapGesture()
                .onEnded({ _ in
                    runActionForTapOnFace()
                })
        )
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
                    faceList.deleteFace { succeeded, faces in
                        faceList.refreshFaceList()
                    }
                }
            }) {
                Text("Delete")
            }
        }, message: {
           Text(faceList.deleteMessage)
        })
        .onAppear {
            showFace = true
        }
        .onDisappear {
            showFace = false
        }
        
    }
}
