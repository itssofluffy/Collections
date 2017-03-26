/*
    PriorityQueueTests.swift

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

class PriorityQueueTests: XCTestCase {
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
         static let List = [4, 5, 3, 3, 1, 2]
         static let Max = 5
     }

     var queue = PriorityQueue<Int>(sortedBy: >)

     func testEmptyQueue() {
         XCTAssertEqual(queue.count, 0)
         XCTAssertNil(queue.peek())
     }

     func testInitWithArray() {
         queue = PriorityQueue(TestData.List, sortedBy: >)
         let list = TestData.List.sorted(by: >)

         for index in 0 ..< list.count {
             let element = queue.pop()

             XCTAssertNotNil(element)
             XCTAssertEqual(element, list[index])
         }
     }

     func testSinglePush() {
         queue.push(TestData.Value)

         XCTAssertEqual(queue.count, 1)
         XCTAssertTrue(queue.peek()! == TestData.Value)
     }

     func testConsecutivePush() {
         for item in TestData.List {
             queue.push(item)
         }

         XCTAssertEqual(queue.count, TestData.List.count)

         let list = TestData.List.sorted(by: >)

         for index in 0 ..< list.count {
             let element = queue.pop()

             XCTAssertNotNil(element)
             XCTAssertEqual(element, list[index])
         }
     }

     func testRemoveAll() {
         queue = PriorityQueue(TestData.List, sortedBy: >)
         queue.removeAll(keepingCapacity: true)

         XCTAssertEqual(queue.count, 0)
     }

     func testSequenceTypeConformance() {
         queue = PriorityQueue(TestData.List, sortedBy: >)
         var list = TestData.List

         for element in queue {
             if let index = list.index(of: element) {
                 list.remove(at: index)
             }
         }

         XCTAssertEqual(list.count, 0)
     }

     func testEqual() {
         queue = PriorityQueue<Int>(sortedBy: >)
         var other = PriorityQueue<Int>(sortedBy: >)

         XCTAssertTrue(queue == other)

         queue.push(TestData.Value)

         XCTAssertFalse(queue == other)

         other.push(TestData.Value)

         XCTAssertTrue(queue == other)
     }


#if !os(OSX)
    static let allTests = [
        ("testEmptyQueue", testEmptyQueue),
        ("testInitWithArray", testInitWithArray),
        ("testSinglePush", testSinglePush),
        ("testConsecutivePush", testConsecutivePush),
        ("testRemoveAll", testRemoveAll),
        ("testSequenceTypeConformance", testSequenceTypeConformance),
        ("testEqual", testEqual)
    ]
#endif
}
