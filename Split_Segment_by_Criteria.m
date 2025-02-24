function [seg_meet_criterion_list seg_meeti_criterion_idx] = Split_Segment_by_Criteria(segment_idx,varargin)
%    [sub_seg_by_vertical_profile] = Split_Segment_by_Criteria...
%                         (segment_idx,...
%                         seg_climb_tag & seg_relevancy1_tag,...
%                         seg_level_tag & seg_relevancy1_tag,...
%                         seg_descent_tag & seg_relevancy1_tag);
if nargin>0
    seg_meet_criterion_list = cell(length(varargin),1);
    seg_meeti_criterion_idx = cell(length(varargin),1);
    segment_criterion_profile = nan(size(segment_idx));
    
    for i=1:length(varargin)
        criterion_i_tag = varargin{i}; % logical vector of the same length as segment idx
        %%
        if any(criterion_i_tag)
            segment_criterion_profile(criterion_i_tag) = i;
            potential_sub_seg_that_meets_criterion = segment_idx(criterion_i_tag);
            [seg_meeti_criterion_idx{i},seg_meet_criterion_list{i}, ~, ~] = ...
                groupIndices(potential_sub_seg_that_meets_criterion,1);
        end
        
    end
else
    error('not enough inputs')
end
end
