//
//  Station.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/07/03.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

public protocol StationDecodable: Attributes {
}

// MARK: - Station
public protocol Station: StationDecodable {
    associatedtype Artwork: AppleMusicKit.Artwork
    associatedtype EditorialNotes: AppleMusicKit.EditorialNotes

    init(artwork: Artwork,
         durationInMillis: Int?,
         editorialNotes: EditorialNotes?,
         episodeNumber: Int?,
         isLive: Bool,
         name: String,
         url: String) throws
}

private enum CodingKeys: String, CodingKey {
    case artwork, durationInMillis, editorialNotes, episodeNumber, isLive, name, url
}

extension Station {
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(artwork: c.decode(forKey: .artwork),
                      durationInMillis: c.decodeIfPresent(forKey: .durationInMillis),
                      editorialNotes: c.decodeIfPresent(forKey: .editorialNotes),
                      episodeNumber: c.decodeIfPresent(forKey: .episodeNumber),
                      isLive: c.decode(forKey: .isLive),
                      name: c.decode(forKey: .name),
                      url: c.decode(forKey: .url))
    }
}
