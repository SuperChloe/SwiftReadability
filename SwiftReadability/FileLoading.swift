//
//  FileLoading.swift
//  SwiftReadability
//
//  Created by Chloe on 2016-06-22.
//  Copyright © 2016 Chloe Horgan. All rights reserved.
//

import Foundation

enum FileLoadingError: Error {
    case InvalidPath
}

func loadFile(name: String, type: String) throws -> String {
    let bundle = Bundle(for: Readability.self)
    guard let filePath = bundle.path(forResource: name, ofType: type) else {
        throw FileLoadingError.InvalidPath
    }
    
    return try String(contentsOfFile: filePath)
}
