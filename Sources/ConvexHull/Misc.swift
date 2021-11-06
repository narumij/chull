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
public protocol tLinkList {
    var next: UnsafeMutablePointer<Self>! { get }
}

extension tLinkList {
    /// リンクリストをoffsetの数進んだアイテムを返す。
    private func item(offset: Int) -> Self? {
        offset == 0 ? self : self.next.pointee.item(offset: offset - 1)
    }
    /// リンクリストをpositionの数進んだアイテムへアクセスする。
    subscript(position: Int) -> Self {
            item(offset: position)!
    }
}

extension tsVertex: tLinkList { }
extension tsFace:   tLinkList { }
extension tsEdge:   tLinkList { }

public struct tSequence<Pointee: tLinkList>: Sequence {
    
    public typealias Element = UnsafeMutablePointer<Pointee>

    public func makeIterator() -> Iterator {
        Iterator(start: linkList)
    }
    
    let linkList: Element
    
    public struct Iterator: IteratorProtocol {
        
        public mutating func next() -> Element? {
            defer { current = current?.pointee.next ?? start.pointee.next }
            return current.map{ $0 != start ? $0 : nil } ?? start
        }
        
        let start:   Element
        var current: Element?
        init(start s: Element) {
            start = s
        }
    }
}
