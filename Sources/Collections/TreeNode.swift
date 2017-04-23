/*
    TreeNode.swift

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

public class TreeNode<T: Equatable> {
    private var _value: T?
    public var value: T {
        return _value!
    }

    public private(set) weak var parent: TreeNode?
    public private(set) var children = Array<TreeNode<T>>()

    public init() { }

    public init(value: T) {
        self._value = value
    }

    public var isRoot: Bool {
        return (parent == nil) ? true : false
    }

    public var isLeaf: Bool {
        return (children.isEmpty)
    }

    public var isNode: Bool {
        return (!isRoot && !isLeaf)
    }

    public func addChild(node: TreeNode<T>) {
        children.append(node)
        node.parent = self
    }

    public func search(for value: T) -> TreeNode? {
        if (self.value == value) {
            return self
        }

        for child in children {
            if let found = child.search(for: value) {
                return found
            }
        }

        return nil
    }
}

extension TreeNode: CustomStringConvertible {
    public var description: String {
        var description = "\(value)"

        if (!isLeaf) {
            description += ": (" + children.map { $0.description }.joined(separator: ", ") + ")"
        }

        return description
    }
}
