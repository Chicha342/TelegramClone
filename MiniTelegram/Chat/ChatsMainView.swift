//
//  ChatsMainView.swift
//  MiniTelegram
//
//  Created by Никита on 03.08.2025.
//

import SwiftUI

struct ChatsMainView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    @State private var showAddContact = false
    
    var body: some View {
        ZStack{
            if showAddContact{
                NewContactView(viewModel: viewModel, isPresented: $showAddContact)
                    .zIndex(2)
                withAnimation(.default){
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.black.opacity(0.4))
                        .ignoresSafeArea(edges: .all)
                        .zIndex(1)
                }
            }
            
            NavigationStack{
                ScrollView{
                    LazyVStack{
                        ForEach(viewModel.chats) { chat in
                            NavigationLink(destination: MessagesView(chat: chat)) {
                                ChatRow(chat: chat)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contextMenu{
                                Button("Delete", role: .destructive){
                                    Task{
                                        await viewModel.deleteContact(withId: chat.id)
                                    }
                                }
                                
                            }
                        }
                    }
                }
                .navigationTitle("Чаты")
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showAddContact.toggle()
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
            }
        }
        .task {
            await viewModel.fetchChats()
        }
            
    }
}

#Preview {
    ChatsMainView()
}
