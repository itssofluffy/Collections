/*
    LinkedList.swift

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

public final class LinkedList<T: Equatable>: LinkedListType {
    public typealias NodeType = Node<T>

    fileprivate var _start: NodeType? {
        didSet {
            // special case for a 1 element list
            if (_end == nil) {
                _end = _start
            }
        }
    }

    fileprivate var _end: NodeType? {
        didSet {
            // special case for a 1 element list
            if (_start == nil) {
                _start = _end
            }
        }
    }

    /// the number of elements in the list at any given time
    public fileprivate(set) var count: Int = 0

    /// create a new LinkedList
    public init() { }

    /// create a new LinkedList with a sequence
    public init<S: Sequence>(_ elements: S) where S.Iterator.Element == T {
        for element in elements {
            append(value: element)
        }
    }
}

extension LinkedList {
    public func append(value: T) {
        let previousEnd = _end

        _end = NodeType(value: value)

        _end?.previous = previousEnd
        previousEnd?.next = _end

        count += 1
    }
}

extension LinkedList {
    fileprivate func iterate(_ closure: (NodeType, Int) throws -> NodeType?) rethrows -> NodeType? {
        var node = _start
        var index = 0

        while (node != nil) {
            let result = try closure(node!, index)

            if (result != nil) {
                return result
            }

            index += 1
            node = node?.next
        }

        return nil
    }
}

extension LinkedList {
    public func nodeAt(index: Int) throws -> NodeType {
        guard (index >= 0 && index < count) else {
            throw LinkedListError.Index(index: index)
        }

        return iterate {
            if ($1 == index) {
                return $0
            }

            return nil
        }!
    }

    public func valueAt(index: Int) throws -> T {
        return try nodeAt(index: index).value
    }
}

extension LinkedList {
    public func remove(node: NodeType) throws {
        let nextNode = node.next
        let previousNode = node.previous

        if (node === _start && node === _end) {
            _start = nil
            _end = nil
        } else if (node === _start) {
            _start = node.next
        } else if (node === _end) {
            _end = node.previous
        } else {
            previousNode?.next = nextNode
            nextNode?.previous = previousNode
        }

        count -= 1

        guard ((_end != nil && _start != nil && count > 1) || (_end == nil && _start == nil && count == 0)) else {
            throw LinkedListError.Invariant
        }
    }

    public func remove(atIndex index: Int) throws {
        guard (index >= 0 && index < count) else {
            throw LinkedListError.Index(index: index)
        }

        let result = iterate {
            if ($1 == index) {
                return $0
            }

            return nil
        }

        try remove(node: result!)
    }
}

extension LinkedList {
    public func copy() -> LinkedList<T> {
        let newLinkedList = LinkedList<T>()

        for element in self {
            newLinkedList.append(value: element.value)
        }

        return newLinkedList
    }
}

extension LinkedList: Sequence {
    public typealias Iterator = LinkedListIterator<T>

    public func makeIterator() -> LinkedList.Iterator {
        return LinkedListIterator(startNode: self._start)
    }
}
