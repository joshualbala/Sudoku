#lang forge/froglet

option run_sterling "sudoku.js"

sig Board {
    board: pfunc Int -> Int -> Int
}

sig Puzzle {
    pboard: pfunc Int -> Int -> Int
}

// checks whether val is in range
pred inRange[val: Int] {
    val >= 1 and val <= 4
}

// check that all values are in range and exist at every valid combination
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

//run { some b: Board | wellformed[b] }for exactly 1 Board


--------------------Solve a given Sudoku--------------------

pred given[b: Board] {
    b.board[1][1] = 4
    b.board[1][2] = 2
    b.board[2][3] = 4
    b.board[2][4] = 2
    b.board[3][1] = 1
    b.board[4][1] = 2

}

// run { some b: Board | wellformed[b] and given[b] } for exactly 1 Board

------------------Check if a given starting point has multiple solutions------------------

pred twoDifferentSolutions {
    some b1, b2: Board | wellformed[b1] and wellformed[b2] and given[b1] and given[b2] and b1 != b2
}

// run { twoDifferentSolutions } for exactly 2 Board

-------------------Generate a starting puzzle-------------------

// similar to wellvalues, but doesn't require every valid cell to have a value
pred wellPuzzleValues[puzzle: Puzzle] {
    all row, col: Int | {
        (not inRange[row] or not inRange[col]) implies { no puzzle.pboard[row][col] } 
        (inRange[row] and inRange[col] and some puzzle.pboard[row][col]) implies {
             one i: Int | inRange[i] and puzzle.pboard[row][col] = i
        }
    }
}  

// ensures that a puzzle has n values filled in
pred hasNClues[puzzle: Puzzle, n: Int] {
    # { row, col: Int | inRange[row] and inRange[col] and some puzzle.pboard[row][col] } = n
}

// ensures that a valid solution respects the puzzle's filled values
pred followsPuzzleClues[puzzle: Puzzle, solution: Board] {
    all row, col : Int | (inRange[row] and inRange[col] and some puzzle.pboard[row][col])implies {
        puzzle.pboard[row][col] = solution.board[row][col]
    }
}

// checks whether two boards are the same
pred boardsEqual[b1: Board, b2: Board] {
    all row, col : Int | inRange[row] and inRange[col] implies {
        b1.board[row][col] = b2.board[row][col]
    }
}


pred hasSolution[puzzle: Puzzle] {
    (some b: Board | wellformed[b] and followsPuzzleClues[puzzle, b])
}


// ensures that a puzzle is wellformed
pred wellformedPuzzle[puzzle : Puzzle, numClues: Int] {
    wellPuzzleValues[puzzle]
    hasNClues[puzzle, numClues]
    hasSolution[puzzle]
}

run { 
    some puzzle: Puzzle | wellformedPuzzle[puzzle, 7]
} for exactly 1 Puzzle, exactly 1 Board

