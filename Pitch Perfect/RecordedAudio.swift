//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Laurent Nicolas on 5/15/15.
//  Copyright (c) 2015 Laurent Nicolas. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}