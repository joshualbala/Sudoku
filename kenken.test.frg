#lang forge
open "kenken.frg"

test suite for inRange {
    basicSatRange1: assert inRange[1] is sat
    basicSatRange2: assert inRange[4] is sat
    basicUnsatSatRange1:assert inRange[0] is unsat
    basicUnsatSatRange2: assert inRange[5] is unsat
    basicUnsatSatRange3: assert inRange[-1] is unsat
}   

test suite for wellformedBoard {
    test expect {
        // unsat if values are out of range
        valueOutOfRangeUnsat: {
            some b: Board, c: Cell | wellformedCells and inRange[c.row] and inRange[c.col] 
            and not inRange[b.val[c]] and wellformedBoard[b]
        } is unsat

        // sat if values are out of range but no board
        valueOutOfRangeSat: {
            some b: Board, c: Cell | wellformedCells and inRange[c.row] and inRange[c.col] 
            and no b.val[c] and wellformedBoard[b]
        } is unsat
    }
}

test suite for rowsUnique {
      test expect {

        // checks a basic example assert there is a case where they have diferent columns and the same row but different boards
        differentRow: {
            some b : Board, c1, c2: Cell | c1.row != c2.row 
            and inRange[c1.row] and inRange[c1.col] and inRange[c2.row] and inRange[c2.col]
            and b.val[c1] != b.val[c2] and rowsUnique[b]
        } is sat  

        // check if uniqe values at different coordinates is sat
        differentCoordRowCheck: {
            some b : Board, c1, c2: Cell | c1.row != c2.row and c1.col != c2.col 
            and inRange[c1.row] and inRange[c1.col] and inRange[c2.row] and inRange[c2.col]
            and b.val[c1] != b.val[c2] and rowsUnique[b]
        } is sat

        // test expecting that 2 coordinates that follow in range with the same row and different cols cant be sat for unique rows
        sameRow: {
            some b : Board, c1, c2: Cell | c1.row = c2.row and c1.col != c2.col 
            and inRange[c1.row] and inRange[c1.col] and inRange[c2.row] and inRange[c2.col]
            and b.val[c1] = b.val[c2] and rowsUnique[b]
        } is unsat
    }
}

test suite for colsUnique {
    test expect {

        // there is a case where cells are in different columns and have different values
        differentCol: {
            some b : Board, c1, c2: Cell |
                c1.col != c2.col and inRange[c1.row] and inRange[c1.col]
                and inRange[c2.row] and inRange[c2.col] and b.val[c1] != b.val[c2]
                and colsUnique[b]
        } is sat  

        // different row AND different column should be fine
        differentCoordColCheck: {
            some b : Board, c1, c2: Cell |
                c1.row != c2.row and c1.col != c2.col and inRange[c1.row] and inRange[c1.col]
                and inRange[c2.row] and inRange[c2.col] and b.val[c1] != b.val[c2]
                and colsUnique[b]
        } is sat

        // same column and different rows and same value should violate colsUnique
        sameCol: {
            some b : Board, c1, c2: Cell |
                c1.col = c2.col and c1.row != c2.row and inRange[c1.row] and inRange[c1.col]
                and inRange[c2.row] and inRange[c2.col] and b.val[c1] = b.val[c2]
                and colsUnique[b]
        } is unsat
    }
}

test suite for wellformedCells{
    test expect {
        // two cells cannot share same coordinates
        duplicateCoordinatesUnsat: {
            some c1, c2: Cell | c1 != c2 and c1.row = c2.row and c1.col = c2.col and wellformedCells
        } is unsat
    }
}

test suite for cagesPartition {

  test expect {
    // a cell cannot belong to two cages
    cellInTwoCagesUnsat: {
      some b: Board, g1, g2: Cage, c: Cell | g1 != g2 and g1 in b.cages and g2 in b.cages 
      and c in g1.cells and c in g2.cells and cagesPartition[b]
    } is unsat

  }

}

test suite for cellsAdjacent {

  test expect {

    // diagonal cells are not adjacent
    diagonalNotAdjacentUnsat: {
      some c1, c2: Cell | inRange[c1.row] and inRange[c1.col] and inRange[c2.row] and inRange[c2.col]
        and c1.row != c2.row and c1.col != c2.col and cellsAdjacent[c1, c2]
    } is unsat

  }

}

test suite for cagesAreContiguous {

  test expect {

    // two non-adjacent cells cannot form a contiguous cage of size 2
    nonAdjacentCageUnsat: {
      some g: Cage, c1, c2: Cell | c1 != c2 and c1 in g.cells
        and c2 in g.cells and #{g.cells} = 2 and not cellsAdjacent[c1, c2]
        and cagesAreContiguous[g]
    } is unsat

  }

}

test suite for variedOperations {

  test expect {

    // if one operation is missing, cannot satisfy variedOperations
    missingOperationUnsat: {
      some b: Board | (some op: Operation | no g: b.cages | g.operation = op)
        and variedOperations[b]
    } is unsat

  }

}
