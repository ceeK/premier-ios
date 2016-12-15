//
//  Movie.swift
//  PremierSwift
//
//  Created by Chris Howell on 13/12/2016.
//  Copyright © 2016 Deliveroo. All rights reserved.
//

import Foundation

struct Movie {
    let title: String
    let synopsis: String
    let posterPath: String
}

extension Movie: JSONRepresentable {
    
    init?(json: JSONDictionary) {
        guard
            let title: String = Movie.parse(json: json, key: "title"),
            let synopsis: String = Movie.parse(json: json, key: "overview"),
            let posterPath: String = Movie.parse(json: json, key: "poster_path")
        else {
            return nil
        }
        
        self.title = title
        self.synopsis = synopsis
        self.posterPath = posterPath
    }
    
}

extension Movie {

    static let topMovies = Resource<[Movie]>(url: URL(string: "https://api.themoviedb.org/3/movie/top_rated")!, parseJSON: { json in
        guard
            let json = json as? JSONDictionary,
            let results = json["results"] as? [JSONDictionary]
        else { return nil }
        
        return results.flatMap(Movie.init(json:))
    })

}
