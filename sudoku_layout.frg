#lang forge/froglet

// sig Cell {
//     // row : one Int,
//     // col : one Int,
//     // subgrid : one Int,
//     val : one Int
// }

sig Board {
    board: pfunc Int -> Int -> Int
}
// sig row {}
// sig column {}
// sig subGrid {}
// sig values {}

pred wellformed[b : Board] {
    wellValues[b]
    uniqueValues[b]
    // wellRows[b]
    // wellCols[b]
    // wellSubgrid[b]
}

pred wellValues[b : Board] {
    all row, col: Int | {
        (row < 1 or row > 9 or col < 1 or col > 9) 
            implies no b.board[row][col]      
        (row >= 1 and row <= 9 and col >= 1 and col <= 9) 
            implies {
                one i: Int | i >= 1 and i <= 9 and b.board[row][col] = i
            }
    }
}

pred uniqueValues[b: Board] {
    all row1, col1, row2, col2: Int | b.board[row1][col1] = b.board[row2][col2] implies {
        (row1 = row2 and col1 = col2) or (row1 != row2 and col1 != col2)
    }
}

// pred wellRows[b : Board] {
//     // constraint that all values in the same row are different
//     all row : Int {
//         (row >= 1 and row <= 9) 
//             implies {
//                all disj col1: Int, col2: Int {
//                     (col1 >= 1 and col1 <= 9 and col2 >= 1 and col2 <= 9) 
//                         implies {
//                             b.board[row][col1].val != b.board[row][col2].val
//                         }
//                }
//             }
//     }
// }

// pred wellCols[b : Board] {
//     // constraint that all values in the same col are different
//    all col : Int {
//         (col >= 1 and col <= 9) 
//             implies {
//                all disj row1: Int, row2: Int {
//                     (row1 >= 1 and row1 <= 9 and row2 >= 1 and row2 <= 9) 
//                         implies {
//                             b.board[row1][col].val != b.board[row2][col].val
//                         }
//                }
//             }
//     }
// }

// pred wellSubgrid[b : Board] {
//     // constraint that all values in the same subgrid are different
//     all disj c1, c2: Cell | c1.subgrid = c2.subgrid implies {
//         c1.val != c2.val
//     }
// }

run { some b: Board | wellformed[b] }for exactly 1 Board, 5 Int


