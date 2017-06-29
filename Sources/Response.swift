//
//  Response.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol Attributes: Decodable {
    associatedtype Identifier: Decodable
}

public protocol Response: Decodable {
    associatedtype Resource
    var data: [Resource] { get }
}

public struct Resource<Attributes: AppleMusicKit.Attributes, Relationships: Decodable>: Decodable {
    public let id: Attributes.Identifier
    public let href: String
    public let attributes: Attributes?
    public let relationships: Relationships?
}

public struct ResponseRoot<Resource: Decodable>: Response {
    public let data: [Resource]
}

public struct Page<R: PaginatorRequest>: Response where R.Resource: Decodable {
    public let data: [R.Resource]
    public let href: String
    public let next: R?
}