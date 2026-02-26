#lang forge/froglet

open "sudoku_layout.frg"

--------------- TESTS FOR SUDOKU LAYOUT ---------------------

// test suite for inRange {
//     assert inRange[1] is sat
//     assert inRange[4] is sat
//     assert inRange[0] is unsat
//     assert inRange[5] is unsat
//     assert inRange[10] is unsat
// }   

test suite for wellValues {
    assert {all b: Board | wellValues[b]} is sat

    example correctVales is wellValues for {
        
    }

}

// test suite for rowsUnique {
//     assert {all b: Board | rowsUnique[b]} is sat
// }

// test suite for colsUnique {
//     assert {all b: Board | colsUnique[b]} is sat
// }

// test suite for subgridUnique {
//     assert {all b: Board | subgridUnique[b]} is sat
// }

// test suite for sameGrid {
//     assert sameGrid[1, 1, 2, 2] is sat
//     assert sameGrid[1, 1, 3, 3] is unsat
// }

// test suite for wellformed {
//     assert { all b: Board | wellformed[b] } is sat
// }

