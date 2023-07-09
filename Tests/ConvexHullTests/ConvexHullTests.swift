//
//  ConvexHullTests.swift
//  ConvexHullTests
//
//  Created by narumij on 2021/10/10.
//

import XCTest
@testable import ConvexHull

func equal(_ lhs: [(Int,Int,Int)],_ rhs: [(Int,Int,Int)] ) -> Bool {
    lhs.count == rhs.count && zip(lhs,rhs).reduce(true) {
        $0 && $1.0.0 == $1.1.0 && $1.0.1 == $1.1.1 && $1.0.2 == $1.1.2
    }
}

class ConvexHullTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func test00() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let chull = ConvexHull<Atom>( fcube.map{ .init(position: .init($0.0,$0.1,$0.2) ) },
                                      check: false,
                                      debug: false )
        XCTAssertNoThrow( try chull.scan() )
        
//        chull.print()
        
        XCTAssertEqual(chull.resultFace.count,12)
        XCTAssertEqual(chull.resultEdges.count,18)
        
        XCTAssertTrue ( equal( [ (0,0,0) ], [ (0,0,0)          ] ) )
        XCTAssertFalse( equal( [ (0,0,0) ], [ (0,0,0), (0,0,0) ] ) )
        XCTAssertFalse( equal( [ (1,0,0) ], [ (0,0,0)          ] ) )

        XCTAssertTrue(
            equal( chull.resultFaceIndeces,
                   [
                    (0, 1, 2),
                    (1, 0, 4),
                    (2, 1, 5),
                    (1, 4, 5),
                    (2, 5, 6),
                    (5, 4, 6),
                    (4, 0, 7),
                    (2, 6, 7),
                    (6, 4, 7),
                    (0, 2, 3),
                    (7, 0, 3),
                    (2, 7, 3)]
                 ) )
    }
    
    @MainActor
    func test01() throws {
        
        let fcube: [SIMD3<Float>] = [[0,0,0],[1,0,0],[0,1,0],[0,0,1]]
        
        let chull = ConvexHull<SIMD3<Float>>( fcube,
                                              check: false,
                                              debug: false )
        XCTAssertNoThrow( try chull.scan() )

        XCTAssertEqual(chull.resultFace.count,4)
        XCTAssertEqual(chull.resultEdges.count,6)
    }
    
    @MainActor
    func testPerformanceBase(num: Int, times: Int) throws {
        let v: [SIMD3<Float>] = .init((0..<num).map{ _ in .init(rnd(), rnd(), rnd() ) } )
        measure {
            try? ConvexHull<SIMD3<Float>>( v,
                                           check: false,
                                           debug: false )
                .scan()
        }
    }
    
    @MainActor
    func test02() throws { try testPerformanceBase(num: 4, times: 10000) }
    @MainActor
    func test03() throws { try testPerformanceBase(num: 5, times: 10000) }
    @MainActor
    func test04() throws { try testPerformanceBase(num: 6, times: 10000) }
    @MainActor
    func test05() throws { try testPerformanceBase(num: 10, times: 5000) }
    @MainActor
    func test06() throws { try testPerformanceBase(num: 100, times: 500) }
    @MainActor
    func test07() throws { try testPerformanceBase(num: 1000, times: 25) }
    @MainActor
    func test08() throws { try testPerformanceBase(num: 10000, times: 1) }
}

