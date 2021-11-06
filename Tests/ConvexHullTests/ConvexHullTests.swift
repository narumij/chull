//
//  ConvexHullTests.swift
//  ConvexHullTests
//
//  Created by narumij on 2021/10/10.
//

import XCTest
import ConvexHull

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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test00() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let chull = ConvexHull<Atom>( fcube.map{ .init(position: .init($0.0,$0.1,$0.2) ) },
                                         check: false,
                                         debug: false )
        XCTAssertNoThrow( try chull.scan() )
        chull.print()
        XCTAssertEqual(chull.resultFace.count,12)
        XCTAssertEqual(chull.resultEdges.count,18)

    }
    
    func testBase(num: Int, times: Int) throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        print("\n \(num) Point x \(times)", terminator: "")
        for _ in (0..<times) {
            let chull = ConvexHull<SIMD3<Float>>( .init((0..<num).map{ _ in .init(rnd(), rnd(), rnd() ) } ),
                                                  check: false,
                                                  debug: false )
            XCTAssertNoThrow( try chull.scan() )
        }
        print()
    }
                                                                //  (Release build)
    func test02() throws { try testBase(num: 4, times: 10000) } //    0.033 sec
    func test03() throws { try testBase(num: 5, times: 10000) } //    0.039 sec
    func test04() throws { try testBase(num: 6, times: 10000) } //    0.050 sec
    func test05() throws { try testBase(num: 10, times: 5000) } //    0.048 sec
    func test06() throws { try testBase(num: 100, times: 500) } //    0.071 sec
    func test07() throws { try testBase(num: 1000, times: 25) } //    0.067 sec
    func test08() throws { try testBase(num: 10000, times: 1) } //    0.186 sec
    func test09() throws { try testBase(num: 20000, times: 1) } //    0.728 sec
    func test10() throws { try testBase(num: 30000, times: 1) } //    1.691 sec
    func test11() throws { try testBase(num: 50000, times: 1) } //    4.068 sec
    func test12() throws { try testBase(num:100000, times: 1) } //   16.734 sec
    
}

