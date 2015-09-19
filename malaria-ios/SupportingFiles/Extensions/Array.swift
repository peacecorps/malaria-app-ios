//
//  Array.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 19/09/15.
//  Copyright © 2015 Bruno Henriques. All rights reserved.
//

import Foundation

extension Array {
    func foreach(functor: (Element) -> ()) {
        for element in self {
            functor(element)
        }
    }
}