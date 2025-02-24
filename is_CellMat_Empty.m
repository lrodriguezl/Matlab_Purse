function tf = is_CellMat_Empty(this_cell_mat)

tf =  false;
if iscell(this_cell_mat) 
    if isempty(cell2mat(this_cell_mat))
        tf = true;
    end
else
    if isempty(this_cell_mat)
        tf = true;
    end    
end  
end