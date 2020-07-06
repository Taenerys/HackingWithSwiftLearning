//
//  Person.swift
//  Project10
//
//  Created by Pham Ha Thu Anh on 2020/07/05.
//  Copyright © 2020 AnhWorld. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
