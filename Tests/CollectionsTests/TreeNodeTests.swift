/*
    TreeNodeTests.swift

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

class TreeNodeTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTreeNodeTests() {
        let tree = TreeNode<String>(value: "beverages")

        let hot = TreeNode<String>(value: "hot")
        let cold = TreeNode<String>(value: "cold")

        let tea = TreeNode<String>(value: "tea")
        let coffee = TreeNode<String>(value: "coffee")
        let chocolate = TreeNode<String>(value: "cocoa")

        let blackTea = TreeNode<String>(value: "black")
        let greenTea = TreeNode<String>(value: "green")
        let chaiTea = TreeNode<String>(value: "chai")

        let soda = TreeNode<String>(value: "soda")
        let milk = TreeNode<String>(value: "milk")

        let gingerAle = TreeNode<String>(value: "ginger ale")
        let bitterLemon = TreeNode<String>(value: "bitter lemon")

        tree.addChild(node: hot)
        tree.addChild(node: cold)

        hot.addChild(node: tea)
        hot.addChild(node: coffee)
        hot.addChild(node: chocolate)

        cold.addChild(node: soda)
        cold.addChild(node: milk)

        tea.addChild(node: blackTea)
        tea.addChild(node: greenTea)
        tea.addChild(node: chaiTea)

        soda.addChild(node: gingerAle)
        soda.addChild(node: bitterLemon)

        if let result = tree.search(for: "beverages") {
            XCTAssertEqual(result.isRoot, true, "beverages is a root!")
            XCTAssertEqual(result.isLeaf, false, "beverages is a leaf!")
            XCTAssertEqual(result.isNode, false, "beverages is a not a node!")

            if let parent = result.parent {
                XCTAssert(false, "beverages has a parent of \(parent.value)!")
            } else if (result.children[1].value != "cold") {
                XCTAssert(false, "second child of beverage is not \(result.children[1].value)!")
            }

            if (result.description != "beverages: (hot: (tea: (black, green, chai), coffee, cocoa), cold: (soda: (ginger ale, bitter lemon), milk))") {
                XCTAssert(false, "beverages sructure not as expected!")
            }
        } else {
            XCTAssert(false, "beverages not found!")
        }

        if let result = tree.search(for: "soda") {
            XCTAssertEqual(result.isRoot, false, "soda is a root!")
            XCTAssertEqual(result.isLeaf, false, "soda is a leaf!")
            XCTAssertEqual(result.isNode, true, "soda is a a node!")

            if let parent = result.parent {
                if (parent.value != "cold") {
                    XCTAssert(false, "parent of soda is not \(parent.value)!")
                }
            } else {
                XCTAssert(false, "parent of soda not found!")
            }

            if (result.description != "soda: (ginger ale, bitter lemon)") {
                XCTAssert(false, "soda sructure not as expected!")
            }
        } else {
            XCTAssert(false, "soda not found!")
        }

        if let result = tree.search(for: "green") {
            XCTAssertEqual(result.isRoot, false, "green tea is a root!")
            XCTAssertEqual(result.isLeaf, true, "green tea is a leaf!")
            XCTAssertEqual(result.isNode, false, "green tea is a node!")

            if let parent = result.parent {
                if (parent.value != "tea") {
                    XCTAssert(false, "parent of green tea is not \(parent.value)!")
                }
            } else {
                XCTAssert(false, "parent of green tea not found!")
            }

            if (result.description != "green") {
                XCTAssert(false, "green tea sructure not as expected!")
            }
        } else {
            XCTAssert(false, "green tea not found!")
        }
    }

#if os(Linux)
    static let allTests = [
        ("testTreeNodeTests", testTreeNodeTests)
    ]
#endif
}
