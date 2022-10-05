//
//  FileManager-DocumentsDirectory.swift
//  WhoAmI
//
//  Created by FABRICIO ALVARENGA on 04/10/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}
