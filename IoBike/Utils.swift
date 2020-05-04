//
//  Utils.swift
//  IoBike
//
//  Created by James Lemkin on 5/3/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import Foundation

extension Int {
    static func from(data: Data) -> Int {
        return Int(data.withUnsafeBytes({ $0.load(as: UInt8.self) }))
    }
}
