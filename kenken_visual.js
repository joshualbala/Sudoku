const stage = new Stage();

const board = instance.signature('Board').atoms()[0];
const valField = instance.field('val');
const rowField = instance.field('row');
const colField = instance.field('col');
const cagesField = instance.field('cages');
const cellsField = instance.field('cells');
const targetField = instance.field('target');
const operationField = instance.field('operation');

const colors = ['#FFB3BA','#FFDFBA','#FFFFBA','#BAFFC9','#BAE1FF','#E0BBE4'];

// Some Constants
const CELL_SIZE = 60
const GRID_SIZE = 50


const grid = new Grid({
  grid_location: {x: GRID_SIZE, y: GRID_SIZE},
  cell_size: {x_size: CELL_SIZE, y_size: CELL_SIZE},
  grid_dimensions: {x_size: 4, y_size: 4}
});
stage.add(grid);

const boardCages = board.join(cagesField).tuples();

boardCages.forEach((cageTuple, cageIndex) => {
  const cage = cageTuple.atoms()[0];
  const color = colors[cageIndex % colors.length];
  const cageCells = cage.join(cellsField).tuples();

  cageCells.forEach(cellTuple => {
    const cell = cellTuple.atoms()[0];
    const row = parseInt(cell.join(rowField).tuples()[0].atoms()[0].id());
    const col = parseInt(cell.join(colField).tuples()[0].atoms()[0].id());
    const value = board.join(valField).tuples().find(t => t.atoms()[0] === cell).atoms()[1].id();

    grid.add(
      {x: col-1, y: row-1},
      new Rectangle({
        width: CELL_SIZE,
        height: CELL_SIZE,
        color: color,
        borderColor: 'black',
        borderWidth: 2,
        label: value,
        labelSize: 18
      })
    );
  });
});

// Legend Logic
let legendY = GRID_SIZE + 4*CELL_SIZE + 20; // start below grid
boardCages.forEach((cageTuple, cageIndex) => {
  const cage = cageTuple.atoms()[0];
  const color = colors[cageIndex % colors.length];

  const target = cage.join(targetField).tuples()[0].atoms()[0].id();
  const opName = cage.join(operationField).tuples()[0]?.atoms()[0].id() || '';
  let op = '';
  if(opName.includes('Plus')) op = '+';
  else if(opName.includes('Minus')) op = '-';
  else if(opName.includes('Multiply')) op = 'x';
  else if(opName.includes('Divide')) op = '/';

  // Color box
  stage.add(new Rectangle({
    coords: {x: 50, y: legendY},
    width: 20,
    height: 30,
    color: color,
    borderColor: 'black',
    borderWidth: 1
  }));

  // Text
  stage.add(new Rectangle({
    coords: {x: 80, y: legendY},
    width: 220,
    height: 30,
    color: 'white',
    borderWidth: 0,
    label: `Cage ${cageIndex+1}: Target ${target} | Operation ${op}`,
    labelSize: 14,
    borderColor: 'black',
    borderWidth: 1
  }));

  legendY += 40;
});

stage.render(svg, document);