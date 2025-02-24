function [xTrack_mat,xTrack_idx_mat,stable_turns]=...
                        Find_Stable_Segments(segments_list,flight_mode,...
                                              xTrack,climb_tag,...
                                              level_tag, descent_tag,...
                                              varargin)
%% Normalize Segments
% Find stable segments: segments where flight mode and vertical profile
% conditions don't change for the complete duration of the segment                                          
%%
fixed_grid =0:10:100;
if ~isempty(varargin)
    min_segment_length = varargin{1};
else
    min_segment_length = 3;
end

xTrack_mat= nan(length(segments_list),length(fixed_grid));
xTrack_idx_mat = nan(length(segments_list),length(fixed_grid));

climb_tag_mat = nan(length(segments_list),length(fixed_grid));
level_tag_mat = nan(length(segments_list),length(fixed_grid));
descent_tag_mat = nan(length(segments_list),length(fixed_grid));

stable_seg_in_climb = false(length(segments_list),1);
stable_seg_in_level = false(length(segments_list),1);
stable_seg_in_descent = false(length(segments_list),1);

%%
for k=1:length(segments_list)
    
    seg_k = segments_list{k}(1):segments_list{k}(2);
    all_pts_in_seg_k_are_in_same_Flight_mode = all(flight_mode(seg_k));
      
    if all_pts_in_seg_k_are_in_same_Flight_mode && length(seg_k)>= min_segment_length
        %% get the xTrack and vertical profile tag values in the turn

        xTrack_val_in_seg = xTrack(seg_k)';

        climb_tag_val_in_seg = climb_tag(seg_k)';
        level_tag_val_in_seg = level_tag(seg_k)';
        descent_tag_val_in_seg = descent_tag(seg_k)';
        
        %% tag stable turns
        stable_seg_in_climb(k) = all(climb_tag_val_in_seg);
        stable_seg_in_level(k) = all(level_tag_val_in_seg);
        stable_seg_in_descent(k) = all(descent_tag_val_in_seg);        
       
        %% get index of all xTrack values in the turn that are not NAN
        not_nan_xTrack_in_seg_idx = find(~isnan(xTrack_val_in_seg));        
        
        %% create mormalized time vector for turn
        range = length(seg_k)-1;
        vec= 0:range;
        % normalized vector
        t_norm = 100.*(vec./vec(end));
        % since different turns could have different stepsize in their
        % normalized time vector a quantized vector is then created
        % for easier comparison between turns
        
        % normalized and quantized time vector / time grid
        t_grid = quantize_data(t_norm,10,'round');
        
        %% get the time cells in the grid that have xTrack values associated
        % with them
        t_grid_with_xTrack_val = t_grid(not_nan_xTrack_in_seg_idx);
        % the values of available (not nan) xTrack in the turn
        not_nan_xTrack_in_seg_val = xTrack_val_in_seg(not_nan_xTrack_in_seg_idx);
        orig_idx_not_nan_xTrack_in_seg = seg_k(not_nan_xTrack_in_seg_idx);

        climb_tag_not_nan_xTrack_in_seg_val = climb_tag_val_in_seg(not_nan_xTrack_in_seg_idx);
        level_tag_not_nan_xTrack_in_seg_val = level_tag_val_in_seg(not_nan_xTrack_in_seg_idx);
        descent_tag_not_nan_xTrack_in_seg_val = descent_tag_val_in_seg(not_nan_xTrack_in_seg_idx);
        
        % assign each xtrack value to the appropriate cell position in the
        % time grid
        % find the column numbers that have xTrack values
        [unique_t_grid_with_xTrack_val uidx] =  unique(t_grid_with_xTrack_val);
        these_cols = find(ismember(fixed_grid,unique_t_grid_with_xTrack_val));
        % populate the xTrack matrix with the appropriate columns
        xTrack_mat(k,these_cols) = not_nan_xTrack_in_seg_val(uidx);
        
        % populate the xTrack index matrix with the appropriate columns
        xTrack_idx_mat(k,these_cols) = orig_idx_not_nan_xTrack_in_seg(uidx);
        
        % populate the vertical profile matrices with the appropriate columns
        climb_tag_mat(k,these_cols) = climb_tag_not_nan_xTrack_in_seg_val(uidx);
        level_tag_mat(k,these_cols) = level_tag_not_nan_xTrack_in_seg_val(uidx);
        descent_tag_mat(k,these_cols) = descent_tag_not_nan_xTrack_in_seg_val(uidx);
        %% check if any of the available xTrack values fall in the same time
        % cells in the quantized time grid
        
        if any(diff(t_grid_with_xTrack_val)==0)
            % some of the available xTrack values fall in the same time
            % grid
            idx1 = find(diff(t_grid_with_xTrack_val)==0);
            repeat_idx = sort(unique([idx1 idx1+1]));
            time_cells_with_repeated_val = unique(t_grid_with_xTrack_val(repeat_idx));
            
            %%
            for m=1:length(time_cells_with_repeated_val)
                % get indices of time cell that have repeated xTrack values
                idx_m = find(t_grid_with_xTrack_val==time_cells_with_repeated_val(m));
                % randomly select one of the indices
                rnd_idx= randi([1,length(idx_m)],1);
                % get the columns to which the current time cell with repeated
                % values corresponds to
                col1 = find(ismember(fixed_grid,time_cells_with_repeated_val(m)));
                % store the xTrack value randomly selected from this cell
                xTrack_mat(k,col1) = not_nan_xTrack_in_seg_val(idx_m(rnd_idx));
               
                xTrack_idx_mat(k,col1) = orig_idx_not_nan_xTrack_in_seg(idx_m(rnd_idx));
                
                climb_tag_mat(k,these_cols) = climb_tag_not_nan_xTrack_in_seg_val(idx_m(rnd_idx));
                level_tag_mat(k,these_cols) = level_tag_not_nan_xTrack_in_seg_val(idx_m(rnd_idx));
                descent_tag_mat(k,these_cols) = descent_tag_not_nan_xTrack_in_seg_val(idx_m(rnd_idx));
            end
        end
    end
end

stable_turns = [stable_seg_in_climb stable_seg_in_level stable_seg_in_descent];
end
