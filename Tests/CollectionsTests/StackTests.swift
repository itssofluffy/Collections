/*
    StackTests.swift

    Copyright (c) 2016, 2017, 2018 Stephen Whittle  All rights reserved.

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

class StackTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmpty() {
        var stack = Stack<Int>()

        XCTAssertTrue(stack.isEmpty)
        XCTAssertEqual(stack.count, 0)
        XCTAssertEqual(stack.peek(), nil)
        XCTAssertNil(stack.pop())
    }

    func testOneElement() {
        var stack = Stack<Int>()

        stack.push(123)

        XCTAssertFalse(stack.isEmpty)
        XCTAssertEqual(stack.count, 1)
        XCTAssertEqual(stack.peek(), 123)

        let result = stack.pop()

        XCTAssertEqual(result, 123)
        XCTAssertTrue(stack.isEmpty)
        XCTAssertEqual(stack.count, 0)
        XCTAssertEqual(stack.peek(), nil)
        XCTAssertNil(stack.pop())
    }

    func testTwoElements() {
        var stack = Stack<Int>()

        stack.push(123)
        stack.push(456)

        XCTAssertFalse(stack.isEmpty)
        XCTAssertEqual(stack.count, 2)
        XCTAssertEqual(stack.peek(), 456)

        let result1 = stack.pop()

        XCTAssertEqual(result1, 456)
        XCTAssertFalse(stack.isEmpty)
        XCTAssertEqual(stack.count, 1)
        XCTAssertEqual(stack.peek(), 123)

        let result2 = stack.pop()

        XCTAssertEqual(result2, 123)
        XCTAssertTrue(stack.isEmpty)
        XCTAssertEqual(stack.count, 0)
        XCTAssertEqual(stack.peek(), nil)
        XCTAssertNil(stack.pop())
    }

    func testMakeEmpty() {
        var stack = Stack<Int>()

        stack.push(123)
        stack.push(456)

        XCTAssertNotNil(stack.pop())
        XCTAssertNotNil(stack.pop())
        XCTAssertNil(stack.pop())

        stack.push(789)

        XCTAssertEqual(stack.count, 1)
        XCTAssertEqual(stack.peek(), 789)

        let result = stack.pop()

        XCTAssertEqual(result, 789)
        XCTAssertTrue(stack.isEmpty)
        XCTAssertEqual(stack.count, 0)
        XCTAssertEqual(stack.peek(), nil)
        XCTAssertNil(stack.pop())
    }

    func testSequence() {
        var queue = Stack<Int>()

        for count in 1...100 {
            queue.push(count)
        }

        var count = 100

        for value in queue {
            XCTAssertEqual(value, count, "\(value) != \(count)")

            count -= 1
        }
    }

#if os(Linux)
    static let allTests = [
        ("testEmpty", testEmpty),
        ("testOneElement", testOneElement),
        ("testTwoElements", testTwoElements),
        ("testMakeEmpty", testMakeEmpty),
        ("testSequence", testSequence)
    ]
#endif
}
