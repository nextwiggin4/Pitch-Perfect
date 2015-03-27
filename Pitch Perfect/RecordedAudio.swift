//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Matthew Dean Furlo on 3/23/15.
//  Copyright (c) 2015 FurloBros. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String, filePathUrl: NSURL){
        self.title = title
        self.filePathUrl = filePathUrl
    }
}