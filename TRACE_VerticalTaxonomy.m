function [cpListZT] = TRACE_VerticalTaxonomy(z,t,zQuantization, tQuantization)

[cpListZT] = TRACE_iterativeCPA(z, t, zQuantization, tQuantization);
[Z,zSegment,cpOutList] = verticalTaxonomy(z,t,cpListZT,zQuantization);
Err = z-Z;
cpRev1 = TRACE_iterativeCPA(Err,t,zQuantization,tQuantization);
cpListZT = sort(unique([cpOutList; cpRev1]));

%% Vertical Segment Analysis
function [Z,segment,cpOutList] = verticalTaxonomy(z,t,cpList,zQuantization)
%
% VERTICALTAXONOMY evaluateTracks subroutine
%
% Inputs:       z               input vector z(t)
%               t               input vector
%               cpList          index list of change points
%               zQuantization   quantization error on z vector
% 
% Outputs:      Z               filtered z vector
%               segment         segment association vector
%
% Subroutines:  WEIGHTEDLINEARREGRESSION
%
% Creates a vertical taxonomy using linear segments based on a set of
% change point locations.  Each change point is first interpolated to the
% intersection of the linear regression of the adjacent segments.  Any
% points which are unable to interpolate or shift the order of the change
% points are removed.  The segment type is then identified using the
% quantization threshold as a descent segment (1) or a level segment (0).
% Filtered values are based upon the linear interpolation of each segment.
%
% This function is build on the basis that the quantization error dominates
% the input vector noise and that the input vector is piecewise linear.

% throw out points directly adjacent to other change points

dCP = [diff(cpList)==1; false];
if sum(dCP)~=0
    throwPt = zeros(size(cpList));
    for e=1:length(cpList)
        if dCP(e)==1
            throwPt(e)=1;
            mark=find(dCP(e:end)==0,1,'first');
            if isempty(mark)
                dCP(e:end)=0;
            else
                dCP(e:mark)=0;
            end
        end
    end
    cpList = cpList(throwPt==0);
end

n=length(z);
Z = zeros(n,1);
segment = zeros(n,1);

% interpolate cp's with LSQ regression
cpInterp=[];
cpOutList=[];
cpFullList=[1;cpList;n];
interpValue1 = [t(1) z(1)];
interpValue2 = [t(end) z(end)];
for e=2:(length(cpList)+1)
    
    %adjacent segments
    t1 = t(cpFullList(e-1):cpFullList(e));
    t2 = t(cpFullList(e):cpFullList(e+1));
    z1 = z(cpFullList(e-1):cpFullList(e));
    z2 = z(cpFullList(e):cpFullList(e+1));
    w1 = ones(length(z1),1);
    w2 = ones(length(z2),1);
    
    %weighted least squares regression
    [zReg1, m1, b1] = weightedLinearRegression(z1, t1, w1);
    [zReg2, m2, b2] = weightedLinearRegression(z2, t2, w2);
    
    %set slopes less than quantization tolerance to zero
%     if abs(m1) <= 6*zQuantization/range(t1)
%         m1=0;
%         b1=sum(w1.*z1)/sum(w1);
%     end
%     if abs(m2) <= 6*zQuantization/range(t2)
%         m2=0;
%         b2=sum(w2.*z2)/sum(w2);
%     end
    
    %find intersection point of regressions
%     tIntercept = (b1-b2)/(m2-m1);
%     cpInterp = [cpInterp; tIntercept m1*tIntercept+b1]; %#ok<AGROW>
    
    if (m2-m1)~=0
        %intercept
        tIntercept = (b1-b2)/(m2-m1);
        cpInterp = [cpInterp; tIntercept m1*tIntercept+b1]; %#ok<AGROW>
        
        if tIntercept < t(cpFullList(e-1)+1) || tIntercept > t(cpFullList(e+1)-1)
            %interpolated point is invalid
            cpOutList = [cpOutList; 0]; %#ok<AGROW>
        else
            %store nearest point to intersection as change point
            cpOutList = [cpOutList; find(abs(t-tIntercept)==min(abs(t-tIntercept)))]; %#ok<AGROW>
        end
    else
        %no intercept
        cpInterp = [cpInterp; 0 0]; %#ok<AGROW>
        cpOutList = [cpOutList; 0]; %#ok<AGROW>
    end
    
    if e==2
        interpValue1 = [t(1) m1*t(1)+b1];
    end
    
end

%remove invalid change points
cpInterp = cpInterp(cpOutList~=0,:);
cpOutList = cpOutList(cpOutList~=0);

%make sure change points are still sorted
flag1 = zeros(size(cpOutList));
if ~issorted(cpOutList)
    for e=2:length(cpOutList)
        if cpOutList(e)<cpOutList(e-1)
            if min(abs(cpList-cpOutList(e))) <= min(abs(cpList-cpOutList(e-1)))
                flag1(e)=1;
            else
                flag1(e-1)=1;
            end
        end
    end
end

%keep only sorted change points
cpInterp = cpInterp(flag1==0,:);
cpOutList = cpOutList(flag1==0);

%add first and last interpolated values to list
if (length(cpList)+1)>=2
    cpInterp = [interpValue1; cpInterp; t(end) m2*t(end)+b2];
else
    cpInterp = [interpValue1; cpInterp; interpValue2];
end

%find filtered values using linear segments
q=1;
dz = (cpInterp(q+1,2)-cpInterp(q,2));
dt = (cpInterp(q+1,1)-cpInterp(q,1));
slope = dz/dt;
for e=1:n
    %move to next segment
    if t(e)>cpInterp(q+1,1)
        q=q+1;
        dz = (cpInterp(q+1,2)-cpInterp(q,2));
        dt = (cpInterp(q+1,1)-cpInterp(q,1));
        slope = dz/dt;
    end
    %filtered z values
    Z(e) = cpInterp(q,2)+(t(e)-cpInterp(q,1))*slope;
    if abs(slope) > 4*zQuantization/dt
        segment(e) = slope;
    else
        segment(e) = 0;
    end
end

end
function [F, m, b] = weightedLinearRegression(f, t, w, nIter)
%
% WEIGHTEDLINEARREGRESSION evaluateTracks subroutine
%
% Inputs:       f               f(t) vector
%               t               vector
%               w               weighting vector
%               nInter          number of iterations
%
% Outputs:      F               F(t) linear fit vector
%               m               slope
%               b               intercept
%
% Subroutines:  FAST2X2SOLVE
%
% Weighted linear least squares regression of the vector f(t) using the
% weighting w.  Solution is iteratively reweighted using normalized
% residuals for nIter iterations.

if length(f)>2
    %default independent variable and weighting
    if nargin<4
        nIter=5;
        if nargin<3
            w=ones(length(f),1);
            if nargin<2
                t=(1:length(f))';
            end
        end
    end

    %make sure column vector
    f=f(:);
    t=t(:);
    w=w(:);

    n = length(f);
    wr = ones(size(w));
    X = [t ones(n,1)];

    %weighted least squares regression
    W = diag(w.*wr);
    %     B = (X'*W*X)\(X'*W*f);
    B = fast2x2Solve(X,W,f);
    F = X*B;

    %robust regression
    for iterations=1:(nIter-1)
        
        %recompute weighting for new residuals
        r = abs(f-F);
        rMed = median(r);
        rDev = abs(r-rMed);
        rMAD = median(rDev);
        if rMAD~=0
            r = r/(4.685*rMAD/0.6745);
            wr = (1-r.^2).^2;
            wr(r>1) = 0;
        else
            wr = zeros(size(w));
        end

        if length(find(wr~=0))>2
            %weighted least squares regression
            W = diag(w.*wr);
            %             B = (X'*W*X)\(X'*W*f);
            B = fast2x2Solve(X,W,f);
            F = X*B;
        end
    end

    m=B(1);
    b=B(2);

else
    %vector too small for regression
    F=f;
    m=0;
    b=mean(f);
end

end
function B = fast2x2Solve(X,W,f)
%
% FAST2X2SOLVE
%
% Solves the least squares problem.
% equivalent to B = (X'*W*X)\(X'*W*f);

R = (X'*W*X);
F = (X'*W*f);
D = (R(1)*R(4)-R(2)*R(3));

B = zeros(2,1);
B(1) = (R(4)*F(1)-R(2)*F(2))/D;
B(2) = (R(1)*F(2)-R(3)*F(1))/D;

end

end