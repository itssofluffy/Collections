/*
    MultiMapTests.swift

    Copyright (c) 2017 Stephen Whittle  All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom
    the Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
    IN THE SOFTWARE.
*/

import XCTest

@testable import Collections

class MultiMapTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct TestData {
        static let Dictionary = [1:2, 2:3, 3:4]
    }

    var multiMap = MultiMap<Int, Int>()

    func testEmptyMultiMap() {
        XCTAssertEqual(multiMap.count, 0)
        XCTAssertEqual(multiMap.keyCount, 0)

        multiMap.removeValuesForKey(1)

        XCTAssertEqual(multiMap.count, 0)
        XCTAssertEqual(multiMap.keyCount, 0)
    }

    func testInitWithDictionary() {
        multiMap = MultiMap(TestData.Dictionary)

        XCTAssertEqual(multiMap.count, TestData.Dictionary.count)
        XCTAssertEqual(multiMap.keyCount, TestData.Dictionary.count)

        for (k, v) in TestData.Dictionary {
            XCTAssertTrue(multiMap.containsValue(v, forKey: k))
        }
    }

    func testContainsKey() {
        multiMap = MultiMap(TestData.Dictionary)

        XCTAssertTrue(multiMap.containsKey(1))
        XCTAssertFalse(multiMap.containsKey(100))
    }

    func testContainsValueForKey() {
        multiMap = MultiMap(TestData.Dictionary)

        XCTAssertTrue(multiMap.containsValue(3, forKey: 2))
        XCTAssertFalse(multiMap.containsValue(2, forKey: 2))
        XCTAssertFalse(multiMap.containsValue(2, forKey: 100))
    }

    func testSubscript() {
        multiMap = MultiMap(TestData.Dictionary)

        XCTAssertEqual(multiMap[1], [2])
        XCTAssertEqual(multiMap[100], [])
    }

    func testInsertValueForKey() {
        multiMap.insertValue(10, forKey: 5)

        XCTAssertEqual(multiMap.count, 1)
        XCTAssertEqual(multiMap.keyCount, 1)
        XCTAssertEqual(multiMap[5], [10])
    }

    func testInsertValuesForKey() {
        multiMap.insertValues([1, 2], forKey: 5)

        XCTAssertEqual(multiMap.count, 2)
        XCTAssertEqual(multiMap.keyCount, 1)
        XCTAssertTrue(multiMap.containsValue(1, forKey: 5))
        XCTAssertTrue(multiMap.containsValue(2, forKey: 5))
        XCTAssertFalse(multiMap.containsValue(3, forKey: 5))
    }

    func testReplaceValuesForKey() {
        multiMap.insertValues([1, 2, 3], forKey: 5)
        multiMap.insertValues([1, 2, 3], forKey: 10)
        multiMap.replaceValues([10], forKey: 5)

        XCTAssertEqual(multiMap.count, 4)
        XCTAssertEqual(multiMap.keyCount, 2)
        XCTAssertEqual(multiMap[5], [10])
    }

    func testRemoveValueForKey() {
        multiMap.insertValues([1, 2, 2], forKey: 5)
        multiMap.removeValue(2, forKey: 5)

        var a = [1: 1]

        a.removeValue(forKey: 1)

        XCTAssertEqual(multiMap.count, 2)
        XCTAssertEqual(multiMap.keyCount, 1)
        XCTAssertTrue(multiMap.containsValue(1, forKey: 5))
        XCTAssertTrue(multiMap.containsValue(2, forKey: 5))

        multiMap.removeValue(2, forKey: 5)

        XCTAssertFalse(multiMap.containsValue(2, forKey: 5))
        XCTAssertTrue(multiMap.containsValue(1, forKey: 5))
    }

    func testRemoveValuesForKey() {
        multiMap.insertValues([1, 2, 2], forKey: 5)
        multiMap.insertValues([2], forKey: 10)
        multiMap.removeValuesForKey(5)

        XCTAssertEqual(multiMap.count, 1)
        XCTAssertEqual(multiMap.keyCount, 1)
        XCTAssertFalse(multiMap.containsValue(1, forKey: 5))
        XCTAssertTrue(multiMap.containsValue(2, forKey: 10))
    }

    func testRemoveAll() {
        multiMap = MultiMap(TestData.Dictionary)
        multiMap.removeAll(keepingCapacity: true)

        XCTAssertEqual(multiMap.count, 0)
        XCTAssertEqual(multiMap.keyCount, 0)
        XCTAssertEqual(multiMap[1], [])
    }

    func testSequenceTypeConformance() {
        multiMap.insertValues([1, 2, 2], forKey: 5)
        multiMap.insertValues([5], forKey: 10)

        var values = [1, 2, 2, 5]
        var keys = [5, 5, 5, 10]

        for (key, value) in multiMap {
            if let index = values.index(of: value) {
                values.remove(at: index)
            }

            if let index = keys.index(of: key) {
                keys.remove(at: index)
            }
        }

        XCTAssertEqual(values.count, 0)
        XCTAssertEqual(keys.count, 0)
    }

    func testDictionaryLiteralConvertibleConformance() {
        multiMap = [1:2, 2:2, 2:2]

        XCTAssertEqual(multiMap.count, 3)
        XCTAssertEqual(multiMap.keyCount, 2)
        XCTAssertEqual(multiMap[1], [2])
        XCTAssertEqual(multiMap[2], [2, 2])
    }

    func testEquatableConformance() {
        multiMap = MultiMap(TestData.Dictionary)

        var other = MultiMap<Int, Int>()

        XCTAssertTrue(multiMap != other)

        other = multiMap

        XCTAssertTrue(multiMap == other)
    }

#if !os(OSX)
    static let allTests = [
        ("testEmptyMultiMap", testEmptyMultiMap),
        ("testInitWithDictionary", testInitWithDictionary),
        ("testContainsKey", testContainsKey),
        ("testContainsValueForKey", testContainsValueForKey),
        ("testSubscript", testSubscript),
        ("testInsertValueForKey", testInsertValueForKey),
        ("testInsertValuesForKey", testInsertValuesForKey),
        ("testReplaceValuesForKey", testReplaceValuesForKey),
        ("testRemoveValueForKey", testRemoveValueForKey),
        ("testRemoveValuesForKey", testRemoveValuesForKey),
        ("testRemoveAll", testRemoveAll),
        ("testSequenceTypeConformance", testSequenceTypeConformance),
        ("testDictionaryLiteralConvertibleConformance", testDictionaryLiteralConvertibleConformance),
        ("testEquatableConformance", testEquatableConformance)
    ]
#endif
}
