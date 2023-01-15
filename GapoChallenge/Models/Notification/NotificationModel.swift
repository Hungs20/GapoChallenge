//
//  NotificationModel.swift
//  GapoChallenge
//
//  Created by Chu Hung on 15/01/2023.
//

import Foundation

struct NotificationResponse: Codable {

    var data: [NotificationData] = []

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

class NotificationData: Codable {

    var tracking: String?
    var id: String?
    var title: String?
    var type: String?
    var readAt: Int?
    var status: String?
    var subscription: NotificationSubscription?
    var createdAt: Int?
    var isSubscribed: Bool?
    var icon: String?
    var imageThumb: String?
    var image: String?
    var updatedAt: Int?
    var receivedAt: Int?
    var message: NotificationMessage?
    var animation: String?
    var subjectName: String?

    enum CodingKeys: String, CodingKey {
        case tracking = "tracking"
        case id = "id"
        case title = "title"
        case type = "type"
        case readAt = "readAt"
        case status = "status"
        case subscription = "subscription"
        case createdAt = "createdAt"
        case isSubscribed = "isSubscribed"
        case icon = "icon"
        case imageThumb = "imageThumb"
        case image = "image"
        case updatedAt = "updatedAt"
        case receivedAt = "receivedAt"
        case message = "message"
        case animation = "animation"
        case subjectName = "subjectName"
    }
    
    func updateReadStatus() {
        self.status = "read"
    }
}

struct NotificationSubscription: Codable {

    var targetType: String?
    var targetId: String?
    var level: Int?
    var targetName: String?

    enum CodingKeys: String, CodingKey {
        case targetType = "targetType"
        case targetId = "targetId"
        case level = "level"
        case targetName = "targetName"
    }
}

struct NotificationMessage: Codable {

    var text: String?
    var highlights: [NotificationMessageHighlights] = []

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case highlights = "highlights"
    }
}

struct NotificationMessageHighlights: Codable {

    var length: Int?
    var offset: Int?

    enum CodingKeys: String, CodingKey {
        case length = "length"
        case offset = "offset"
    }
}
