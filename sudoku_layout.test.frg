#lang forge/froglet

open "sudoku_layout.frg"

test suite for inRange {
    assert inRange[1] is sat
    assert inRange[4] is sat
    assert inRange[0] is unsat
    assert inRange[5] is unsat
}   

test suite for wellValues {
    // assert { some b: Board | wellValues[b] } is sat for exactly 1 Board
    assert {all b: Board | wellValues[b]} is sat
}

test suite for rowsUnique {
    // assert { some b: Board | rowsUnique[b] } is sat for exactly 1 Board
    assert {all b: Board | rowsUnique[b]} is sat
}

test suite for colsUnique {
    // assert { some b: Board | colsUnique[b] } is sat for exactly 1 Board
    assert {all b: Board | colsUnique[b]} is sat
}

test suite for subgridUnique {
    // assert { some b: Board | subgridUnique[b] } is sat for exactly 1 Board
    assert {all b: Board | subgridUnique[b]} is sat
}

test suite for sameGrid {
    assert sameGrid[1, 1, 2, 2] is sat
    assert sameGrid[1, 1, 3, 3] is unsat
}

test suite for wellformed {
    assert { all b: Board | wellformed[b] } is sat
    // assert {all b: Board | wellformed[b] and not rowsUnique[b]} is unsat
    // assert {all b: Board | wellformed[b] and not colsUnique[b]} is unsat
    // assert {all b: Board | wellformed[b] and not subgridUnique[b]} is unsat
}

