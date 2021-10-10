//  Created by narumij on 2021/10/04.

import Foundation
import chull

/// ConvexHullクラスに食わせるデータ型のプロトコル
public protocol VertexItem {
    var position: SIMD3<Float> { get }
}

/// 凸包を生成するクラス
public class ConvexHull<PrimeVertex: VertexItem> {
    
    var convexHull: tsConvexHull
    
    let primeVertices: [PrimeVertex]
    
    public init(_ sources: [PrimeVertex], check c: Bool = false, debug d: Bool = false) {
        
        convexHull = tsConvexHull(vertices: nil, edges: nil, faces: nil, debug: d, check: c)

        primeVertices = sources

        for (vnum, v) in primeVertices.enumerated() {
            convexHull.append(
                x: .init(v.position.x),
                y: .init(v.position.y),
                z: .init(v.position.z),
                vnum: .init(vnum),
                opaque: &primeVertices[vnum]
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
    
    func primeVertex(_ vert: tVertex?) -> PrimeVertex {
        PrimeVertex.from(opaque: vert?.pointee.opaque )!
    }

    /// 枠線の取得
    public var targetEdges:[(PrimeVertex, PrimeVertex)] {
        convexHull.edges.pointee.map{ ( primeVertex($0.endpts.0), primeVertex($0.endpts.1) ) }
    }
    
    /// 三角形の取得
    public var targetFace:[(PrimeVertex, PrimeVertex, PrimeVertex)] {
        convexHull.faces.pointee.map{ ( primeVertex($0.vertex.0), primeVertex($0.vertex.1), primeVertex($0.vertex.1) ) }
    }
    
    public static func main(argc: Int32, argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?) -> Int32 {
        var convexHull = tsConvexHull(vertices: nil, edges: nil, faces: nil, debug: false, check: false)
        let result = convexHull.main(argc: argc, argv: argv)
        convexHull.free()
        return result
    }
}

