//
//  ViewModel.swift
//  MiniTelegram
//
//  Created by Никита on 03.08.2025.
//

import Foundation

class ViewModel: ObservableObject {
    let urlString = "https://688f6908f21ab1769f89196d.mockapi.io/tel/chats"
    @Published var chats: [Chat] = []
    
    func fetchChats() async {
        guard let url = URL(string: urlString) else { return }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Chat].self, from: data)
            
            DispatchQueue.main.async {
                self.chats = decoded
            }
            
        }catch{
            print("error fetching data")
        }
        
    }
    
    func addNewContact(_ chat: Chat) async {
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let body = try JSONEncoder().encode(chat)
            let(_, response) = try await URLSession.shared.upload(for: request, from: body)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201{
                await fetchChats()
            }
        }catch{
            print("Add contact error \(error.localizedDescription)")
        }
    }
    
    func deleteContact(withId id: String) async {
        guard let url = URL(string: "\(urlString)/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do{
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200{
                DispatchQueue.main.async {
                    self.chats.removeAll { $0.id == id }
                }
            }else{
                print("Delete failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
        }catch{
            print("Error deleting contact \(error.localizedDescription)")
        }
    }
}

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    let urlString = "https://688f6908f21ab1769f89196d.mockapi.io/tel/Message"
    
    func fetchMessages(for chatId: String) async {
        guard let url = URL(string: urlString) else { return }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Message].self, from: data)
            
            DispatchQueue.main.async {
                self.messages = decoded.filter { $0.chatId == chatId }
            }
        }
        catch{
            print("error \(error.localizedDescription)")
        }
    }
    
    func addMessage(_ message: Message) async {
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let body = try JSONEncoder().encode(message)
            let(_, response) = try await URLSession.shared.upload(for: request, from: body)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201{
                await fetchMessages(for: message.chatId)
            }
            
            
        }catch{
            print("Add error: \(error.localizedDescription)")
        }
        
    }
    
    func deleteMessage(with id: String) async {
        guard let url = URL(string: "\(urlString)/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do{
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200{
                DispatchQueue.main.async {
                    self.messages.removeAll { $0.id == id }
                }
            }else{
                print("Delete failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
            
        }catch{
            print("delete error: \(error.localizedDescription)")
        }
        
    }
    
}

