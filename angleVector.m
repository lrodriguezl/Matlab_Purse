function [theta_range] = angleVector(theta1,theta2,stepSize)
%% creates a vector of angles in the range [-pi,pi]
% clockwise
%                90
%                ^    
%                |   
%        IV      |       I
%                |
% 180____________|_____________ > 0
%        III     |     II
%                |
%                |
%               -90

%% Sep 2017
if theta1<theta2 %theta1 <= 0 && theta2 >= pi
    % case of discontinuity 
    % start angle is in quadrant II or III 
    % AND
    % end angle is in quadrant IV or I 
    % clockwise
%                90
%                ^    
%                |   
%        IV      |       I
%           A2 \ |
% 180___________\|_____________ > 0
%        III     |\     II
%                | \ A1
%                |  
%               -90
    theta_range1 = theta1:-stepSize:-pi;
%     stepSizeResidue =  stepSize - (pi-abs(theta_range1(end)));
    theta_range2 = sort(theta2:stepSize:pi,'descend');
    theta_range = [theta_range1 theta_range2];
elseif theta1>theta2
    theta_range = theta1:-stepSize:theta2;
end

%% Prior sep 2017
% if theta1 <= -pi/2 && theta2 >= (theta1 + pi)
%     % start angle is in 3rd quadrant and end angle is in 4th or 1st quadrant
%     theta_range1 = theta1:-stepSize:-pi;
%     stepSizeResidue =  stepSize - (pi-abs(theta_range1(end)));
%     theta_range2 = sort(theta2:stepSize:(pi-stepSizeResidue),'descend');
%     theta_range = [theta_range1 theta_range2];
% elseif theta2<=-pi/2 && theta1 >= (theta2 + pi)
%     % start angle is in 4th or 1st quadrant and second angle is in 3rd quadrant    
%     theta_range1 = theta1:stepSize:pi;
%     stepSizeResidue =  stepSize - (pi-theta_range1(end));
%     theta_range2 = sort(theta2:-stepSize:(-pi+stepSizeResidue),'ascend');
%     theta_range = [theta_range1 theta_range2];
% elseif theta1<theta2
%     theta_range = theta1:stepSize:theta2;
% elseif theta1>theta2
%     theta_range = theta1:-stepSize:theta2;
% end
end