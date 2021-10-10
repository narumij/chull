//
//  TestMisc.swift
//  ConvexHullTests
//
//  Created by narumij on 2021/10/10.
//

import Foundation
import ConvexHull
import os

let rnd = { Float.random(in: -1000..<1000) }
//let logger = Logger(subsystem: "jp.zenithgear.simd-util", category: "chull")

let fcube: [(Float,Float,Float)] = [
    ( 0,  0,  0),
    ( 0, 10,  0),
    (10, 10,  0),
    (10,  0,  0),
    ( 0,  0, 10),
    ( 0, 10, 10),
    (10, 10, 10),
    (10,  0, 10)]

extension SIMD3: VertexItem where Scalar == Float {
    public var position: Self { self }
}

struct Atom: VertexItem {
    var position: SIMD3<Float>
}

extension Atom: Equatable { }


extension String: Error { }

