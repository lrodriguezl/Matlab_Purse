function [x,y, m,n]= generateLine(varargin)
% generates points on a line
%
% [x,y]= generateLine([x1 y1],[x2 y2],stepsize)
% [x,y]= generateLine([x1 y1],m,'m',length,direction,stepsize)
% [x,y]= generateLine([x1 y1],n,'n',length,direction,stepsize)
% [x,y]= generateLine([x1 y1],alpha,'a',length,direction,stepsize)
%%
c1=size(varargin{1},2);
c2=size(varargin{2},2);
in1_isa1x2 = isrow(varargin{1}) & c1==2;
in2_isa1x2 = isrow(varargin{2}) & c2==2;
in2_isa1x1 = isrow(varargin{2}) & c2==1;

if nargin<2
    error('myFunction:argChck', 'ERROR:not enough inputs')
end

if in1_isa1x2 && in2_isa1x2
    % two points are given
    pt1 = varargin{1};
    pt2 = varargin{2};
    x1 = pt1(1); y1 = pt1(2);
    x2 = pt2(1); y2 = pt2(2);
    
    m=(y2-y1)/(x2-x1);
    n=y1-m*x1;
    
    if nargin==2
        if min([x1,x2])==max([x1,x2]) 
            stepsize = (max([y1,y2])-min([y1,y2]))/100;
        else
            stepsize = (max([x1,x2])-min([x1,x2]))/100;
        end
    elseif nargin==3
        stepsize = varargin{3};
    end    
elseif in1_isa1x2 && in2_isa1x1
    pt1= varargin{1};
    x1 = pt1(1); 
    y1 = pt1(2);
    dir = varargin{5};
    lineLength = varargin{4};
    x2= x1 + sign(dir)*lineLength;
    
    if nargin==5
        stepsize = (max([x1,x2])-min([x1,x2]))/100;
    elseif nargin==6
        stepsize = varargin{6};
    end
           
    mode = varargin{3};
    if strcmp(mode,'m')
        m=varargin{2};        
        n=y1-m*x1;        
    elseif strcmp(mode,'n')
        n=varargin{2};
        m=(y1-n)/x1;
    elseif strcmp(mode,'a')
        alpha = varargin{2};
        m=tan(alpha);
        n=y1-m*x1;
    end   
end

if x1==x2 
    y=min([y1,y2]):stepsize:max([y1,y2]);
    x=ones(size(y)).*x1;    
elseif x1<x2
    x=x1:stepsize:x2;
    y=m.*x + n;
else
    x=x1:-stepsize:x2;
    y=m.*x + n;
end

end