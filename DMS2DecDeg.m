function [decDeg]=DMS2DecDeg(dd_mm_ss,signVal)
% positive longitude values are east of the Prime Meridian and north 
% of the Equator, 
% negative values are west of the Prime Meridian and south of the Equator
% 
% Input: 
%   dd_mm_ss: 3xn = [dd mm ss]
%   signVal char 's' or 'n' or 'w' or 'e'
% Output:
%   decDeg double
% Example: 
%  Convert W98° 24' 35.094546813" to decimal degrees
%  decDeg = DMS2DecDeg([98 24 35.094546813],'w')
%  decDeg = -98.4097
%       
%
dd=dd_mm_ss(:,1);
mm=dd_mm_ss(:,2);
ss=dd_mm_ss(:,3);

decDeg = dd + mm/60 + ss/3600;

w_idx = strcmpi('w',signVal);
s_idx = strcmpi('s',signVal);
s_w_idx = w_idx | s_idx;

decDeg(s_w_idx)= -decDeg(s_w_idx);
end