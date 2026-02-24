#lang forge

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
  all row, col: Int | (inRange[row] and inRange[col]) implies {
    one c: Cell | c.row = row and c.col = col
  }
}


pred wellformedGrid[b : Board] {
    wellformedCells
    wellformedBoard[b]
    rowsUnique[b]
    colsUnique[b]
}

// generates a wellformed board (but other properties are messy, doen't really matter)
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

// checks if cells are adjacent
pred cellsAdjacent[c1: Cell, c2: Cell] {
    (c1.row = c2.row) and (add[c1.col, 1] = c2.col or subtract[c1.col, 1] = c2.col) or
    (c1.col = c2.col) and (add[c1.row, 1] = c2.row or subtract[c1.row, 1] = c2.row)
}

// all cells in a cage are contiguous
pred cagesAreContiguous[cage: Cage] {
    let adjInCage = { c1, c2: cage.cells | cellsAdjacent[c1, c2] } | {
        all disj c1, c2: cage.cells | c2 in c1.^adjInCage
    }
}

// the sum of all cell vals must be the target
pred cagePlusOk[b: Board, cage: Cage] {
  (sum c: cage.cells | b.val[c]) = cage.target
}

// no times predicate, so we just multiply two vals and check if its equal to target
pred cageMultiplyOk[b: Board, cage: Cage] {
  some disj c1, c2: cage.cells | multiply[b.val[c1], b.val[c2]] = cage.target
}


// check subtraction in both directions and compare to target
pred cageMinusOk[b: Board, cage: Cage] {
  some disj c1, c2: cage.cells |
    subtract[b.val[c1], b.val[c2]] = cage.target or
    subtract[b.val[c2], b.val[c1]] = cage.target
}

// do same as minus, but need to verify the multiplication product since forge does integer division
pred cageDivideOk[b: Board, cage: Cage] {
  some disj c1, c2: cage.cells | {
    (divide[b.val[c1], b.val[c2]] = cage.target and multiply[cage.target, b.val[c2]] = b.val[c1]) or
    (divide[b.val[c2], b.val[c1]] = cage.target and multiply[cage.target, b.val[c1]] = b.val[c2])
  }
}

// for each cage, check the corresponding operation pred is correce. Limit to 2 cells for non-plus. 
//  Target is positive between 1 and 16
pred cagesCorrect[b: Board] {
  all g: b.cages | {
    g.operation = Plus implies cagePlusOk[b, g]
    g.operation = Multiply implies {
       cageMultiplyOk[b, g]
       #{g.cells} = 2
    }
    g.operation = Minus implies {
       cageMinusOk[b, g]
       #{g.cells} = 2
    }
    g.operation = Divide implies {
      cageDivideOk[b, g]
      #{g.cells} = 2
    }
    g.target >= 1 and g.target <= 16  
    cagesAreContiguous[g]
  }
}

// at least one cage for each operation
pred variedOperations[b: Board] {
    all op: Operation | {
        some cage: b.cages | cage.operation = op
    }
}

// all together
WellformedKenKen: run {
  some b: Board | {
    wellformedGrid[b]
    cagesInBoard[b]
    cagesPartition[b]
    cagesCorrect[b]
    variedOperations[b]
  }
} for exactly 1 Board, exactly 16 Cell, exactly 6 Cage, 6 Int
