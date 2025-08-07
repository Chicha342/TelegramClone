//
//  Messages.swift
//  MiniTelegram
//
//  Created by Никита on 03.08.2025.
//

import SwiftUI

struct MessagesView: View {
    var chat : Chat
    @StateObject private var messageViewModel = MessageViewModel()
    @State private var newMessageText: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var keyboardHeight: CGFloat = 0
    
    
    
    var body: some View {
        ZStack{
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)
            
            ScrollViewReader{ proxy in
                
                ScrollView{
                    ForEach(messageViewModel.messages){ message in
                        MessagesRow(message: message, viewModel: messageViewModel)
                            .id(message.id)
                    }
                    .padding(.top)
                    
                }
                .padding(.bottom, 44)
                .onChange(of: messageViewModel.messages.count) { _ in
                    if let lastId = messageViewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            VStack{
                Spacer()
                
                HStack{
                    TextField("Message...", text: $newMessageText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .zIndex(1)
                        .frame(height: 100)
                        .shadow(radius: 5)
                    
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .onTapGesture {
                            let message = Message(id: UUID().uuidString,
                                                  chatId: chat.id,
                                                  sender: "me",
                                                  text: newMessageText,
                                                  time: DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short))
                            
                            Task{
                                await messageViewModel.addMessage(message)
                            }
                            
                            withAnimation {
                                newMessageText = ""
                            }
                        }
                    
                    
                }
                .padding(.horizontal, 30)
                .padding(.bottom, keyboardHeight)
                
            }
            .ignoresSafeArea()
            
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(chat.name)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        
        .toolbar{
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.blue)
                        Text("Назад")
                            .foregroundStyle(.blue)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                
                AsyncImage(url: URL(string: chat.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                } placeholder: {
                    ZStack{
                        ProgressView()
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                    }
                }
                
                
            }
        }
        
        
        .task {
            await messageViewModel.fetchMessages(for: chat.id)
        }
        
        //MARK: - OMG
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                withAnimation {
                    keyboardHeight = 0
                }
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
        //MARK: - OMG
        
    }
    
    
    
}

//#Preview {
//    MessagesView(chat: Chat(id: "1", name: "2Pac", image: "https://slukh.media/wp-content/uploads/2023/10/2pac-site-min.jpg", lastMessage: "Thug Life!!52", timeLastMessage: "20:31"))
//}
