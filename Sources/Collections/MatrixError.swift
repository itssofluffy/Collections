/*
    MatrixError.swift

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

public enum MatrixError: Error {
    case Rows(rows: Int)
    case Columns(columns: Int)
    case Grid(rows: Int, columns: Int, gridCount: Int)
    case EmptyMatrix
    case NoMatrixColumns
    case DifferentMatrixColumns
}

extension MatrixError: CustomStringConvertible {
    public var description: String {
        switch self {
            case .Rows(let rows):
                return "Invalid number of rows (\(rows))"
            case .Columns(let columns):
                return "Invalid number of columns (\(columns))"
            case .Grid(let rows, let columns, let gridCount):
                return "Can't create matrix - grid.count of \(gridCount) must equal rows (\(rows)) * columns (\(columns))"
            case .EmptyMatrix:
                return "Can't create an empty matrix"
            case .NoMatrixColumns:
                return "Can't create a matrix column with no elements"
            case .DifferentMatrixColumns:
                return "Can't create a matrix with different sized columns"
        }
    }
}
