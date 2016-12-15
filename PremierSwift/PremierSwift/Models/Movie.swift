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

extension Movie {
    
    init(json: JSONDictionary) {
        guard
            let title = json["title"] as? String,
            let synopsis = json["overview"] as? String,
            let posterPath = json["poster_path"] as? String
        else {
            fatalError()
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
