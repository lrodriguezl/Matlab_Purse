function [varargout] = LateralProfile(roll_angle,varargin)
%%
% [lateral_profile_tag turn_segments_list] = LateralProfile(roll_angle,roll_threshold,roll_angle_span,min_num_samples)
% input
% roll_angle : roll angle vector in degrees
% output
% final_turn_idx : vector containing index for right and left turns
% final_straight_idx  : vector containing index for straights
% turn_seg_list : array of of 1x2 vectors containing start and end of turns 
% straight_seg_list : array of of 1x2 vectors containing start and end of straights 
%
% Description: This function detects turns using the roll angle 
% Turn Definition: A turn is defined by the group of  consecutive points 
%                  where the roll angle is above a given threshold.  
%%
lower_bound = 2; %deg
upper_bound = 3.5; %deg
% turn thresholds
roll_threshold = 3; % deg
min_num_samples = 5;
roll_angle_span = 10;
% minimum straight length is 2 sec (this is not a controlling parameter)

switch nargin
    case 2
        roll_threshold = varargin{1}; % deg
    case 3
        roll_threshold = varargin{1}; % deg
        roll_angle_span = varargin{2};
    case 4
        roll_threshold = varargin{1}; % deg
        roll_angle_span = varargin{2};
        min_num_samples = varargin{3};
end

roll_angle_smoothed0 = smooth(roll_angle,roll_angle_span);
roll_angle_smoothed = smooth(roll_angle_smoothed0,roll_angle_span);

% quantize roll angle
quatized_roll_angle = quantize_data(roll_angle_smoothed,roll_threshold);
sign_quatized_roll_angle = sign(quatized_roll_angle);

dummy_val =33;
lateral_profile_tag = dummy_val*ones(size(roll_angle));

% find turns
potential_turns = find(sign_quatized_roll_angle~=0);
if ~isempty(potential_turns)
    [turn_seg_idx,turn_seg_list, ~, ~] = groupIndices(potential_turns,...
        min_num_samples);
    for i=1:length(turn_seg_list)
        turn_i = turn_seg_list{i}(1):turn_seg_list{i}(2);
        % if none of the roll angle values
        % for the potential turn segment is above upper_bound 
        % it's most likely part of a noisy straight segment
        if any(abs(roll_angle_smoothed(turn_i)) >= upper_bound)
            right_turn = sign_quatized_roll_angle(turn_i)>0;
            left_turn = sign_quatized_roll_angle(turn_i)<0;
            
            lateral_profile_tag(turn_i(right_turn))=1;
            lateral_profile_tag((turn_i(left_turn)))=-1;
        end
    end
end

potential_straights = find(lateral_profile_tag==dummy_val);
if ~isempty(potential_straights)
    [straight_seg_idx,straight_seg_list, ~, ~] = groupIndices(potential_straights,...
                                                          2);
    for i=1:length(straight_seg_list)                                                        
        straight_i = straight_seg_list{i}(1):straight_seg_list{i}(2);          
        if any(abs(roll_angle_smoothed(straight_i)) < lower_bound)
            lateral_profile_tag(straight_i) = 0;
        else
            % if none of the roll angle values 
            % for the potential straight segment is below lower_bound
            % then it's most likely part of a noisy turn segment
            if all(roll_angle_smoothed(straight_i)>0)
                lateral_profile_tag(straight_i)=1;
            elseif all(roll_angle_smoothed(straight_i)<0)
                lateral_profile_tag(straight_i)=-1;
            end
        end
    end
end

turn_idx = find(lateral_profile_tag==1 | lateral_profile_tag==-1);
right_turn_idx = find(lateral_profile_tag==1);
left_turn_idx = find(lateral_profile_tag==-1);
straight_idx = find(lateral_profile_tag==0);

[final_straight_idx,straight_seg_list, ~, ~] = groupIndices(straight_idx,2);
[final_turn_idx,turn_seg_list, ~, ~] = groupIndices(turn_idx,2);

% output
varargout{1} = final_turn_idx;
varargout{2} = final_straight_idx;

varargout{3} = turn_seg_list;
varargout{4} = straight_seg_list;

varargout{5} = right_turn_idx;
varargout{6} = left_turn_idx;

varargout{7} = roll_angle_smoothed;
varargout{8} = quatized_roll_angle;

end