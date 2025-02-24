function [radial_difference, track_computed_r, method]= abeamDistanceFromArc(...
                                            track_theta_0_2pi,track_r,...
                                            track_x,track_y,...
                                            ref_theta_0_2pi,ref_x,...
                                            R,track_id,useExtrapolation)
%% initialize

nRefPts = length(ref_x);
unique_track_ids = unique(track_id);
nTracks =  length(unique_track_ids);
epsilon = 10^-5;
track_computed_r = nan(nRefPts,nTracks);
radial_difference = nan(nRefPts,nTracks);
method = nan(nRefPts,nTracks);

%%

% compute radial residuals = track_r - R at each point on
% the reference path
% if no track point falls right at that radial vector then interpolate
for p=1:nRefPts
    this_ref_theta = ref_theta_0_2pi(p);
    this_ref_x = ref_x(p);    
    for g=1:nTracks
        if isnumeric(unique_track_ids(g))
            this_track = track_id==unique_track_ids(g);
            this_track_str=num2str(unique_track_ids(g));
        else
            this_track = strcmp(track_id,unique_track_ids(g));
            this_track_str=unique_track_ids(g);            
        end        % get the cartisian and polar coordinates of this track
        this_track_theta = track_theta_0_2pi(this_track);
        this_track_r = track_r(this_track);
        this_track_x = track_x(this_track); % x'
        this_track_y = track_y(this_track); % y'
        % check if any track radial vector is the same as the reference
        [this_track_unique_theta M N]=unique(this_track_theta);
        this_track_unique_r = this_track_r(M);
        track_theta_eq_ref_theta = abs(this_track_unique_theta-this_ref_theta)<epsilon;
        if any(track_theta_eq_ref_theta)
            track_computed_r(p,g) = this_track_unique_r(track_theta_eq_ref_theta);
            radial_difference(p,g)=0;
            method(p,g)=0;
            disp(['no interpolation needed for track ',...
                this_track_str,' point ' num2str(p)])
        else
            % interpolate
            
            % the angle comparison works fine for EHAM procedure 2012
            % will need to generalize later for all possible cases
            
            % the arc direction in EHAM procedure is clockwise
            this_track_theta_next_idx = this_track_theta<this_ref_theta;
            this_track_theta_prev_idx = this_track_theta>this_ref_theta;
            
            this_track_theta_next_neighbors = this_track_theta(this_track_theta_next_idx);
            this_track_r_next_neighbors = this_track_r(this_track_theta_next_idx);

            this_track_theta_prev_neighbors = this_track_theta(this_track_theta_prev_idx);
            this_track_r_prev_neighbors = this_track_r(this_track_theta_prev_idx);
            
            neighbors_on_boths_sides = any(this_track_theta_next_idx) &...
                any(this_track_theta_prev_idx);
            if neighbors_on_boths_sides
                % interpolate
                % get the theta and radius of the closest track points
                % before and after the reference point
                [closest_prev_theta I1] = min(this_track_theta_prev_neighbors);
                [closest_next_theta I2] = max(this_track_theta_next_neighbors);
                closest_prev_r=this_track_r_prev_neighbors(I1); 
                closest_next_r=this_track_r_next_neighbors(I2);
                % use spiral interpolation to compute radius
                % of track at reference point
                % get the delta angle
                delta1 = closest_next_theta-closest_prev_theta; % rad
                delta2 = 2*pi - abs(delta1); % rad
                dTheta = sign(delta1).*min(abs(delta1),delta2); %rad
                % compute spiral parameters a and b -->r=a+b*theta
                b=(closest_next_r-closest_prev_r)/dTheta;
                a=closest_prev_r-b*closest_prev_theta;
                spiral_r = a+b*this_ref_theta;
                radial_difference(p,g) = spiral_r - R;
                track_computed_r(p,g)=spiral_r;
                method(p,g)=2;
            else
                if useExtrapolation
                    %extrapolate polynomial fit
                    if ~isempty(this_track_theta_prev_neighbors)
                        [this_track_neighbors_x I3]= unique(this_track_x(this_track_theta_prev_idx));
                        this_track_neighbors_y= this_track_y(I3);
                        
                        M=(length(this_track_neighbors_x)-10):length(this_track_neighbors_x);
                        closest_N_neighbors_x = this_track_neighbors_x(M);
                        closest_N_neighbors_y = this_track_neighbors_y(M);
                    elseif ~isempty(this_track_theta_next_neighbors)
                        [this_track_neighbors_x I3]= unique(this_track_x(this_track_theta_next_idx));
                        this_track_neighbors_y= this_track_y(I3);
                        
                        closest_N_neighbors_x = this_track_neighbors_x(1:10);
                        closest_N_neighbors_y = this_track_neighbors_y(1:10);
                    else
                        error('error in extrapolating arc')
                    end
                    
                    poly_param = polyfit(closest_N_neighbors_x,...
                        closest_N_neighbors_y,3);
                    
                    extrapol_track_y =polyval(poly_param,this_ref_x);
                    extrapol_r= sqrt((this_ref_x).^2 + (extrapol_track_y).^2);
                    radial_difference(p,g) = extrapol_r - R;
                    track_computed_r(p,g)=extrapol_r;
                    method(p,g)= 1;
                else
                    radial_difference(p,g)=nan;
                    track_computed_r(p,g)=nan;
                    method(p,g)= -1;
                end
            end
        end
    end
end

end