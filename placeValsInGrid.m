function [new_val] = placeValsInGrid(val,I,fixed_grid)
these_cols = find(~isnan(I));
new_val = nan(1,length(fixed_grid));
new_val(these_cols)=val(I(these_cols));
end