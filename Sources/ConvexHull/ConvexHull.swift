//  Created by narumij on 2021/10/04.

import Foundation
import chull

/// ConvexHullクラスに食わせるデータ型のプロトコル
public protocol VertexItem {
    var position: SIMD3<Float> { get }
}

/// 凸包を生成するクラス
//@MainActor
public class ConvexHull<PrimeVertex: VertexItem> {
    
    var convexHull: tsConvexHull
    
    let primeVertices: [PrimeVertex]
    
    public nonisolated init(_ sources: [PrimeVertex], check c: Bool = false, debug d: Bool = false) {
        
        convexHull = tsConvexHull(vertices: nil, edges: nil, faces: nil, debug: d, check: c)
        
        primeVertices = sources
        
        for (vnum, v) in primeVertices.enumerated() {
            convexHull.append(
                x: .init(v.position.x),
                y: .init(v.position.y),
                z: .init(v.position.z),
                vnum: .init(vnum),
                opaque: nil
            )
        }
        
    }
    
    deinit {
        convexHull.free()
    }
    
    /// 保持している頂点を走査し、凸包を生成する。
    public func scan() throws {
        convexHull.doubleTriangle()
        convexHull.constructHull()
        convexHull.edgeOrderOnFaces()
    }
    
    /// 結果をPostScriptで出力
    public func print() {
        convexHull.print()
    }
    
}

extension ConvexHull {
    
    var resultEdgeIndices:[(Int,Int)] {
        
        tSequence(linkList: convexHull.edges)
            .map { e -> (Int,Int) in
                ((.init(e.pointee.endpts.0!.pointee.vnum)),
                 (.init(e.pointee.endpts.1!.pointee.vnum)))
            }
    }
    
    var resultFaceIndeces:[(Int,Int,Int)] {
        
        tSequence(linkList: convexHull.faces)
            .map { f -> (Int,Int,Int) in
                ((.init(f.pointee.vertex.0!.pointee.vnum)),
                 (.init(f.pointee.vertex.1!.pointee.vnum)),
                 (.init(f.pointee.vertex.2!.pointee.vnum)))
            }
    }
    
    var resultFaceEdgeIndeces:[[(Int,Int)]] {
        
        tSequence(linkList: convexHull.faces)
            .map { f -> [(Int,Int)] in
                [
                    ( .init(f.pointee.edge.0!.pointee.endpts.0!.pointee.vnum),
                      .init(f.pointee.edge.0!.pointee.endpts.1!.pointee.vnum) ),
                    
                    ( .init(f.pointee.edge.1!.pointee.endpts.0!.pointee.vnum),
                      .init(f.pointee.edge.1!.pointee.endpts.1!.pointee.vnum) ),
                    
                    ( .init(f.pointee.edge.2!.pointee.endpts.0!.pointee.vnum),
                      .init(f.pointee.edge.2!.pointee.endpts.1!.pointee.vnum) )
                ]
            }
    }
    
    /// 枠線の取得
    public var resultEdges:[(PrimeVertex, PrimeVertex)] {
        
        resultEdgeIndices
            .map { e -> (PrimeVertex, PrimeVertex) in
                ( primeVertices[e.0], primeVertices[e.1] )
            }
    }
    
    /// 三角形の取得
    public var resultFace:[(PrimeVertex, PrimeVertex, PrimeVertex)] {
        
        resultFaceIndeces
            .map { f -> (PrimeVertex, PrimeVertex, PrimeVertex) in
                ( primeVertices[f.0], primeVertices[f.1], primeVertices[f.2] )
            }
    }
    
#if false
    public static func main(argc: Int32, argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?) -> Int32 {
        var convexHull = tsConvexHull(vertices: nil, edges: nil, faces: nil, debug: false, check: false)
        let result = convexHull.main(argc: argc, argv: argv)
        convexHull.free()
        return result
    }
#endif
}
