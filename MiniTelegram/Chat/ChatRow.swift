//
//  ChatRow.swift
//  MiniTelegram
//
//  Created by Никита on 03.08.2025.
//

import SwiftUI

struct ChatRow: View {
    let chat: Chat
     
    var body: some View {
        VStack(){
            HStack(alignment: .top){
                AsyncImage(url: URL(string: chat.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                } placeholder: {
                    ZStack{
                        ProgressView()
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 50)
                    }
                }
                .padding(.leading)

                
                VStack(alignment: .leading){
                    
                    Text(chat.name)
                        .font(.system(size: 17, weight: .medium, design: .default))
                    
                    if let lastMessage = chat.lastMessage{
                        Text(lastMessage)
                            .foregroundStyle(.secondary)
                        
                    }else{
                        Text("Nodata")
                    }
                }
                
                Spacer()
                
                Text((chat.timeLastMessage!))
                    .padding(.trailing)
                
                
            }
            Divider()
                .padding(.leading, 80)
        }
    }
}

#Preview {
    ChatRow(chat: Chat(id: "1", name: "2Pac", image: "https://slukh.media/wp-content/uploads/2023/10/2pac-site-min.jpg", lastMessage: "Thug Life!!52", timeLastMessage: "20:31"))
}
