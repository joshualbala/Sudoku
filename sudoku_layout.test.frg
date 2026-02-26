#lang forge/froglet

open "sudoku_layout.frg"

--------------- TESTS FOR SUDOKU LAYOUT ---------------------

test suite for inRange {
    basicSatRange1: assert inRange[1] is sat
    basicSatRange2: assert inRange[4] is sat
    basicUnsatSatRange1:assert inRange[0] is unsat
    basicUnsatSatRange2: assert inRange[5] is unsat
}   

test suite for wellValues {

    // uses test expect with some row and col where one of the coordinates doesnt agree with inRange is unsat for wellValues
    test expect {
        outOfRangeUnsatValues: {
            some b: Board, row, col: Int |
            (not inRange[row] or not inRange[col]) and some b.board[row][col] and wellValues[b]
        } is unsat
    }

    // Check that every valid cell has at least one value
    test expect {
        allCellsHaveValue: {
            some b: Board, row, col: Int, i: Int |
            (inRange[row] and inRange[col] and inRange[i]) and b.board[row][col] = i
        } is sat
    }
}

test suite for rowsUnique {

    test expect {

        // checks a basic example assert there is a case where they have diferent columns and the same row but different boards
        differentRow: {
            some b : Board, row, col, col2: Int | col != col2 and inRange[row] and inRange[col] and inRange[col2]
            and b.board[row][col] != b.board[row][col2] and rowsUnique[b]
        } is sat  

        // check if uniqe values at different coordinates is sat
        differentCoordRowCheck: {
            some b : Board, row, row2, col, col2: Int | row != row2 and col != col2 
            and inRange[row] and inRange[row2] and inRange[col] and inRange[col2]
            and b.board[row][col] != b.board[row2][col2] and rowsUnique[b]
        } is sat

         // test expecting that 2 coordinates that follow in range with the same row and different cols cant be sat for unique rows
        sameRow: {
            some b : Board, row, col, col2: Int | col != col2 and inRange[row] and inRange[col] and inRange[col2]
            and b.board[row][col] = b.board[row][col2] and rowsUnique[b]
        } is unsat  

        // verifys that rowsUnique only works for inRange ints by assert sat for an typically unsat case if all vals were in range
        sameRowNotInRange: {
            some b : Board, row, col, col2: Int | col != col2 and b.board[row][col] = b.board[row][col2] and rowsUnique[b]
        } is sat
    }
}

test suite for colsUnique {

    test expect {
        // checks a basic example: different rows, same column, values are different
        differentCol: {
            some b : Board, col, row, row2: Int | row != row2 and inRange[row] and inRange[row2] and inRange[col]
            and b.board[row][col] != b.board[row2][col] and colsUnique[b]
        } is sat  

        // check if unique values at different coordinates is sat
        differentCoordColCheck: {
            some b : Board, row, row2, col, col2: Int | row != row2 and col != col2
            and inRange[row] and inRange[row2] and inRange[col] and inRange[col2]
            and b.board[row][col] != b.board[row2][col2] and colsUnique[b]
        } is sat

        // test expecting that 2 coordinates in the same column and different rows can't be equal for unique columns
        sameCol: {
            some b : Board, col, row, row2: Int | row != row2 and inRange[row] and inRange[row2] and inRange[col]
            and b.board[row][col] = b.board[row2][col] and colsUnique[b]
        } is unsat  

        // verifies that colsUnique only works for inRange ints by asserting sat for an out-of-range case
        sameColNotInRange: {
            some b : Board, col, row, row2: Int | row != row2 and b.board[row][col] = b.board[row2][col] and colsUnique[b]
        } is sat
    }
}

test suite for subgridUnique {

    test expect {
        // Two cells in the same subgrid with different values should be satisfiable
        differentSubgridValues: {
            some b: Board, row1, row2, col1, col2: Int |
            inRange[row1] and inRange[row2] and inRange[col1] and inRange[col2] 
            and sameGrid[row1, col1, row2, col2] 
            and b.board[row1][col1] != b.board[row2][col2] 
            and subgridUnique[b]
        } is sat

        // Two cells in the same subgrid with same value should be unsat
        sameSubgridValues: {
            some b: Board, row1, row2, col1, col2: Int |
            inRange[row1] and inRange[row2] and inRange[col1] and inRange[col2]
            and sameGrid[row1, col1, row2, col2]
            and row1 != row2 or col1 != col2
            and b.board[row1][col1] = b.board[row2][col2]
        } is unsat
    }
}

test suite for sameGrid {
    basicSameGridSat: assert sameGrid[1, 1, 2, 2] is sat
    basicSameGridUnsat: assert sameGrid[1, 1, 3, 3] is unsat
}

test suite for wellformed {
    assert { all b: Board | wellformed[b] } is sat
    assert {no b: board | wellformed[b]} is unsat
}   

test suite for wellPuzzleValues {

}

test suite for hasNClues {
    
}

test suite for hasSolution {
    
}

test suite for WellformedPuzzle{
    
}

