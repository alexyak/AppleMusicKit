//
//  Utils.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

func makeIds<Identifier>(_ ids: [Identifier]) -> String {
    return ids.map(String.init(describing:)).joined(separator: ",")
}

func makePaginatorParameters<R: PaginatorRequest>(_ base: [String: Any], request: R) -> [String: Any] {
    var p = base
    if let limit = request.limit {
        p.merge([("limit", limit)], uniquingKeysWith: { _, last in last })
    }
    if let offset = request.offset {
        p.merge([("offset", offset)], uniquingKeysWith: { _, last in last })
    }
    return p
}

func parsePaginatorParameters(_ base: [String: Any]) -> (limit: Int?, offset: Int?) {
    func toInt(forKey key: String) -> Int? {
        if let val = base[key] as? Int { return val }
        if let str = base[key] as? String { return Int(str) }
        return nil
    }
    return (toInt(forKey: "limit"), toInt(forKey: "offset"))
}