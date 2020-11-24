//
//  StreamResponse.swift
//  Feedly Notifier
//
//  Created by Madhur Ahuja on 21 November 2020.
//  Copyright © 2020 Madhur Ahuja. All rights reserved.
//

import Foundation

struct StreamResponse: Codable {
    let continuation: String?
    let id: String
    let updated: Int?
    let items: [Item]
}

struct Item : Codable {
    let id: String
    let author: String?
    let categories: [Category]
    let crawled: Int
    let published: Int
    let updated: Int?
    let unread: Bool
    let title: String?
    let engagement: Int?
    let engagementRate: Int?
    let visual: Visual?
    let ampUrl: String?
    let cdnAmpUrl: String?
    let canonicalUrl: String?
    let webfeeds: WebFeed?
    let summary: Summary?
    let alternate: [Alternate]?
    let origin: Origin?
}

struct Origin: Codable {
    let htmlUrl: String
    let streamId: String
    let title: String
}

struct Alternate: Codable {
    let href: String
    let type: String
}
struct Category: Codable {
    let id: String
    let label: String
}

struct Summary: Codable {
    let content: String
    let direction: String
}

struct WebFeed: Codable {
    let logo: String
}
struct Visual: Codable {
    let contentType: String?
    let height: Int?
    let url: String?
    let width: Int?
}
