div.innerHTML = '';
div.style.overflow = 'auto';

// Get the board
const boards = instance.signature('Board').atoms();
if (boards.length === 0) {
    div.innerHTML = '<p style="color: red;">No board found!</p>';
} else {
    const board = boards[0];
    const boardField = instance.field('board');
    const boardData = board.join(boardField).tuples();
    
    // Create table element
    const table = document.createElement('table');
    table.style.borderCollapse = 'collapse';
    table.style.margin = '20px';
    
    for (let row = 1; row <= 4; row++) {
        const tableRow = document.createElement('tr');
        
        for (let col = 1; col <= 4; col++) {
            // Find value for this cell
            let cellValue = '';
            for (const tuple of boardData) {
                const atoms = tuple.atoms();
                const tupleRow = parseInt(atoms[0].id());
                const tupleCol = parseInt(atoms[1].id());
                const tupleVal = atoms[2].id();
                
                if (tupleRow == row && tupleCol == col) {
                    cellValue = tupleVal;
                    break;
                }
            }
            
            // Create cell
            const tableData = document.createElement('td');
            tableData.style.width = '60px';
            tableData.style.height = '60px';
            tableData.style.textAlign = 'center';
            tableData.style.verticalAlign = 'middle';
            tableData.style.border = '1px solid black';
            tableData.style.fontSize = '24px';
            tableData.style.fontWeight = 'bold';
            
            tableData.textContent = cellValue;
            tableRow.appendChild(tableData);
        }
        
        table.appendChild(tableRow);
    }
    
    div.appendChild(table);
}