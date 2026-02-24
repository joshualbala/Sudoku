# Sudoku

## Project Objective

Our goal for this project was to model a sudoku. We then built off this idea by then modeling a KenKen puzzle as well. 
The goal for our sudoku model was to construct a grid that satisfied the constraints of a standard sudoku puzzle - values
cannot be repeated in the same row, column or subgrid. We also hoped to generate puzzles that contain only unique solutions,
but following this [Ed post and Tim's response](https://edstem.org/us/courses/91634/discussion/7707835), it seemed like this 
was not possible. We instead decided to extend our Sudoku model by creating a KenKen model that uses similar properties. 
For time constraints, we made the Sudoku board 4x4 as well since it worked quicker although that can be modified to a 9x9
simply by changing the 4->9 in inRange and the 2->3 in sameGrid. 

## Model Visualization and Choices


## Signatures and Predicates

### sudoku_layout.frg

### sigs
Board: Represents a generic sudoku board. Contains a mapping of (row, col) -> int to represent values for each grid. 
Puzzle: Basically the same as board. It made more sense making it distinct when we were trying to generate puzzles that
only corresponded to one unique solution (which the board would represent), but we kept it because it was easier to 
verify and still match a solution to. 

### Predicates 

#### Basic Sudoku: 
inRange -> Checks whether a value is in the range of valid values for a sudoku. Again, we made this 1-4 so that it would run quicker. 
wellValues -> Ensures that invalid row and col vals don't exist and valid row and col vals map to exactly one value that's valid. 
rowsUnique, colsUnique -> Ensure that each value occurs only once in each row and column respectively 
sameGrid -> Checks whether a (row, col) pair is in the same subgrid as another (row, col) pair. We do this by taking advantage of Forge's
            integer division properties. 
subgridUnique -> Uses sameGrid to ensure that each value occurs only once in each subGrid. 
wellformed -> Uses wellValues, rowsUnique, colsUnique, and subgridUnique to come up with a valid Sudoku grid. 
GenerateSudoku -> Runs wellformed for a grid. 

#### Solve Given Sudoku: 
given -> Populate a sudoku with some pre-determined values. Then solve the Sudoku such that it respects the starting state. 
SolvePreconfiguredSudoku -> Runs given and wellformed to solve a Sudoku given an initial state. 

#### Solve 2 Solutions:
twoDifferentSolutions -> Comes up with 2 different solutions to the same grid. 
TwoDifferentSolutions -> Runs twoDifferentSolutions


#### Generate and Solve a Random Sudoku
wellPuzzleValues -> Similar to wellValues but doesn't require a value at all valid rows and columns. 
hasNClues -> Ensure that a puzzle has at least some `n` clues
followsPuzzleClues -> Ensures that a solution respects the initial clues the puzzle came with. 
hasSolution -> Finds a board (solution) to a particular board using followsPuzzleClues. 
wellformedPuzzle -> Uses wellPuzzleValues, hasNClues, and hasSolution to generate a valid puzzle. 
GeneratePuzzleAndSolution -> Generates and solves a puzzle. Can be seen in the custom visualizer. 

### kenken.frg

### sigs

Operation -> Represents an abstract operation type
Plus, Minus, Multiply, Divide -> Represent the 4 types of operations in KenKen
Cell -> Each cell in the KenKen grid (different from Sudoku here!)
Board -> Maps each Cell to a value. Also contains a set of cages that represent the cages in a kenken grid. 
Cage -> Represents each cage. It's associated with an operation, a target, and the set of cells belonging to it. 

### Predicates

inRange -> Same as before
wellformedBoard -> Ensures cells only exist at valid (row, col) tuples and that the cell's value is valid. 
rowsUnique, colsUnique -> Same as before
wellformedCells -> Ensures all cells are have valid row and col values and that no 2 cells exist at the same place
wellformedGrid -> A grid is wellformed if the cells are wellformed (wellformedCells) and it satisfies wellformedBoard, 
                  rowsUnique and colsUnique. 
WellformedBoard -> Runs a wellformedGrid. This run command produces some weird visualization becaue we haven't defined
                  cages yet so it's technically not a valid KenKen but its still useful as a sanity check.


cagesInBoard -> Ensures that all cages exist within the board. 
cagesPartition -> Ensures that all cells are in cages, only in 1 cage, and no more than 1 cage. 
cellsAdjacent -> Helper predicate to check if any 2 cells are adjacent (they share either row or col)
cagesAreContiguous
cagePlusOk -> Sums up a list of cell values and verifies that it's equal to the target for that cage. 
cageMultiplyOk -> Multiplies up the 2 cells for a Multiply cage and verifies that the product is equal to the target. 
cageMinusOk -> Subtracts the two values from each other (both directions) and sees if it matches the target. 
cageDivideOk -> Verifies that the division of 2 vals is the target, and since forge uses integer division we also need
                to check that the product of the target and one of the vals matches the other. 
cagesCorrect -> Defines what it means for a cage to be correct. Depending on the operation, the respective operationOk
                predicate is met. For non-Plus operations, we restrict the cage size to 2 because we couldn't find 
                aggregator functions that would allow for a computation across sets like we did for sum. We also ensure the
                target is between 1 and 16 (arbitrary) and that the cells in the cages are contiguous. 
variedOperations -> Ensures that all operations are at least in 1 cage. 
WellformedKenKen -> Generates a wonderful KenKen! We arbitrarily settled on 6 cages. 

## Testing


## Project Files
sudoku_layout.frg -> models a Sudoku grid
kenken.frg -> models a KenKen 4x4 grid
sudoku_layout.test.frg -> tests for Sudoku
___________ -> test for KenKen
