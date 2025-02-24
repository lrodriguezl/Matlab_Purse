function [lines_xy, lines_param, arcs_xy, arcs_param]=connectWaypoints(fixes_xy,legSequence,...
                                            curve_param,stepSize)
%% connects the given fixes following the given leg sequence
% lines_param=[m n line_length line_stepSize]
% arc_param=[xc yc arc_length arc_stepSize]
%%
nFixes = size(fixes_xy,1);
nLegs = nFixes -1;
nLines = length(find(strcmpi(legSequence,'line')));
nArcs= 2*length(find(strcmpi(legSequence,'arc')));

lines_xy = cell(nLines,1);
lines_param = cell(nLines,1);
arcs_xy = cell(nArcs,1);
arcs_param = cell(nArcs,1);
e=1;c=1;
for i=1:nLegs
    if strcmpi(legSequence{i},'line')
        % get start and end fix of current leg
        start_x = fixes_xy(i,1); end_x = fixes_xy(i+1,1);
        start_y = fixes_xy(i,2); end_y = fixes_xy(i+1,2);
        % line length
        line_length = sqrt((end_y-start_y)^2+(end_x-start_x)^2);
        % number of bins
        N = round(line_length/stepSize);
        % adjusted step size so that it fits an exact numnber of times in the
        % leg lenth
        line_stepsize = line_length/N;
        
        % find the dx that yields desired along path step size
        m=(end_y-start_y)/(end_x-start_x);
        line_dx=line_stepsize/sqrt(m^2+1);
        
        % generate line grid
        [pts_x,pts_y, line_m, line_n]= generateLine(fixes_xy(i,:),...
            fixes_xy(i+1,:),line_dx);
        
        lines_param{e} = [line_m line_n line_length line_stepsize];
        lines_xy{e} = [pts_x(:) pts_y(:)];
        e = e+1;
    elseif strcmpi(legSequence{i},'arc')
        %  get start and end fix of current leg
        start_x = fixes_xy(i,1); end_x = fixes_xy(i+1,1);
        start_y = fixes_xy(i,2); end_y = fixes_xy(i+1,2);
        % compute arc rad
        R =curve_param(i);
        
        % find arc center point
        [arc1_xc, arc1_yc, arc2_xc, arc2_yc] = FindCenterOfArc([start_x start_y],...
                                                          [end_x end_y],R);
        
        % find arc subtended angle (rad). There will always be a single
        % solution even if there are two possible center points. Each
        % center point will have the same two start and end points and thus
        % the same subtended angle
        arc_subtendedAngle = getArcSubtendedAngle([arc1_xc arc1_yc], ...
                                          [start_x start_y],[end_x end_y]);
        % arc length
        arc_length = R*arc_subtendedAngle; % in the same units as R
        N = round(arc_length/stepSize);
        arc_stepSize = arc_length/N; % dL in the same units as R
        % find the delta theta that yields a length of the desired along path
        % step size --> dL = r*Dtheta
        arc_dTheta = arc_stepSize/R; % rad
        
        % generate arc grid
        mode = 1; 
        % Moe 1: Construct Arc Given:
        % start point of arc
        % end point of arc
        % radius of arc
        % [x,y,xc,yc, xa,ya,xca,yca,r] = generateArc(1,startPt,endPt,R,stepSize)
        % [x,y,xc,yc, xa,ya,xca,yca,r] = generateArc(2,startPt,endPt,centerPt,stepSize)
        [arc1_x,arc1_y,~,~,arc2_x,arc2_y,~,~]...
            = generateArc(mode,[start_x start_y],[end_x end_y],R,arc_dTheta);
        % store points
                %[arcCenterPt_x, arcCenterPt_y, arcLength, stepSize]
        arcs_param{c} = [arc1_xc arc1_yc arc_length arc_stepSize];
        arcs_xy{c} = [arc1_x(:) arc1_y(:)];
        arcs_param{c+1} = [arc2_xc arc2_yc arc_length arc_stepSize];
        arcs_xy{c+1} = [arc2_x(:) arc2_y(:)];        
        c = c+2;               
    else
        error('error')
    end
end
end