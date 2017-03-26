/*
    Stack.swift

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

/*
    Last-in first-out stack (LIFO)

    push() and pop() are O(1) operations.
*/

public struct Stack<T>: SequentialCollection {
    fileprivate var _elements = Array<T>()

    public init() { }

    public var count: Int {
        return _elements.count
    }

    public mutating func push(_ element: T) {
        _elements.append(element)
    }

    public mutating func pop() -> T? {
        return _elements.popLast()
    }

    public func peek() -> T? {
        return _elements.last
    }
}

public func ==<T: Equatable>(lhs: Stack<T>, rhs: Stack<T>) -> Bool {
    if (lhs._elements.count != rhs._elements.count) {
        return false
    }

    for index in 0 ..< lhs.count {
        if (lhs._elements[index] != rhs._elements[index]) {
            return false
        }
    }

    return true
}

public func !=<T: Equatable>(lhs: Stack<T>, rhs: Stack<T>) -> Bool {
    return !(lhs == rhs)
}