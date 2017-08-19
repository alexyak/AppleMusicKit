//
//  Activity.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/21.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol ActivityDecodable: Attributes {
}

// MARK: - Activity
public protocol Activity: ActivityDecodable, _AttributesCustomInitializable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes

    init(artwork: Artwork, editorialNotes: EditorialNotes?, name: String, url: String) throws
}

private enum CodingKeys: String, CodingKey {
    case artwork, editorialNotes, name, url
}

extension Activity {
    public init(from decoder: Decoder) throws {
        let cc = try decoder.container(keyedBy: ResourceCodingKeys.self)
        let c = try cc.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
        try self.init(artwork: c.decode(forKey: .artwork),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      name: c.decode(forKey: .name),
                      url: c.decode(forKey: .url))
    }
}
