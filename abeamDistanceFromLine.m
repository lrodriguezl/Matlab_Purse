function [Track_computed_y, method] = abeamDistanceFromLine(seg_x,seg_y,...
                                                         ref_x,track_id,...
                                                         useExtrapolation)
%% Computes the abeam distance from the reference paht for each point 
%% initialize
nRefPts = length(ref_x);
unique_track_ids = unique(track_id);
nTracks =  length(unique_track_ids);
epsilon = 10^-5;
Track_computed_y = nan(nRefPts,nTracks);
method = nan(nRefPts,nTracks);

%%
% compute track lateral deviation at each reference point
% if no track point falls right at the reference point then interpolate
for p=1:nRefPts
    this_ref_x = ref_x(p);
    for g=1:nTracks
        if isnumeric(unique_track_ids(g))
            this_track = track_id==unique_track_ids(g);
            this_track_str=num2str(unique_track_ids(g));
        else
            this_track = strcmp(track_id,unique_track_ids(g));
            this_track_str=unique_track_ids(g);                        
        end
        % get the radial vectors of this track
        this_track_x = seg_x(this_track);
        this_track_y = seg_y(this_track);
        % check if any track x is the same as the reference
        [this_track_unique_x M N]=unique(this_track_x);
        this_track_unique_y = this_track_y(M);
        
        track_x_eq_ref_x = abs(this_track_unique_x-this_ref_x)<epsilon;
        if any(track_x_eq_ref_x)
            Track_computed_y(p,g) = this_track_unique_y(track_x_eq_ref_x);
            method(p,g)=0;
            disp(['no interpolation needed for track ',...
                this_track_str,' point ' num2str(p)])
        else
            % interpolate
            % interpolation assums x coordinates are monotonic
            this_track_x_prev_idx = this_track_x<this_ref_x;
            this_track_x_next_idx = this_track_x>this_ref_x;
            
            this_track_x_prev= this_track_x(this_track_x_prev_idx);
            this_track_x_next= this_track_x(this_track_x_next_idx);
            
            neighbors_on_boths_sides = any(this_track_x_prev_idx) &...
                any(this_track_x_next_idx);
            
            if neighbors_on_boths_sides
                % get the x and y of the closest track points
                % before and after the reference point
                [track_x1 I1] = max(this_track_x_prev);
                [track_x2 I2] = min(this_track_x_next);
                
                this_track_y_prev_neighbors = this_track_y(this_track_x_prev_idx);
                this_track_y_next_neighbors = this_track_y(this_track_x_next_idx);
                
                track_y1=this_track_y_prev_neighbors(I1);
                track_y2=this_track_y_next_neighbors(I2);
                % use linear interpolation to compute
                % lateral deviation of track at reference point
                
                % compute line parameters m and n -->y=n+m*x
                m=(track_y2-track_y1)/(track_x2-track_x1);
                n=track_y1-m*track_x1;
                line_y = n+m*this_ref_x;
                Track_computed_y(p,g) = line_y;
                method(p,g)=2;
            else
                if useExtrapolation
                    %extrapolate polynomial fit
                    if ~isempty(this_track_x_prev)
                        [this_track_neighbors_x I3]= unique(this_track_x_prev);
                        this_track_neighbors_y= this_track_y(I3);
                        M=(length(this_track_neighbors_x)-10):length(this_track_neighbors_x);
                        closest_N_neighbors_x = this_track_neighbors_x(M);
                        closest_N_neighbors_y = this_track_neighbors_y(M);
                    elseif ~isempty(this_track_x_next)
                        [this_track_neighbors_x I3]= unique(this_track_x_next);
                        this_track_neighbors_y= this_track_y(I3);
                        closest_N_neighbors_x = this_track_neighbors_x(1:10);
                        closest_N_neighbors_y = this_track_neighbors_y(1:10);
                    else
                        error('error in extrapolating line')
                    end
                    % 3rd order polynomial extrapolation
                    poly_param = polyfit(closest_N_neighbors_x,...
                        closest_N_neighbors_y,3);
                    Track_computed_y(p,g) =polyval(poly_param,this_ref_x);
                    method(p,g)=1;
                else
                    Track_computed_y(p,g)=nan; 
                    method(p,g)=-1;
                end
                
            end
        end
    end
end
end