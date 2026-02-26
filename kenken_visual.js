div.innerHTML = '';
div.style.overflow = 'auto';

// Get the board
const boards = instance.signature('Board').atoms();
if (boards.length === 0) {
    div.innerHTML = '<p style="color: red;">No board found!</p>';
} else {
    const board = boards[0];
    const valField = instance.field('val');
    const cagesField = instance.field('cages');
    const cellsField = instance.field('cells');
    const targetField = instance.field('target');
    const operationField = instance.field('operation');
    
    // Get all cells
    const allCells = instance.signature('Cell').atoms();
    const rowField = instance.field('row');
    const colField = instance.field('col');
    
    // Get all cages for this board
    const boardCages = board.join(cagesField).tuples();
    
    // Color palette for cages
    const colors = [
        '#FFB3BA', '#FFDFBA', '#FFFFBA', '#BAFFC9',
        '#BAE1FF', '#E0BBE4', '#FFDFD3', '#C7CEEA'
    ];
    
    // Map each cage to a color and get cage info
    const cageMap = {};  // Maps "row,col" to {color, cageIndex}
    const cageInfo = [];  // Stores {color, target, operation}
    
    boardCages.forEach((cageTuple, index) => {
        const cage = cageTuple.atoms()[0];
        const color = colors[index % colors.length];
        
        // Get cells in this cage
        const cageCells = cage.join(cellsField).tuples();
        
        // Get target
        const targetTuples = cage.join(targetField).tuples();
        const target = targetTuples.length > 0 ? targetTuples[0].atoms()[0].id() : '?';
        
        // Get operation
        const opTuples = cage.join(operationField).tuples();
        let operation = '?';
        if (opTuples.length > 0) {
            const opName = opTuples[0].atoms()[0].id();
            if (opName.includes('Plus')) operation = '+';
            else if (opName.includes('Minus')) operation = '-';
            else if (opName.includes('Multiply')) operation = '×';
            else if (opName.includes('Divide')) operation = '÷';
        }
        
        // Store cage info
        cageInfo.push({color, target, operation});
        
        // Map cells to this cage
        cageCells.forEach(cellTuple => {
            const cell = cellTuple.atoms()[0];
            const rowTuples = cell.join(rowField).tuples();
            const colTuples = cell.join(colField).tuples();
            
            if (rowTuples.length > 0 && colTuples.length > 0) {
                const row = parseInt(rowTuples[0].atoms()[0].id());
                const col = parseInt(colTuples[0].atoms()[0].id());
                cageMap[`${row},${col}`] = {color, cageIndex: index};
            }
        });
    });
    
    // Create table
    const table = document.createElement('table');
    table.style.borderCollapse = 'collapse';
    table.style.margin = '20px';
    
    for (let row = 1; row <= 4; row++) {
        const tableRow = document.createElement('tr');
        
        for (let col = 1; col <= 4; col++) {
            // Find the cell and its value
            let cellValue = '';
            for (const cell of allCells) {
                const rowTuples = cell.join(rowField).tuples();
                const colTuples = cell.join(colField).tuples();
                
                if (rowTuples.length > 0 && colTuples.length > 0) {
                    const cellRow = parseInt(rowTuples[0].atoms()[0].id());
                    const cellCol = parseInt(colTuples[0].atoms()[0].id());
                    
                    if (cellRow === row && cellCol === col) {
                        const valTuples = board.join(valField).tuples();
                        for (const valTuple of valTuples) {
                            const atoms = valTuple.atoms();
                            if (atoms[0] === cell) {
                                cellValue = atoms[1].id();
                                break;
                            }
                        }
                        break;
                    }
                }
            }
            
            // Create cell
            const tableData = document.createElement('td');
            tableData.style.width = '60px';
            tableData.style.height = '60px';
            tableData.style.textAlign = 'center';
            tableData.style.verticalAlign = 'middle';
            tableData.style.border = '2px solid black';
            tableData.style.fontSize = '24px';
            tableData.style.fontWeight = 'bold';
            tableData.style.position = 'relative';
            
            // Color based on cage
            const cageData = cageMap[`${row},${col}`];
            if (cageData) {
                tableData.style.backgroundColor = cageData.color;
                
                // Add cage label in top-left corner (first cell only)
                const info = cageInfo[cageData.cageIndex];
                const isFirstInCage = Object.keys(cageMap).find(key => {
                    const data = cageMap[key];
                    return data.cageIndex === cageData.cageIndex;
                }) === `${row},${col}`;
                
                if (isFirstInCage) {
                    const label = document.createElement('div');
                    label.textContent = `${info.target}${info.operation}`;
                    label.style.position = 'absolute';
                    label.style.top = '2px';
                    label.style.left = '4px';
                    label.style.fontSize = '10px';
                    label.style.fontWeight = 'bold';
                    tableData.appendChild(label);
                }
            }
            
            tableData.textContent = cellValue;
            tableRow.appendChild(tableData);
        }
        
        table.appendChild(tableRow);
    }
    
    div.appendChild(table);
    
    // Create legend
    const legend = document.createElement('div');
    legend.style.margin = '20px';
    legend.style.fontFamily = 'Arial, sans-serif';
    
    const legendTitle = document.createElement('div');
    legendTitle.textContent = 'Cages:';
    legendTitle.style.fontWeight = 'bold';
    legendTitle.style.marginBottom = '10px';
    legend.appendChild(legendTitle);
    
    cageInfo.forEach((info, index) => {
        const item = document.createElement('div');
        item.style.marginBottom = '5px';
        
        const colorBox = document.createElement('span');
        colorBox.style.display = 'inline-block';
        colorBox.style.width = '20px';
        colorBox.style.height = '20px';
        colorBox.style.backgroundColor = info.color;
        colorBox.style.border = '1px solid black';
        colorBox.style.marginRight = '10px';
        
        const text = document.createElement('span');
        text.textContent = `Cage ${index + 1}: ${info.target}${info.operation}`;
        
        item.appendChild(colorBox);
        item.appendChild(text);
        legend.appendChild(item);
    });
    
    div.appendChild(legend);
}