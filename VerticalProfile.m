function [climb_idx, level_idx, descent_idx, ...
                                varargout] = VerticalProfile(alt,t,varargin)
%%
%
%
%%
% initialize
dummy_value = 33;
vertical_profile_tag = dummy_value.*ones(size(t));

% set default constants
alt_span = 10; % samples
alt_slope_thr = 5; % ft

% read parameters input
switch nargin
    case 3
        alt_slope_thr = varargin{1};
    case 4
        alt_slope_thr = varargin{1};
        alt_span = varargin{2};
    case 6
        alt_slope_thr = varargin{1};
        alt_span = varargin{2};        
        tQuantization = varargin{3};     %sec
        zQuantization = varargin{4};     %feet (same units than altitude)
end

%% ------ process ------

% moving average on altitudde
smoothed_alt = smooth(alt,alt_span);

% Controlling parameters
% tQuantization = 0;      %sec
% zQuantization = 50;     %feet

[cpList] = TRACE_iterativeCPA(smoothed_alt, t, zQuantization, tQuantization);
cp_idx_list = [1; cpList; length(t)];

segments_xy = cell(length(cp_idx_list),2);
segments_mn = cell(length(cp_idx_list),2);

for i=1:length(cp_idx_list)-1
    start_idx = cp_idx_list(i);
    end_idx = cp_idx_list(i+1);
    x=start_idx:end_idx;
    y=smoothed_alt(x);
    [m,n,resVar,rsq] = bestLine(x,y);
    y1= m*start_idx+n; y2= m*end_idx+n;
    dy = y2-y1;
    segments_xy{i} = [start_idx, y1; end_idx y2];
    segments_mn{i} = [m n];
    if round(abs(m)) <= alt_slope_thr
        if round(abs(dy)) <= 2.5*zQuantization
            vertical_profile_tag(start_idx:end_idx)=0;
%             disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
%                 ' level m = ', num2str(m),...
%                 ' dx = ', num2str(length(x)),...
%                 ' dy = ', num2str(dy)])
        elseif sign(dy)<0
            vertical_profile_tag(start_idx:end_idx)=-1;
%             disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
%                 ' descent m = ', num2str(m),...
%                 ' dx = ', num2str(length(x)),...
%                 ' dy = ', num2str(y2-y1)])
        else
            vertical_profile_tag(start_idx:end_idx)=1;
%             disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
%                 ' climb m = ', num2str(m),...
%                 ' dx = ', num2str(length(x)),...
%                 ' dy = ', num2str(y2-y1)])
        end
    elseif round(m) > alt_slope_thr
        vertical_profile_tag(start_idx:end_idx)=1;
%         disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
%             ' climb m = ', num2str(m),...
%             ' dx = ', num2str(length(x)),...
%             ' dy = ', num2str(y2-y1)])
    else
        vertical_profile_tag(start_idx:end_idx)=-1;
%         disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
%             ' descent m = ', num2str(m),...
%             ' dx = ', num2str(length(x)),...
%             ' dy = ', num2str(y2-y1)])
    end
end
climb_idx = find(vertical_profile_tag==1);
level_idx = find(vertical_profile_tag==0);
descent_idx = find(vertical_profile_tag==-1);

varargout{1} = smoothed_alt;
varargout{2} =cell2mat(segments_xy);
varargout{3} =cell2mat(segments_mn);

end
