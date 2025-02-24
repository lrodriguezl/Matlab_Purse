function [x,y,xc,yc,...
          xa,ya,xca,yca,r] = generateArc(mode,varargin)
% [x,y,xc,yc, xa,ya,xca,yca,r] = generateArc(1,startPt,endPt,R,stepSize)
% [x,y,xc,yc, xa,ya,xca,yca,r] = generateArc(2,startPt,endPt,centerPt,stepSize)

xa=[]; ya=[]; xca=[]; yca=[];
nPoints = 100;
twoArcs=false;
% solve arc
switch mode
    case 1
        % given parameters:
        % start point of arc
        % end point of arc
        % radius of arc
        twoArcs =true;
        startPoint = varargin{1};
        endPoint = varargin{2};
        r = varargin{3};
        
        % find arc center point
        [xc, yc, xca, yca] = FindCenterOfArc(startPoint,endPoint,r);                    
               
        % compute start and end angle
        x1 = startPoint(1); y1 = startPoint(2);
        x2 = endPoint(1); y2 = endPoint(2);
        
        theta1 = atan2(y1-yc,x1-xc); % rad
        theta2 = atan2(y2-yc,x2-xc); % rad
                
        % arc 2 start and end angle
        % if only one possible center of arc was found,
        % then the second arc will cover the other half of the circle
        if ((xca==xc)&&(yca==yc)) % reverese the arc direction
            theta1a = theta2; %rad
            theta2a = theta1; % rad           
        else
            theta1a = atan2(y1-yca,x1-xca); %rad
            theta2a = atan2(y2-yca,x2-xca); % rad
        end
        if nargin==5
            stepSize = varargin{4};        
            % nPoints = round(subtended_angle*r/stepSize);
        else
            % compute arc subtended angle in rad
            subtended_angle = getArcSubtendedAngle([xc yc], startPoint,endPoint);
            stepSize = (subtended_angle*r)/nPoints;
        end
    case 2
        % given parameters:
        % start point of arc
        % end point of arc
        % center point of arc
        
        x1 = varargin{1}(1); y1 = varargin{1}(2);
        x2 = varargin{2}(1); y2 = varargin{2}(2);
        xc = varargin{3}(1); yc = varargin{3}(2);
        
        r=sqrt((x1-xc)^2 + (y1-yc)^2);
        
        subtended_angle = getArcSubtendedAngle([xc yc], [x1 y1],[x2 y2]);
        
        % arc start and end angle
        theta1 = atan2(y1-yc,x1-xc);
        theta2 = atan2(y2-yc,x2-xc);
        
        if nargin==5
            stepSize = varargin{4};        
%             nPoints = round(subtended_angle*r/stepSize);
        else
            stepSize = (subtended_angle*r)/nPoints;
        end  
    case 3
        % NEED TO CLEAN UP THIS CASE
        % given parameters:
        % start point of arc
        % end point of arc
        % point on arc
        startPoint = varargin{1};
        endPoint = varargin{2};
        pointOnArc = varargin{3};
        [xc2,yc2,rs] = findArcCenter(startPoint,endPoint,pointOnArc);
        r=double(rs);
        
        % arc 1
        xc= double(xc2(1)); yc=double(yc2(1));
        %
        x1 = startPoint(1); y1 = startPoint(2);
        x2 = endPoint(1); y2 = endPoint(2);
        theta1 = atan2(y1-yc,x1-xc);
        theta2 = atan2(y2-yc,x2-xc);
        
        % arc 2
        xca= double(xc2(2)); yca=double(yc2(2));
        
        x1 = startPoint(1); y1 = startPoint(2);
        x2 = endPoint(1); y2 = endPoint(2);
        theta1a = atan2(y1-yca,x1-xca);
        theta2a = atan2(y2-yca,x2-xca);
        
        delta1 = abs(theta1 - theta2);
        delta2 = 2*pi - delta1;
        subtended_angle = min(delta1,delta2);
        
        if nargin==5
            stepSize = varargin{4};        
%             nPoints = round(subtended_angle*r/stepSize);
        else
            stepSize = subtended_angle*r/nPoints;
        end  
    case 4
        % given parameters:
        % start point of arc
        % center point of arc
        % arc length
        % direction 1 clockwise -1 counter clockwise
        x1 = varargin{1}(1); y1 = varargin{1}(2);
        xc = varargin{2}(1); yc = varargin{2}(2);
        arcLength = varargin{3};
        dir =  varargin{4};
        
        r=sqrt((x1-xc)^2 + (y1-yc)^2);
        
        theta1 = atan2(y1-yc,x1-xc);
        theta2 = theta1 + sign(dir)*arcLength/r;
        
        delta1 = abs(theta1 - theta2);
        delta2 = 2*pi - delta1;
        subtended_angle = min(delta1,delta2);
  
        if nargin==6
            stepSize = varargin{5};        
%             nPoints = round(subtended_angle*r/stepSize);
        else
            stepSize = subtended_angle*r/nPoints;
        end  
    case 5
       % given parameters:
        % center point of arc
        % arc radius
        % start angle
        % end angle
        xc = varargin{1}(1); yc = varargin{1}(2);
        r = varargin{2};
        theta1 = varargin{3};
        theta2= varargin{4};
        
        delta1 = abs(theta1 - theta2);
        delta2 = 2*pi - delta1;
        subtended_angle = min(delta1,delta2);
 
        if nargin==6
            stepSize = varargin{5};        
%             nPoints = round(subtended_angle*r/stepSize);
        else
            stepSize = subtended_angle*r/nPoints;
        end         
    otherwise
        error('myFunction:modeChck', 'ERROR:wrong mode entry')
end

% generate points on arc
[theta_range] = angleVector(theta1,theta2,stepSize);% rad
x11 = r.*cos(theta_range);
y11 = r.*sin(theta_range);

x= x11 + xc;
y= y11 + yc;


% if two solutions for arcs were found
% generate second set of points
if twoArcs
    [theta_range] = angleVector(theta1a,theta2a,stepSize);

    x11 = r.*cos(theta_range);
    y11 = r.*sin(theta_range);
    
    xa= x11 + xca;
    ya= y11 + yca;
end
end