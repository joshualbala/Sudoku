#lang forge/froglet

option run_sterling "sudoku.js"

sig Board {
    board: pfunc Int -> Int -> Int
}


// checks whether val is in range
pred inRange[val: Int] {
    val >= 1 and val <= 4
}

// check that all values are either empty or between 1 and 9
pred wellValues[b : Board] {
    all row, col: Int | {
        (not inRange[row] or not inRange[col]) implies { no b.board[row][col] } 
        (inRange[row] and inRange[col]) implies {
             one i: Int | inRange[i] and b.board[row][col] = i
        }
    }
}

// for all valid rows, now 2 columns have the same value
pred rowsUnique[b : Board] {
    all row: Int | inRange[row] implies {
        all disj col1, col2: Int | inRange[col1] and inRange[col2] implies {
            b.board[row][col1] != b.board[row][col2]
        }
    }
}

// for all vlaid cols, no 2 rows have the same value
pred colsUnique[b : Board] {
    all col: Int | inRange[col] implies {
        all disj row1, row2: Int | inRange[row1] and inRange[row2] implies {
            b.board[row1][col] != b.board[row2][col]
        }
    }
}

// checks whether cells are in the same grid
pred sameGrid[row1: Int, col1: Int, row2: Int, col2: Int] {
    (divide[subtract[row1, 1], 2] = divide[subtract[row2, 1], 2]) and (divide[subtract[col1, 1], 2] = divide[subtract[col2, 1], 2])
}

// for all pairs of cells in the same grid, they must have different values
pred subgridUnique[b: Board] {
    all disj row1, row2 :Int, col1, col2: Int | (inRange[row1] and inRange[row2] and inRange[col1] and inRange[col2] and sameGrid[row1, col1, row2, col2]) implies {
        b.board[row1][col1] != b.board[row2][col2]
    }
}

// checks all predicates
pred wellformed[b : Board] {
    wellValues[b]
    rowsUnique[b]
    colsUnique[b]
    subgridUnique[b]
}

run { some b: Board | wellformed[b] } for exactly 1 Board


