/*
    MatrixTests.swift

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

class MatrixTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    var matrix: Matrix<Double> = [[1]]

    func testInitWithRepeatedValue() {
        do {
            matrix = try Matrix(rows: 10, columns: 10, repeating: 5)

            XCTAssertEqual(matrix.rows, 10)
            XCTAssertEqual(matrix.columns, 10)

            for i in 0 ..< matrix.rows {
                for j in 0 ..< matrix.columns {
                    XCTAssertEqual(matrix[i, j], 5)
                }
            }
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testInitWithGrid() {
        do {
            matrix = try Matrix(rows: 2, columns: 2, grid: [1, 2, 3, 4])

            var counter = 1.0

            for i in 0 ..< matrix.rows {
                for j in 0 ..< matrix.columns {
                    XCTAssertEqual(matrix[i, j], counter)
                    counter += 1
                }
            }
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testInitWithRows() {
        do {
            matrix = try Matrix([[1, 2, 3], [4, 5, 6]])

            var counter = 1.0

            for i in 0 ..< matrix.rows {
                for j in 0 ..< matrix.columns {
                    XCTAssertEqual(matrix[i, j], counter)
                    counter += 1
                }
            }
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testTranspose() {
        var transpose = matrix.transpose

        XCTAssertEqual(transpose[0, 0], 1)

        do {
            transpose = try Matrix([[1, 2, 3], [4, 5, 6]]).transpose

            XCTAssertEqual(transpose[0, 0], 1)
            XCTAssertEqual(transpose[0, 1], 4)
            XCTAssertEqual(transpose[1, 0], 2)
            XCTAssertEqual(transpose[1, 1], 5)
            XCTAssertEqual(transpose[2, 0], 3)
            XCTAssertEqual(transpose[2, 1], 6)
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testSequenceTypeConformance() {
        do {
            matrix = try Matrix([[1, 2, 3], [4, 5, 6]])

            XCTAssertTrue(matrix.elementsEqual([1, 2, 3, 4, 5, 6]))
        } catch {
            XCTAssert(false, "\(error)")
        }
    }

    func testArrayLiteralConvertibleConformance() {
        matrix = [[1, 2, 3], [4, 5, 6]]

        var counter = 1.0

        for i in 0 ..< matrix.rows {
            for j in 0 ..< matrix.columns {
                XCTAssertEqual(matrix[i, j], counter)
                counter += 1
            }
        }
    }

    func testEqual() {
        var other: Matrix<Double> = [[1]]

        XCTAssertTrue(matrix == other)

        matrix = [[3, 2]]

        XCTAssertFalse(matrix == other)

        other = [[3, 2]]

        XCTAssertTrue(matrix == other)
    }

#if os(Linux)
    static let allTests = [
        ("testInitWithRepeatedValue", testInitWithRepeatedValue),
        ("testInitWithGrid", testInitWithGrid),
        ("testInitWithRows", testInitWithRows),
        ("testTranspose", testTranspose),
        ("testSequenceTypeConformance", testSequenceTypeConformance),
        ("testArrayLiteralConvertibleConformance", testArrayLiteralConvertibleConformance),
        ("testEqual", testEqual)
    ]
#endif
}
