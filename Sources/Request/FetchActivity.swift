//
//  FetchActivity.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/21.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public struct GetActivity<Activity: ActivityDecodable, Playlist: PlaylistDecodable, Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Activity, Relationships>

    public var path: String { return "/v1/catalog/\(storefront)/activities/\(id)" }
    public let parameters: Any?

    private let storefront: Storefront.Identifier
    private let id: Activity.Identifier

    public init(storefront: Storefront.Identifier, id: Activity.Identifier, language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.storefront = storefront
        self.id = id
        self.parameters = ["l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}

extension GetActivity {
    public struct Relationships: Decodable {
        public let playlists: Page<GetPlaylists>?
    }
}

extension GetActivity {
    public func playlists(limit: Int? = nil, offset: Int? = nil) -> GetPlaylists {
        return .init(storefront: storefront, id: id, limit: limit, offset: offset)
    }
}

extension GetActivity {
    public struct GetPlaylists: PaginatorRequest {
        public typealias Resource = AppleMusicKit.Resource<Playlist, NoRelationships>

        public let path: String
        public var parameters: Any? { return makePaginatorParameters(_parameters, request: self) }

        public var limit: Int?
        public var offset: Int?
        private let _parameters: [String: Any]

        init(storefront: Storefront.Identifier, id: Activity.Identifier, limit: Int? = nil, offset: Int? = nil) {
            self.init(path: "/v1/catalog/\(storefront)/activities/\(id)/playlists",
                parameters: ["limit": limit, "offset": offset].cleaned)
        }

        public init(path: String, parameters: [String: Any]) {
            self.path = path
            _parameters = parameters
            (limit, offset) = parsePaginatorParameters(parameters)
        }
    }
}

// MARK - GetMultipleActivitys
public struct GetMultipleActivities<Activity: ActivityDecodable, Playlist: PlaylistDecodable, Storefront: StorefrontDecodable>: ResourceRequest {
    public typealias Resource = AppleMusicKit.Resource<Playlist, GetActivity<Activity, Playlist, Storefront>.Relationships>
    public var method: HTTPMethod { return .get }
    public var path: String { return "/v1/catalog/\(storefront)/activities" }
    public let parameters: Any?

    private let storefront: Storefront.Identifier

    public init(storefront: Storefront.Identifier, id: Activity.Identifier, _ additions: Activity.Identifier..., language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        self.init(storefront: storefront, ids: [id] + additions, language: language, include: include)
    }

    public init(storefront: Storefront.Identifier, ids: [Activity.Identifier], language: Storefront.Language? = nil, include: Set<ResourceType>? = nil) {
        assert(!ids.isEmpty)
        self.storefront = storefront
        self.parameters = ["ids": makeIds(ids), "l": language?.languageTag, "include": makeInclude(include)].cleaned
    }
}
