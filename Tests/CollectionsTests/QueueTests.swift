/*
    QueueTests.swift

    Copyright (c) 2016, 2017 Stephen Whittle  All rights reserved.

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

class QueueTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmpty() {
        var queue = Queue<Int>()

        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.peek(), nil)
        XCTAssertNil(queue.pop())
    }

    func testOneElement() {
        var queue = Queue<Int>()

        queue.push(123)

        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.peek(), 123)

        let result = queue.pop()

        XCTAssertEqual(result, 123)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.peek(), nil)
    }

    func testTwoElements() {
        var queue = Queue<Int>()

        queue.push(123)
        queue.push(456)

        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.peek(), 123)

        let result1 = queue.pop()

        XCTAssertEqual(result1, 123)
        XCTAssertFalse(queue.isEmpty)
        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.peek(), 456)

        let result2 = queue.pop()

        XCTAssertEqual(result2, 456)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.peek(), nil)
    }

    func testMakeEmpty() {
        var queue = Queue<Int>()

        queue.push(123)
        queue.push(456)

        XCTAssertNotNil(queue.pop())
        XCTAssertNotNil(queue.pop())
        XCTAssertNil(queue.pop())

        queue.push(789)

        XCTAssertEqual(queue.count, 1)
        XCTAssertEqual(queue.peek(), 789)

        let result = queue.pop()

        XCTAssertEqual(result, 789)
        XCTAssertTrue(queue.isEmpty)
        XCTAssertEqual(queue.count, 0)
        XCTAssertEqual(queue.peek(), nil)
    }

    func testSequence() {
        var queue = Queue<Int>()

        for count in 1...100 {
            queue.push(count)
        }

        var count = 1

        for value in queue {
            XCTAssertEqual(value, count, "\(value) != \(count)")

            count += 1
        }
    }

#if !os(OSX)
    static let allTests = [
        ("testEmpty", testEmpty),
        ("testOneElement", testOneElement),
        ("testTwoElements", testTwoElements),
        ("testMakeEmpty", testMakeEmpty),
        ("testSequence", testSequence)
    ]
#endif
}
