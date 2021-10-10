//
//  Misc.swift
//  ConvexHull
//
//  Created by narumij on 2021/10/10.
//

import Foundation
import chull

extension VertexItem {
    /// Opaque型からオブジェクトを生成する。
    static func from(opaque p: UnsafeRawPointer?) -> Self? {
        // guardやオプショナルチェーンが効かない場合がある
        if p == nil { return nil }
        return p?.bindMemory(to: Self.self, capacity: 1).pointee
    }
    
}

/// chull.cで用いられているリンクリストのSwiftでの表現。
public protocol tsLinkList: Equatable {
    var next: UnsafeMutablePointer<Self>! { get }
}

extension tsLinkList {
    /// リンクリストをoffsetの数進んだアイテムを返す。
    func item(offset: Int) -> Self? {
        offset == 0 ? self : self.next.pointee.item(offset: offset - 1)
    }
    /// リンクリストをpositionの数進んだアイテムへアクセスする。
    subscript(position: Int) -> Self {
            item(offset: position)!
    }
}

/// chull.cの構造体に対して共通で用いるイテレータ
public struct tsIterator<T: tsLinkList> : IteratorProtocol {
    public mutating func next() -> T? {
        defer { current = current?.next?.pointee  }
        return current == begin ? nil : current
    }
    public typealias Element = T
    var current: T?
    let begin: T?
}

extension tsVertex: Sequence, tsLinkList {
    public static func == (lhs: tVertexStructure, rhs: tVertexStructure) -> Bool {
        [
            (lhs.next,  rhs.next),
            (lhs.prev,  rhs.prev),
        ]
            .allSatisfy(==)
    }
}

extension tsEdge: Sequence, tsLinkList {
    public static func == (lhs: tsEdge, rhs: tsEdge) -> Bool {
        [
            (lhs.next,  rhs.next),
            (lhs.prev,  rhs.prev),
        ]
            .allSatisfy(==)
    }
}

extension tsFace: Sequence, tsLinkList {
    public static func == (lhs: tsFace, rhs: tsFace) -> Bool {
        [
            (lhs.next,  rhs.next),
            (lhs.prev,  rhs.prev),
        ]
            .allSatisfy(==)
    }
}

extension Sequence where Self: tsLinkList {
    public __consuming func makeIterator() -> tsIterator<Self> {
        tsIterator<Self>(current: self, begin: self)
    }
    public typealias Element = Self
    public typealias Iterator = tsIterator<Self>
}
