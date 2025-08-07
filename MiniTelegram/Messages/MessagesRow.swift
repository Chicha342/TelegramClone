//
//  MessagesRow.swift
//  MiniTelegram
//
//  Created by Никита on 06.08.2025.
//

import SwiftUI

struct MessagesRow: View {
    let message: Message
    @ObservedObject var viewModel: MessageViewModel
    
    var body: some View {
        HStack{
            if message.sender == "me"{
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(message.text)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .contextMenu{
                            Button("Delete", role: .destructive){
                                Task{
                                    await viewModel.deleteMessage(with: message.id)
                                }
                            }
                            
                        }
                        .font(.system(size: 16, weight: .regular, design: .default))
                    
                    
                    Text(message.time)
                        .font(.caption2)
                        .foregroundStyle(.black)
                }
            }else{
                VStack(alignment: .leading, spacing: 2) {
                    Text(message.text)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(.black)
                        .cornerRadius(12)
                        .font(.system(size: 16, weight: .regular, design: .default))
                    
                    Text(message.time)
                        .font(.caption2)
                        .foregroundStyle(.black)
                    
                }
                Spacer()
            }
        }
        .padding(.horizontal, 30)
    }
}

//#Preview {
//    MessagesRow(message: Message(id: "", chatId: "", sender: "", text: "", time: ""), viewModel: <#MessageViewModel#>)
//}
