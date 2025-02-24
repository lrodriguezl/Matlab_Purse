function [normalized_vector_idx, normalized_vector_val] = sampleAvector...
    (dataIdx,dataVal,...
    dataGrid,...
    samplingMode,varargin)
% Input:
%     [n x 1] vector of indices
%     [n x 1] vector of values
%     [1 x m] grid
%     int     sampling mode: random, gven index, average, min, max
% output:
%     [1 x m] indices of sampled vector 
%     [1 x m] values of sampled vector 
%   it creates a new vector that has as many elements as specified by
%   the grid and contains samples from the original vector
%
%%
normalized_vector_idx = nan(1,length(dataGrid));
normalized_vector_val = nan(1,length(dataGrid));
%% get index of all values in the segment that are not NAN
ind_non_nan_vals_in_seg = find(~isnan(dataVal));

%% create mormalized time vector for segment
stepsize = dataGrid(2) - dataGrid(1);
max_val = length(dataIdx)-1;
range= 0:max_val;
% normalized time vector
t_norm = 100.*(range./max_val);
% since different segments could have different stepsize in their
% normalized time vector a quantized vector is then created
% for easier comparison between segments

% normalized and quantized time vector(time grid)
t_grid = quantize_data(t_norm,stepsize,'round');

%% get the time cells in the grid that have non-nan values associated
% with them
t_grid_with_non_nan_val = t_grid(ind_non_nan_vals_in_seg);
% the values of available (not nan) values in the segment
non_nan_val_in_seg = dataVal(ind_non_nan_vals_in_seg);
orig_idx_non_nan_val_in_seg = dataIdx(ind_non_nan_vals_in_seg);

% assign each value to the appropriate cell position in the
% time grid
% find the column numbers that have non nan values
[unique_t_grid_with_non_nan_val, uidx] =  unique(t_grid_with_non_nan_val);
these_cols = find(ismember(dataGrid,unique_t_grid_with_non_nan_val));
% populate the xTrack matrix with the appropriate columns
normalized_vector_val(1,these_cols) = non_nan_val_in_seg(uidx);

% populate the xTrack index matrix with the appropriate columns
normalized_vector_idx(1,these_cols) = orig_idx_non_nan_val_in_seg(uidx);

%% check if any of the available non nan values fall in the same time
% cells in the quantized time grid

if any(diff(t_grid_with_non_nan_val)==0)
    % some of the available non nan values fall in the same time
    % grid
    % T = 0 10 30 30 30 50 70 70 100
    % T_diff = diff(T)= 10 20 0 0 20 20 0 30
    % index of T_diff where element is zero = 3 4 7
    idx1 = find(diff(t_grid_with_non_nan_val)==0);
    % index of T where elements are repeated =
    %          T_repeat = 3 4 5 7 8 = sort(unique([T_diff T_diff + 1]))
    ind_of_cell_with_many_vals = sort(unique([idx1 idx1+1]));
    % repeated values of T = 30 70 = unique(T(T_repeat))
    time_cells_with_many_vals = unique(t_grid_with_non_nan_val(ind_of_cell_with_many_vals));
    
    %%
    for m=1:length(time_cells_with_many_vals)
        % get indices of time cell that have multiple non nan values
        idx_m = find(t_grid_with_non_nan_val==time_cells_with_many_vals(m));
        switch samplingMode
            case 1
                % randomly select one of the indices
                sampleIdx = randi([1,length(idx_m)],1);
                % get the columns to which the current time cell with repeated
                % values corresponds to
                col1 = find(ismember(dataGrid,time_cells_with_many_vals(m)));
                % store the non nan value randomly selected from this cell
                normalized_vector_val(1,col1) = non_nan_val_in_seg(idx_m(sampleIdx));
                normalized_vector_idx(1,col1) = orig_idx_non_nan_val_in_seg(idx_m(sampleIdx));
            case 2
                % provide sample index
                if ~isempty(varargin{1})
                    sampleIdx = max(min(varargin{1},length(idx_m)),1);
                else
                    % randomly select one of the indices
                    sampleIdx = randi([1,length(idx_m)],1);
                end
                % get the columns to which the current time cell with repeated
                % values corresponds to
                col1 = find(ismember(dataGrid,time_cells_with_many_vals(m)));
                % store the non nan value randomly selected from this cell
                normalized_vector_val(1,col1) = non_nan_val_in_seg(idx_m(sampleIdx));
                normalized_vector_idx(1,col1) = orig_idx_non_nan_val_in_seg(idx_m(sampleIdx));
            case 3
                % use average of samples within the grid cell
                % get the columns to which the current time cell with repeated
                % values corresponds to
                col1 = find(ismember(dataGrid,time_cells_with_many_vals(m)));
                % store the non nan value randomly selected from this cell
                normalized_vector_val(1,col1) = mean(non_nan_val_in_seg(idx_m));
                normalized_vector_idx(1,col1) = nan;
            case 4
                % use max value within the grid cell
                % get the columns to which the current time cell with repeated
                % values corresponds to
                col1 = find(ismember(dataGrid,time_cells_with_many_vals(m)));
                % store the non nan value randomly selected from this cell
                normalized_vector_val(1,col1) = max(non_nan_val_in_seg(idx_m));
                normalized_vector_idx(1,col1) = nan;
            case 5
                % use min value within the grid cell
                % get the columns to which the current time cell with repeated
                % values corresponds to
                col1 = find(ismember(dataGrid,time_cells_with_many_vals(m)));
                % store the non nan value randomly selected from this cell
                normalized_vector_val(1,col1) = min(non_nan_val_in_seg(idx_m));
                normalized_vector_idx(1,col1) = nan;
            otherwise
                % randomly select one of the indices
                sampleIdx = randi([1,length(idx_m)],1);
                % get the columns to which the current time cell with repeated
                % values corresponds to
                col1 = find(ismember(dataGrid,time_cells_with_many_vals(m)));
                % store the non nan value randomly selected from this cell
                normalized_vector_val(1,col1) = non_nan_val_in_seg(idx_m(sampleIdx));
                normalized_vector_idx(1,col1) = orig_idx_non_nan_val_in_seg(idx_m(sampleIdx));
        end
        
    end
end