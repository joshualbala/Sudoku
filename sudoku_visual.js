
const stage = new Stage()

// Get the single Board atom
const boardAtom = instance.signature('Board').atoms()[0]

// Create 4x4 grid
let grid = new Grid({
  grid_location: {x: 50, y: 50},
  cell_size: {x_size: 60, y_size: 60},
  grid_dimensions: {x_size: 4, y_size: 4}
})

stage.add(grid)

// Get all tuples of board relation
const tuples = instance.field('board').tuples()

for (let row = 1; row <= 4; row++) {
  for (let col = 1; col <= 4; col++) {

    let value = ""

    for (let t of tuples) {
      const atoms = t.atoms()

      if (
        atoms[0].id() === boardAtom.id() &&
        parseInt(atoms[1].id()) === row &&
        parseInt(atoms[2].id()) === col
      ) {
        value = atoms[3].id()
      }
    }

    grid.add(
      {x: col - 1, y: row - 1},
      new Rectangle({
        width: 60,
        height: 60,
        borderColor: "black",
        color: "white",
        borderWidth: 1,
        label: value,
        labelSize: 24
      })
    )
  }
}

stage.render(svg, document)