function [cpList] = TRACE_iterativeCPA(y, t, yQuantization, tQuantization)
%
% ITERATIVECPAORDER1 evaluateTracks subroutine
%
% Inputs:       y               y = y(t) vector
%               MSEorder1       function handle to determine subroutine
%               yQuantization   y quantization
%               tQuantization   t quantization
%               *cpList         change point index list (used internally only)
%
% Outputs:      cpList          change point index list
%
% Subroutines:  MSEORDER1
%               MSEORDER0
%
% Performs an iterative change point analysis to detect an unknown number
% of changes in the derivative of an input function and their indexed
% locations.
%
% Takes an input list of change points, CPLIST, and breaks the vector up
% into segments given by the these points and the start and end of the
% vector.  Next, possible change points are found for each segment.  
% 
%        inputChangePoint              inputChangePoint
% o-------------x-----------------------------x---------------------------o
%
%    segment 1             segment 2                    segment 3
% o-------------o-----------------------------o---------------------------o
%
% If a change point is found over a segment, then this change point is 
% added to the output list, CPLIST.
%
%       changePoint         changePoint                 changePoint
% o----------x--o----------------x------------o--------------x------------o
%
% If no change point is found over a segment, the function checks the
% segments before and after to see if a change point was found.  
%
%                      primary segment
% o----------x--o.............................o--------------x------------o
%
% If the neighboring segment detected a change point, then the function 
% detects whether a change occurred between the neighboring change point
% and the opposite end of the primary segment.  Alternatively, if no change
% point is detected in the neighboring segment, then the neighboring
% endpoint of the primary segment is added.
%
% o----------x--o.............................o--------------x------------o
% CP found   o--------------------------------x--------------o
% no CP      o--------------------------------o
%
% If a change is detected, the neighboring end of the primary segment is
% added to the ouput list, CPLIST.  If no change point is detected, then no
% points are added out the output list, CPLIST.
%
%                   output change point locations:
% -----------x--------------------------------x--------------x-------------
%
% The function is then recursively iterated until the solution closes and 
% no new endpoints are found.

cpList=[];
cpOldFull=[];
converged = false;
nIter = 0;

while ~converged
    
    %test for max iterations
    nIter = nIter+1;
    if nIter>500
        error('iterativeCPA:failedConvergenceCPA','Change points failed to converge');
    end
    
    %number of change points
    n=length(cpList);
    
    % break into segments and detect changes
    cpFull = [1; cpList; length(y)];
    cpNew = zeros(n+1,1);
   
    for e=1:(n+1)
        
        IDX1=find(cpOldFull==cpFull(e),1);
        IDX2 = find(cpOldFull==cpFull(e+1),1);
        IDX_range=IDX1:IDX2;
        V=cpOldFull(IDX_range);
        if length(V)~=2
            % find the mean squeare error for each point int he segment
            [cp]=MSEorder1(y(cpFull(e):cpFull(e+1)),t(cpFull(e):cpFull(e+1)),yQuantization,tQuantization);
            if ~isempty(cp)
                cpNew(e)=cp+cpFull(e)-1;
            end
        end
    end
    
    %store previous iteration change points for comp time
    cpOldFull = cpFull;
    
    % if new change points detected
    if max(cpNew)~=0
        %iterate to refine new change points
        for e=1:n+1
            if cpNew(e)==0
                if e==1
                    %first segment
                    if cpNew(e+1)~=0
                        %right side change
                        [minPoint]=MSEorder1(y(cpFull(e):cpNew(e+1)),t(cpFull(e):cpNew(e+1)),yQuantization,tQuantization);
                        if ~isempty(minPoint)
                            cpNew(e)=cpFull(e+1);
                        end
                    else
                        cpNew(e)=cpFull(e+1);
                    end
                elseif e==(n+1)
                    %last segment
                    if cpNew(e-1)~=0
                        %left side change
                        [minPoint]=MSEorder1(y(cpNew(e-1):cpFull(e+1)),t(cpNew(e-1):cpFull(e+1)),yQuantization,tQuantization);
                        if ~isempty(minPoint)
                            cpNew(e)=cpFull(e);
                        end
                    else
                        cpNew(e)=cpFull(e);
                    end
                else
                    %center segment
                    if cpNew(e+1)~=0
                        %left side change
                        [minPoint]=MSEorder1(y(cpFull(e):cpNew(e+1)),t(cpFull(e):cpNew(e+1)),yQuantization,tQuantization);
                        if ~isempty(minPoint)
                            cpNew(e)=cpFull(e+1);
                        end
                    else
                        cpNew(e)=cpFull(e+1);
                    end
                    if cpNew(e-1)~=0
                        %right side change
                        [minPoint]=MSEorder1(y(cpNew(e-1):cpFull(e+1)),t(cpNew(e-1):cpFull(e+1)),yQuantization,tQuantization);
                        if ~isempty(minPoint)
                            cpNew(e)=cpFull(e);
                        end
                    else
                        cpNew(e)=cpFull(e);
                    end
                end
            end
        end
        
        cpNew=cpNew(cpNew~=0);
        cpList = sort(unique(cpNew));
        
    else
        %no new change points
        converged = true;
    end
    
end
end

function [minPoint, MSE] = MSE_linear(y,x,yQuantization,xQuantization)

N=length(y);
MSE=nan(N,1);
if N>5
    for i=2:N-1
        x1=(1:i)';
        y1 = y(x1);
        [m1,n1,resVar1,rsq1] = bestLine(x1,y1);
        yo1= m1.*x1+n1;
        
        x2=((i+1):N)';
        y2 = y(x2);
        [m2,n2,resVar2,rsq2] = bestLine(x2,y2);
        yo2=m2.*x2+n2;
        
        MSE(i) = sum((y(x1)-yo1).^2) + sum((y(x2)-yo2).^2) ;
    end
    
    [m,n,resVar,rsq] = bestLine(x,y);
    yo = m.*x+n;
    MSE(N) = sum((y-yo).^2);
    MSE(1) = MSE(N);
    
    eQuantization = (yQuantization + abs(m)*xQuantization)^2/4;
    
    % bootstrap to detect change
    mean_MSE = sum(MSE)/n;
    predictor = cumsum(MSE - mean_MSE);
    predictorValue = max(predictor)-min(predictor);
    
    change_detected = predictorValue > eQuantization*sqrt(n) || MSE(1)>5*(yQuantization^2);
    
    if change_detected
        % find all points where MSE equals min (MSE)
        minPoint=find(MSE(2:(n-1))==min(MSE),1)+1;
    else
        minPoint=[];
    end
else
    %vector too small
    minPoint=[];
end
end

function [minPoint, MSE] = MSEorder1(y, t, yQuantization, tQuantization)
%
% MSEORDER1 evaluateTracks subroutine
%
% Inputs:       y               y = y(t) vector
%               yQuantization   y quantization
%               tQuantization   t quantization
%
% Outputs:      minPoint        the index with minimum MSE if change occurred
%                               (empty otherwise)
%               MSE             mean square error vector
%
% Subroutines:  DETECTCHANGE
%               STANDARDREGRESSION
%
% Finds the mean squared error at each point for the discontinuous least 
% squares regression for the input vector Y.  DETECTCHANGE is then used to
% determine if a change occurs in the mean square error.  If a change
% occurs the point with the minimum mean square error is returned.
%
% Discontinuous linear regression is performed at a given point of the
% vector by breaking the vector into two segments, for which a standard
% linear least squares regression is performed.  A minimum in the MSE
% represents the point where the derivative of Y changes.

tt = t.*t;
ty = t.*y;

St1 = cumsum(t);
Sy1 = cumsum(y);
Stt1 = cumsum(tt);
Sty1 = cumsum(ty);
St2 = St1(end)-St1+t;
Sy2 = Sy1(end)-Sy1+y;
Stt2 = Stt1(end)-Stt1+tt;
Sty2 = Sty1(end)-Sty1+ty;

n=length(y);

MSE=zeros(n,1);
yHat=zeros(n,1);

if n>5

    for e=2:(n-1)
        yHat(1:e) = fastRegression(t(1:e),St1(e),Sy1(e),Stt1(e),Sty1(e),e);
        yHat(e:end) = fastRegression(t(e:end),St2(e),Sy2(e),Stt2(e),Sty2(e),n-e+1);
        MSE(e) = sum((y-yHat).^2)/n;
    end

    [yHat,m]=fastRegression(t,St1(end),Sy1(end),Stt1(end),Sty1(end),n);
    MSE(1) = sum((y-yHat).^2)/n;
    MSE(n) = MSE(1);

    eQuantization = (yQuantization + abs(m)*tQuantization)^2/4;

    predictor = cumsum(MSE-sum(MSE)/n);
    predictorValue = max(predictor)-min(predictor);

    if predictorValue > eQuantization*sqrt(n) || MSE(1)>5*(yQuantization^2)
        minPoint=find(MSE(2:(n-1))==min(MSE),1)+1;
    else
        minPoint=[];
    end
    
else
    %vector too small
    minPoint=[];
end

end
function [yReg, m] = fastRegression(t,St,Sy,Stt,Sty,n)
%
% STANDARDREGRESSION evaluateTracks subroutine
%
% Inputs:       y               input vector
% 
% Outputs:      yReg            linear regressed vector
%               m               linear slope
%
% Linear least squares regression of the parametric function, Y, that
% minimizes the error function, E.
% 
% Y = f(T)
% E = sum( (Y - (m*X+b))^2 )
%

% St = sum(t);
% Sy = sum(y);
% Stt = sum(tt);
% Sty = sum(ty);

m = (n*Sty-St*Sy)/(n*Stt-St*St);
b = (Sy-m*St)/n;
yReg = b+m.*t;
    
end

