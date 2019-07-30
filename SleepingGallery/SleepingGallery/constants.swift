//
//  constants.swift
//  SleepingGallery
//
//  Created by mingkai on 2019/7/25.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import Foundation

struct Constants {
    struct Flickr {
        static let API_BASE_URL = "https://www.flickr.com/services/rest/"
    }
    
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NOJSONCallBack = "nojsoncallback"
    }
    
    struct FlickrParameterValues {
        static let APIKey = "API_KEY"
        static let GalleryID = "5704-72157622566655097"
        static let Extras = "extras"
        static let Format = "format"
        static let DisableJSONCallback = "1"
        static let ResponseFormat = "json"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
}
