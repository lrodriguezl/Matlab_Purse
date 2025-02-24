function [seg_idx, seg_list, residual_idx, residual_list] = groupIndices...
                                                            (idx,...
                                                             groupMinLength,...
                                                             varargin)
%
% [seg_idx seg_list residual_idx residual_list] = groupIndices(idx,groupMinLength,keep_disregarded_idx)
% Input
% idx: nx1 vector of integers (indices)
% groupMinLength: integer minimum number of points in a group
% optional argument: boolean 0 or 1 to indicate whether to store
% disregarded groups
%
% Output
% seg_idx:mx1 vector containing indices of all formed groups
% seg_list: array of
% residual_idx:
% residual_list:
%
% Description
% Given a vector of indices creates groups of consecutive ones whose length
% is greater than the given minimum length.

if isempty(varargin)
    keepResidual = false;
else
    keepResidual =  varargin{1};
end
% initializing array and array index
seg_list = {}; residual_list = {};
seg_idx = []; residual_idx = [];
l=1; r=1;

% by computing the difference in the indices
% we can identify the ones that are not consecutive
idx_diff = diff(idx); % get difference of indices
% get the indices of the ones that are not consecutive
non_consecutive_idx = find(idx_diff~=1);

if ~isempty(non_consecutive_idx)
    % adding first elements to array
    if non_consecutive_idx(1)>= groupMinLength
        % if the first non consecutive index is far enough from start of first
        % segment then add the first segment to the array
        seg_list{1}= [idx(1) idx(non_consecutive_idx(1))];
        seg_idx = [seg_idx seg_list{l}(1):seg_list{l}(2)];
        l=2;
    elseif keepResidual
        residual_list{r} = [idx(1) idx(non_consecutive_idx(1))];
        residual_idx = [residual_idx residual_list{r}(1):residual_list{r}(2)];
        r = 2;
    end
    % looping through the indices for non concecutive points
    % to group the consecutive points making up the segments
    for k=2:length(non_consecutive_idx)
        start_idx = idx(non_consecutive_idx(k-1)+1);
        end_idx = idx(non_consecutive_idx(k));
        if length(start_idx:end_idx) >= groupMinLength
            seg_list{l}=[start_idx end_idx];
            seg_idx = [seg_idx start_idx:end_idx];
            l = l + 1;
        elseif keepResidual
            residual_list{r} = [start_idx end_idx];
            residual_idx = [residual_idx start_idx:end_idx];
            r = r + 1;
        end
    end
    % adding last elements to array
    start_idx_last = idx(non_consecutive_idx(end)+1);
    end_idx_last = idx(end);
    if length(start_idx_last:end_idx_last) >= groupMinLength
        % if the last non consecutive index is far enough from end of last
        % group then add the last group to the array
        seg_list{l}= [idx(non_consecutive_idx(end)+1) idx(end)];
        seg_idx = [seg_idx seg_list{l}(1):seg_list{l}(2)];
    elseif keepResidual
        residual_list{r} = [idx(non_consecutive_idx(end)+1) idx(end)];
        residual_idx = [residual_idx residual_list{r}(1):residual_list{r}(2)];
    end
else % if all indices are consecutive then return input 
     % if min length condition is met
    if length(idx)>= groupMinLength
        seg_list{l} = [idx(1) idx(end)];
        seg_idx = idx;
    end
end
seg_idx = seg_idx(:);
residual_idx = residual_idx(:);

end
