//
//  NewContactView.swift
//  MiniTelegram
//
//  Created by Никита on 07.08.2025.
//

import SwiftUI

struct NewContactView: View {
    @State var name: String = ""
    @State var avatar: String = ""
    
    @State var showAlert: Bool = false
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                .shadow(radius: 5)
                .frame(width: 300, height: 400)
                .overlay {
                    VStack(alignment: .leading){
                        Text("Name")
                            .font(.headline)
                        TextField("Enter name", text: $name)
                            .padding()
                            .background(Color.gray.opacity(0.12))
                            .cornerRadius(5)
                        
                            .padding()
                        
                        Text("Avatar")
                            .font(.headline)
                        TextField("Avatar URl", text: $avatar)
                            .padding()
                            .background(Color.gray.opacity(0.12))
                            .cornerRadius(5)
                            .padding()
                        
                        Button(action: {
                            if name.isEmpty || avatar.isEmpty {
                                showAlert = true
                                return
                            }
                            
                            name = ""
                            avatar = ""
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            let currentTime = formatter.string(from: Date())
                            
                            let contact = Chat(id: UUID().uuidString,
                                               name: name,
                                               image: avatar,
                                               lastMessage: "Hello!",
                                               timeLastMessage: currentTime
                            )
                            
                            isPresented = false
                            
                            Task{
                                await viewModel.addNewContact(contact)
                            }
                            
                            
                            
                        }) {
                            Text("Sent")
                                .padding()
                                .font(.headline)
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(5)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.leading)
                }
            
            
            
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Error"), message: Text("Please fill all fields"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    //NewContactView(viewModel: ViewModel, isPresented: <#Binding<Bool>#>)
}
