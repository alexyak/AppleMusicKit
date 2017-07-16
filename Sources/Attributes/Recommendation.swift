//
//  Recommendation.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/05.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol RecommendationDecodable: Attributes {
}

// MARK: - Recommendation
public protocol Recommendation: RecommendationDecodable {
    init(
        isGroupRecommendation: Bool,
        title: String?,
        reason: String?,
        resourceTypes: [ResourceType],
        nextUpdateDate: String
    ) throws
}

private enum CodingKeys: String, CodingKey {
    case isGroupRecommendation, title, reason, resourceTypes, nextUpdateDate
}

private struct Object: Decodable {
    let stringForDisplay: String
}

extension Recommendation {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(isGroupRecommendation: c.decode(forKey: .isGroupRecommendation),
                      title: c.decodeIfPresent(Object.self, forKey: .title)?.stringForDisplay,
                      reason: c.decodeIfPresent(Object.self, forKey: .reason)?.stringForDisplay,
                      resourceTypes: c.decode(forKey: .resourceTypes),
                      nextUpdateDate: c.decode(forKey: .nextUpdateDate))
    }
}
