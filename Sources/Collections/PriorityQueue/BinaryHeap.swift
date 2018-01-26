/*
    BinaryHeap.swift

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

// Max Heap
internal struct BinaryHeap<T: Equatable>: SequentialCollection {
    // returns true if the first argument has the highest priority
    fileprivate var _isOrderedBefore: (T, T) -> Bool = { _, _ in return false }
    fileprivate var _items = Array<T>()

    internal init() { }

    internal init(compareFunction: @escaping (T, T) -> Bool) {
        _isOrderedBefore = compareFunction
    }

    internal var count: Int {
        return _items.count
    }

    internal mutating func push(_ element: T) {
        _items.append(element)
        siftUp()
    }

    internal mutating func pop() -> T? {
        if (!isEmpty) {
            let value = _items[0]

            _items[0] = _items[count - 1]
            _items.removeLast()

            if (!isEmpty) {
                siftDown()
            }

            return value
        }

        return nil
    }

    internal func peek() -> T? {
        return _items.first
    }

    internal mutating func removeAll(keepingCapacity keep: Bool = false)  {
        _items.removeAll(keepingCapacity: keep)
    }

    private mutating func siftUp() {
        let parent: (Int) -> Int = { index in
            return (index - 1) / 2
        }

        var i = count - 1
        var parentIndex = parent(i)

        while (i > 0 && !_isOrderedBefore(_items[parentIndex], _items[i])) {
#if swift(>=3.2)
            _items.swapAt(i, parentIndex)
#else
            swap(&_items[i], &_items[parentIndex])
#endif
            i = parentIndex
            parentIndex = parent(i)
        }
    }

    private mutating func siftDown() {
        // Returns the index of the maximum element if it exists, otherwise -1
        func maxIndex(_ i: Int, _ j: Int) -> Int {
            if (j >= count && i >= count) {
                return -1
            } else if (j >= count && i < count) {
                return i
            } else if (_isOrderedBefore(_items[i], _items[j])) {
                return i
            }

            return j
        }

        let leftChild: (Int) -> Int = { index in
            return (2 * index) + 1
        }

        let rightChild: (Int) -> Int = { index in
            return (2 * index) + 2
        }

        var i = 0
        var max = maxIndex(leftChild(i), rightChild(i))

        while (max >= 0 && !_isOrderedBefore(_items[i], _items[max])) {
#if swift(>=3.2)
            _items.swapAt(max, i)
#else
             swap(&_items[max], &_items[i])
#endif
             i = max
             max = maxIndex(leftChild(i), rightChild(i))
        }
    }
}

extension BinaryHeap: Sequence {
    internal func makeIterator() -> AnyIterator<T> {
        return AnyIterator(_items.makeIterator())
    }
}

#if swift(>=3.2)
internal func ==<T>(lhs: BinaryHeap<T>, rhs: BinaryHeap<T>) -> Bool {
    return lhs._items.sorted(by: lhs._isOrderedBefore) == rhs._items.sorted(by: rhs._isOrderedBefore)
}

internal func !=<T>(lhs: BinaryHeap<T>, rhs: BinaryHeap<T>) -> Bool {
    return !(lhs == rhs)
}
#else
internal func ==<T: Equatable>(lhs: BinaryHeap<T>, rhs: BinaryHeap<T>) -> Bool {
    return lhs._items.sorted(by: lhs._isOrderedBefore) == rhs._items.sorted(by: rhs._isOrderedBefore)
}

internal func !=<T: Equatable>(lhs: BinaryHeap<T>, rhs: BinaryHeap<T>) -> Bool {
    return !(lhs == rhs)
}
#endif
