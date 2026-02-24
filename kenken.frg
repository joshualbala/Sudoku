#lang forge
option run_sterling "kenken.js"


abstract sig Operation {}

one sig Plus extends Operation {}
one sig Multiply extends Operation {}
one sig Minus extends Operation {}
one sig Divide extends Operation {}

sig Cell {
    row: one Int,
    col: one Int
}

sig Board {
    val: pfunc Cell -> Int,
    cages: set Cage
}

sig Cage {
    cells: set Cell,
    target: one Int,
    operation: one Operation
}

--------------- ENSURE TABLE IS GOOD --------------------
// checks whether val is in range
pred inRange[value: Int] {
    value >= 1 and value <= 4
}

// check that all values are in range and exist at every valid combination
pred wellformedBoard[b : Board] {
    all c: Cell | {
        (not inRange[c.row] or not inRange[c.col]) implies { no b.val[c] } 
        (inRange[c.row] and inRange[c.col]) implies {
             one i: Int | inRange[i] and b.val[c] = i
        }
    }
}

// for all valid rows, now 2 columns have the same value
pred rowsUnique[b: Board] {
  all r: Int | inRange[r] implies {
    all disj c1, c2: Cell |
      c1.row = r and c2.row = r implies b.val[c1] != b.val[c2]
  }
}

// all cols are unique
pred colsUnique[b: Board] {
  all k: Int | inRange[k] implies {
    all disj c1, c2: Cell |
      c1.col = k and c2.col = k implies b.val[c1] != b.val[c2]
  }
}


// generates a grid that is wellformed: all cells are in range, no two cells are the same, and every cell exists
pred wellformedCells {
  all c: Cell | inRange[c.row] and inRange[c.col]
  all disj c1, c2: Cell |
    c1.row != c2.row or c1.col != c2.col
  all r, k: Int | (inRange[r] and inRange[k]) implies {
    one c: Cell | c.row = r and c.col = k
  }
}


pred wellformedGrid[b : Board] {
    wellformedCells
    wellformedBoard[b]
    rowsUnique[b]
    colsUnique[b]
}

// generates a wellformed board (but other properties are messy)
WellformedBoard: run {
    some b: Board | wellformedGrid[b] 
} for exactly 1 Board, exactly 16 Cell, exactly 5 Int 


------------------------ENSURE CAGES ARE GOOD --------------------


// ensure that all cages are in board
pred cagesInBoard[b: Board] {
    all cage : Cage {
        cage in b.cages
    } 
}

// each cell is at least in one cage and at most in one cage
pred cagesPartition[b: Board] {
  all cell: Cell | some cage: b.cages | cell in cage.cells
  all cell: Cell | lone cage: b.cages | cell in cage.cells
}
