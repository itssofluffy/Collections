/*
    MultiSetTests.swift

    Copyright (c) 2017, 2018 Stephen Whittle  All rights reserved.

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

class MultiSetTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    struct TestData {
        static let Value = 50
        static let List = [4, 5, 3, 3, 1, 2, 2]
        static let DistinctCount = 5
    }

    var multiSet = MultiSet<Int>()

    func testEmptyMultiSet() {
        do {
            XCTAssertEqual(multiSet.count, 0)
            XCTAssertEqual(multiSet.distinctCount, 0)

            try multiSet.remove(TestData.Value)

            XCTAssertFalse(multiSet.contains(TestData.Value))
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testInitWithArray() {
        do {
            multiSet = try MultiSet(TestData.List)

            XCTAssertEqual(multiSet.count, TestData.List.count)
            XCTAssertEqual(multiSet.distinctCount, TestData.DistinctCount)

            for element in TestData.List {
                XCTAssertEqual(TestData.List.filter { $0 == element }.count, multiSet.count(element))
                XCTAssertTrue(multiSet.contains(element))
            }
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testSingleInsert() {
        do {
            try multiSet.insert(TestData.Value)

            XCTAssertEqual(multiSet.count, 1)
            XCTAssertEqual(multiSet.distinctCount, 1)
            XCTAssertEqual(multiSet.count(TestData.Value), 1)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testConsecutiveInserts() {
        do {
            try multiSet.insert(TestData.Value)
            try multiSet.insert(TestData.Value)

            XCTAssertEqual(multiSet.count, 2)
            XCTAssertEqual(multiSet.distinctCount, 1)
            XCTAssertEqual(multiSet.count(TestData.Value), 2)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testSingleInsertOccurrences() {
        do {
            try multiSet.insert(TestData.Value, occurrences: 5)

            XCTAssertEqual(multiSet.count, 5)
            XCTAssertEqual(multiSet.distinctCount, 1)
            XCTAssertEqual(multiSet.count(TestData.Value), 5)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testConsecutiveInsertOccurrences() {
        do {
            try multiSet.insert(TestData.Value, occurrences: 5)
            try multiSet.insert(TestData.Value, occurrences: 5)

            XCTAssertEqual(multiSet.count, 10)
            XCTAssertEqual(multiSet.distinctCount, 1)
            XCTAssertEqual(multiSet.count(TestData.Value), 10)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testEmptyRemove() {
        do {
            try multiSet.remove(TestData.Value)

            XCTAssertEqual(multiSet.count, 0)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testRemove() {
        do {
            try multiSet.insert(TestData.Value, occurrences: 5)
            try multiSet.remove(TestData.Value)

            XCTAssertEqual(multiSet.count(TestData.Value), 4)
            XCTAssertEqual(multiSet.count, 4)
            XCTAssertEqual(multiSet.distinctCount, 1)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testRemoveUnique() {
        do {
            try multiSet.insert(TestData.Value, occurrences: 1)
            try multiSet.remove(TestData.Value)

            XCTAssertEqual(multiSet.count(TestData.Value), 0)
            XCTAssertEqual(multiSet.count, 0)
            XCTAssertEqual(multiSet.distinctCount, 0)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testRemoveOccurrences() {
        do {
            try multiSet.insert(TestData.Value, occurrences: 5)
            try multiSet.remove(TestData.Value, occurrences: 2)

            XCTAssertEqual(multiSet.count(TestData.Value), 3)
            XCTAssertEqual(multiSet.count, 3)
            XCTAssertEqual(multiSet.distinctCount, 1)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testRemoveOccurrencesMax() {
        do {
            try multiSet.insert(TestData.Value, occurrences: 5)
            try multiSet.remove(TestData.Value, occurrences: 10)

            XCTAssertEqual(multiSet.count(TestData.Value), 0)
            XCTAssertFalse(multiSet.contains(TestData.Value))
            XCTAssertEqual(multiSet.count, 0)
            XCTAssertEqual(multiSet.distinctCount, 0)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testRemoveAllOf() {
        do {
            try multiSet.insert(TestData.Value, occurrences: 5)
            try multiSet.removeAll(of: TestData.Value)

            XCTAssertEqual(multiSet.count, 0)
            XCTAssertEqual(multiSet.distinctCount, 0)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testRemoveAll() {
        do {
            multiSet = try MultiSet(TestData.List)
            multiSet.removeAll(keepingCapacity: true)

            XCTAssertEqual(multiSet.count, 0)
            XCTAssertEqual(multiSet.distinctCount, 0)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testToSet() {
        do {
            multiSet = try MultiSet(TestData.List)

            let set = Set(multiSet)

            XCTAssertEqual(set.count, TestData.DistinctCount)

            for element in TestData.List {
                XCTAssertTrue(set.contains(element))
            }
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testSequenceTypeConformance() {
        do {
            multiSet = try MultiSet(TestData.List)

            var list = TestData.List

            for element in multiSet {
                if let index = list.index(of: element) {
                    list.remove(at: index)
                }
            }

            XCTAssertEqual(list.count, 0)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testArrayLiteralConvertibleConformance() {
        multiSet = [1, 2, 2, 3]

        XCTAssertEqual(multiSet.count, 4)
        XCTAssertEqual(multiSet.distinctCount, 3)
    }

    func testHashableConformance() {
        do {
            multiSet = try MultiSet(TestData.List)

            var other = MultiSet<Int>()

            XCTAssertNotEqual(multiSet.hashValue, other.hashValue)
            XCTAssertTrue(multiSet != other)

            other = try MultiSet(Array(TestData.List.reversed()))

            XCTAssertEqual(multiSet.hashValue, other.hashValue)
            XCTAssertTrue(multiSet == other)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }


#if os(Linux)
    static let allTests = [
        ("testEmptyMultiSet", testEmptyMultiSet),
        ("testInitWithArray", testInitWithArray),
        ("testSingleInsert", testSingleInsert),
        ("testConsecutiveInserts", testConsecutiveInserts),
        ("testSingleInsertOccurrences", testSingleInsertOccurrences),
        ("testConsecutiveInsertoccurrences", testConsecutiveInsertOccurrences),
        ("testEmptyRemove", testEmptyRemove),
        ("testRemove", testRemove),
        ("testRemoveUnique", testRemoveUnique),
        ("testRemoveoccurrences", testRemoveOccurrences),
        ("testRemoveoccurrencesMax", testRemoveOccurrencesMax),
        ("testRemoveAllOf", testRemoveAllOf),
        ("testRemoveAll", testRemoveAll),
        ("testToSet", testToSet),
        ("testSequenceTypeConformance", testSequenceTypeConformance),
        ("testArrayLiteralConvertibleConformance", testArrayLiteralConvertibleConformance),
        ("testHashableConformance", testHashableConformance)
    ]
#endif
}
