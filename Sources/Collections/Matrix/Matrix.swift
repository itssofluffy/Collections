/*
    Matrix.swift

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

import ISFLibrary

/// A Matrix is a fixed size generic 2D collection.
public struct Matrix<T> {
    /// The number of rows in the matrix.
    public fileprivate(set) var rows = 0
    /// The number of columns in the matrix.
    public fileprivate(set) var columns = 0
    /// The one-dimensional array backing the matrix in row-major order.
    ///
    /// `Matrix[i, j] == grid[i * columns + j]`
    public fileprivate(set) var grid = Array<T>()

    public init() { }

    /// Constructs a new matrix with all positions set to the specified value.
    public init(rows: Int, columns: Int, repeating repeatedValue: T) throws {
        guard (rows >= 0) else {
            throw MatrixError.Rows(rows: rows)
        }

        guard (columns >= 0) else {
            throw MatrixError.Columns(columns: columns)
        }

        self.rows = rows
        self.columns = columns

        grid = Array(repeating: repeatedValue, count: rows * columns)
    }

    /// Constructs a new matrix using a 1D array in row-major order.
    ///
    /// `Matrix[i, j] == grid[i * columns + j]`
    public init(rows: Int, columns: Int, grid: Array<T>) throws {
        guard (rows * columns == grid.count) else {
            throw MatrixError.Grid(rows: rows, columns: columns, gridCount: grid.count)
        }

        self.rows = rows
        self.columns = columns
        self.grid = grid
    }

    /// Constructs a new matrix using a 2D array.
    /// All columns must be the same size, otherwise an error is triggered.
    public init(_ rowsArray: Array<Array<T>>) throws {
        let rows = rowsArray.count

        guard (rows > 0) else {
            throw MatrixError.EmptyMatrix
        }

        guard (rowsArray[0].count > 0) else {
            throw MatrixError.NoMatrixColumns
        }

        let columns = rowsArray[0].count

        for subArray in rowsArray {
            guard (subArray.count == columns) else {
                throw MatrixError.DifferentMatrixColumns
            }
        }

        var grid = Array<T>()
        grid.reserveCapacity(rows * columns)

        for i in 0 ..< rows {
            for j in 0 ..< columns {
                grid.append(rowsArray[i][j])
            }
        }

        try self.init(rows: rows, columns: columns, grid: grid)
    }
}

extension Matrix: ExpressibleByArrayLiteral {
    public typealias Element = Array<T>

    /// Constructs a matrix using an array literal.
    public init(arrayLiteral elements: Element...) {
        try! self.init(elements)
    }
}

extension Matrix {
    /// Returns the transpose of the matrix.
    public var transpose: Matrix<T> {
        var result = wrapper(do: {
                                 return try Matrix(rows: self.columns, columns: self.rows, repeating: self[0, 0])
                             },
                             catch: { failure in
                                 errorLogger(failure)
                             })!

        for i in 0 ..< rows {
            for j in 0 ..< columns {
                result[j, i] = self[i, j]
            }
        }

        return result
    }

    // Provides random access for getting and setting elements using square bracket notation.
    // The first argument is the row number.
    // The first argument is the column number.
    public subscript(row: Int, column: Int) -> T {
        get {
            precondition(indexIsValidForRow(row, column: column), "Index out of range")

            return grid[(row * columns) + column]
        }
        set {
            precondition(indexIsValidForRow(row, column: column), "Index out of range")

            grid[(row * columns) + column] = newValue
        }
    }

    fileprivate func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        return (row >= 0 && row < rows && column >= 0 && column < columns)
    }
}

extension Matrix: MutableCollection {
    public typealias MatrixIndex = Int

    /// Always zero, which is the index of the first element when non-empty.
    public var startIndex: MatrixIndex {
        return 0
    }

    /// Always `rows * columns`, which is the successor of the last valid subscript argument.
    public var endIndex: MatrixIndex {
        return rows * columns
    }

    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        precondition(i < endIndex, "index must be less than endIndex")

        return i + 1
    }

    /// Provides random access to elements using the matrix back-end array coordinate
    /// in row-major order.
    /// Matrix[row, column] is preferred.
    public subscript(position: MatrixIndex) -> T {
        get {
            return self[position / columns, position % columns]
        }
        set {
            self[position / columns, position % columns] = newValue
        }
    }
}

extension Matrix: CustomStringConvertible {
    public var description: String {
        var result = "["

        for i in 0 ..< rows {
            if (i != 0) {
                result += ", "
            }

            let start = i * columns
            let end = start + columns

            result += "[" + grid[start ..< end].map { "\($0)" }.joined(separator: ", ") + "]"
        }

        result += "]"

        return result
    }
}

public func ==<T: Equatable>(lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    return (lhs.columns == rhs.columns && lhs.rows == rhs.rows && lhs.grid == rhs.grid)
}

public func !=<T: Equatable>(lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    return !(lhs == rhs)
}
