function [climb_idx, level_idx, descent_idx, ...
    varargout] = CPA_VerticalProfile(alt,t,varargin)
%%
%
%
%%
% initialize
dummy_value = 33;
vertical_profile_tag = dummy_value.*ones(size(t));
unclassified =  ones(size(t));


% set default constants
alt_span = 10; % samples
vspeed_span =  15; % samples
min_num_samples = 30; % sec
v_speed_thr = 5; %ft/sec
alt_slope_thr = 5; % ft

% read parameters input
switch nargin
    case 3
        v_speed_thr = varargin{1};
    case 4
        v_speed_thr = varargin{1};
        alt_span = varargin{2};
    case 5
        v_speed_thr = varargin{1};
        alt_span = varargin{2};
        vspeed_span = varargin{3};
    case 6
        v_speed_thr = varargin{1};
        alt_span = varargin{2};
        vspeed_span = varargin{3};
        min_num_samples = varargin{4};
    case 7
        v_speed_thr = varargin{1};
        alt_span = varargin{2};
        vspeed_span = varargin{3};
        min_num_samples = varargin{4};
        alt_slope_thr = varargin{5};
end

%% ------ process ------

% moving average on altitudde
smoothed_alt = smooth(alt,alt_span);

% compute vertical speed using smoothed altitude
v_speed = diff(smoothed_alt)./diff(t); % ft/sec
v_speed= v_speed(:); v_speed = [v_speed(1);v_speed];

% performing moving average on computed vertical speed to smooth it
% smoothing the computed vertical speed results in a trend, avoiding false
% identification of non leveled segments due to spikes
smoothed_vspeed = smooth(v_speed,vspeed_span,'moving');

% check if the given threshold is right for this data
% if the range of vertical speeds is within the given threshold
% but the range of altitudes indicates that there is climb or a descent
% then the vertical speed threshold needs to be smaller
% quatized_smoothed_vspeed_unit = quantize_data(smoothed_vspeed,1);
% max_vspeed = max(unique(quatized_smoothed_vspeed_unit));
% min_vspeed = min(unique(quatized_smoothed_vspeed_unit));
% 
% max_alt = max(alt);
% min_alt = min(alt);
% if (abs(max_vspeed-min_vspeed)<= 2*v_speed_thr) && (abs(max_alt-min_alt)>100)
%     v_speed_thr = ceil(abs(max_vspeed-min_vspeed)/4);
%     alt_slope_thr = 0.5;
% end

% quantize smoothed vertical speed
quatized_smoothed_vspeed = quantize_data(smoothed_vspeed,v_speed_thr);
% sign_quantized_smoothed_vspeed = sign(quatized_smoothed_vspeed);

% Controlling parameters
tQuantization = 0;      %sec
zQuantization = 50;     %feet

% [cp_idx MSE] = MSE_CP_estimator(t,smoothed_alt);
[cpList] = TRACE_iterativeCPA(smoothed_alt, t, zQuantization, tQuantization);

cp_idx_list = [1; cpList; length(t)];
for i=1:length(cp_idx_list)-1
    start_idx = cp_idx_list(i);
    end_idx = cp_idx_list(i+1);
    x=start_idx:end_idx;
    y=smoothed_alt(x);
    [m,n,resVar,rsq] = bestLine(x,y);
%     disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
%         ' m = ', num2str(m),...
%         ' var(residual) = ', num2str(resVar),...
%         ' R^2 = ', num2str(rsq)])
    if abs(m) < alt_slope_thr
        vertical_profile_tag(start_idx:end_idx)=0;
        disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
            ' level m = ', num2str(m),...
            ' var(residual) = ', num2str(resVar),...
            ' R^2 = ', num2str(rsq)])
    elseif m >= alt_slope_thr
        vertical_profile_tag(start_idx:end_idx)=1;
        disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
            ' climb m = ', num2str(m),...
            ' var(residual) = ', num2str(resVar),...
            ' R^2 = ', num2str(rsq)])
    else
        vertical_profile_tag(start_idx:end_idx)=-1;
        disp(['[ ',num2str(start_idx),' ', num2str(end_idx),']',...
            ' descent m = ', num2str(m),...
            ' var(residual) = ', num2str(resVar),...
            ' R^2 = ', num2str(rsq)])
    end
end
climb_idx = find(vertical_profile_tag==1);
level_idx = find(vertical_profile_tag==0);
descent_idx = find(vertical_profile_tag==-1);

varargout{1} = smoothed_alt;
varargout{2} = v_speed;
varargout{3} = smoothed_vspeed;
varargout{4} = quatized_smoothed_vspeed;

end