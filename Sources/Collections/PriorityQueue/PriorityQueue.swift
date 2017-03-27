/*
    PriorityQueue.swift

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

/// A priority queue each element is associated with a 'priority',
/// elements are popped in highest-priority-first order (the
/// elements with the highest priority are popped first).
///
/// The `push` and `pop` operations run in O(log(n)) time.

public struct PriorityQueue<T: Equatable>: SequentialCollection {
    /// Internal structure holding the elements.
    fileprivate var _heap = BinaryHeap<T>()

    public init() { }

    /// Constructs a priority queue from a sequence, such as an array, using a given closure to
    /// determine the order of a provided pair of elements. The closure that you supply for
    /// `sortedBy` should return a boolean value to indicate whether one element
    /// should be before (`true`) or after (`false`) another element using strict weak ordering.
    /// See http://en.wikipedia.org/wiki/Weak_ordering#Strict_weak_orderings
    ///
    /// - Parameters:
    ///   - sortedBy: Strict weak ordering function for checking if the first element has higher priority.
    public init<S: Sequence>(_ elements: S, sortedBy sortFunction: @escaping (T, T) -> Bool) where S.Iterator.Element == T {
        _heap = BinaryHeap<T>(compareFunction: sortFunction)

        for element in elements {
            push(element)
        }
    }

    /// Constructs an empty priority queue using a closure to determine the order of a provided pair
    /// of elements. The closure that you supply for `sortedBy` should return a boolean value to
    /// indicate whether one element should be before (`true`) or after (`false`) another element
    /// using strict weak ordering.
    /// See http://en.wikipedia.org/wiki/Weak_ordering#Strict_weak_orderings
    ///
    /// - Parameters:
    ///   - sortedBy: Strict weak ordering function checking if the first element has higher priority.
    public init(sortedBy sortFunction: @escaping (T, T) -> Bool) {
        self.init([], sortedBy: sortFunction)
    }

    /// The number of elements stored in the priority queue.
    public var count: Int {
        return _heap.count
    }

    /// Push an element into the priority queue.
    ///
    /// - Parameters:
    ///   - element:
    public mutating func push(_ element: T) {
        _heap.push(element)
    }

    /// Retrieves and removes the highest priority element of the queue.
    ///
    /// - Returns: The highest priority element, or `nil` if the queue is empty.
    public mutating func pop() -> T? {
        return _heap.pop()
    }

    /// The highest priority element in the queue, or `nil` if the queue is empty.
    ///
    /// - Returns: The highest priority element, or `nil` if the queue is empty.
    public func peek() -> T? {
        return _heap.peek()
    }

    /// Removes all the elements from the priority queue, and by default
    /// clears the underlying storage buffer.
    ///
    /// - Parameters:
    ///   - keepCapacity:
    public mutating func removeAll(keepingCapacity keep: Bool = false) {
        _heap.removeAll(keepingCapacity: keep)
    }
}

extension PriorityQueue: Sequence {
    /// Provides for-in loop functionality. Generates elements in no particular order.
    ///
    /// - Returns: A generator over the elements.
    public func makeIterator() -> AnyIterator<T> {
        return _heap.makeIterator()
    }
}

extension PriorityQueue: CustomStringConvertible {
    /// A string containing a suitable textual
    /// representation of the priority queue.
    public var description: String {
        return "[" + map { "\($0)" }.joined(separator: ", ") + "]"
    }
}

public func ==<T: Equatable>(lhs: PriorityQueue<T>, rhs: PriorityQueue<T>) -> Bool {
    return (lhs._heap == rhs._heap)
}

public func !=<T: Equatable>(lhs: PriorityQueue<T>, rhs: PriorityQueue<T>) -> Bool {
    return !(lhs == rhs)
}
