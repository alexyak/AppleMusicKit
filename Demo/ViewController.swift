//
//  ViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/06/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    convenience init(hex: String, alpha: CGFloat = 1) {
        var color: Int32 = 0
        Scanner(string: hex).scanInt32(&color)
        self.init(hex: Int(color), alpha: alpha)
    }
}

struct Song: AppleMusicKit.Song {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork

    let name: String
    let artwork: Artwork
}
struct MusicVideo: AppleMusicKit.MusicVideo {
    typealias Identifier = String
    typealias Artwork = Demo.Artwork

    let name: String
    let artwork: Artwork
}
struct Artwork: AppleMusicKit.Artwork {
    let bgColor: UIColor

    private enum CodingKeys: String, CodingKey {
        case bgColor
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        bgColor = .init(hex: try c.decode(String.self, forKey: .bgColor))
    }
}
struct Album: AppleMusicKit.Album {
    typealias Identifier = String

    let name: String
}
struct Artist: AppleMusicKit.Artist {
    typealias Identifier = String

    let name: String
}

struct Genre: AppleMusicKit.Genre {
    typealias Identifier = String
    let name: String
}

typealias GetSong = AppleMusicKit.GetSong<Song, Album, Artist, Genre>
typealias GetAlbum = AppleMusicKit.GetAlbum<Album, Song, MusicVideo, Artist>
typealias GetArtist = AppleMusicKit.GetArtist<Artist, Album, Genre>

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Session.shared.send(GetAlbum(storefront: "us", id: "310730204")) { result in
            switch result {
            case .success(let response):
                print(response.data.first?.relationships?.tracks.data.first)
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
