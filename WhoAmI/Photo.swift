//
//  Photo.swift
//  WhoAmI
//
//  Created by FABRICIO ALVARENGA on 03/10/22.
//

import Foundation
import UIKit
import SwiftUI

struct Photo: Identifiable, Comparable, Codable {
    var id: UUID
    var name: String
    var data: Data
    
    var inputImage: UIImage? {
        UIImage(data: data)
    }
    
    var image: Image {
        if let inputImage = inputImage {
            return Image(uiImage: inputImage)
        } else {
            return Image(systemName: "exclamationmark.triangle")
        }
    }
    
    static func < (lhs: Photo, rhs: Photo) -> Bool {
        lhs.name < rhs.name
    }
}
