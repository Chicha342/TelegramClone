//
//  Model.swift
//  MiniTelegram
//
//  Created by Никита on 03.08.2025.
//

import SwiftUI

struct Chat: Identifiable, Codable {
    let id: String
    let name: String
    let image: String
    var lastMessage: String?
    var timeLastMessage: String?
}

struct Message: Identifiable, Codable {
    let id: String
    let chatId: String
    let sender: String
    let text: String
    let time: String
}
