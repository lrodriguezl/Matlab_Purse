function [interpolatedResult,interpolatedResult1 ]= interp3D(var3D,x,y,z3D,xo,yo,zo)
%% Performs 3D interpolation 
%  step 1: linearly interpolating on each column of the grid 
%  step 2: applies bilinear interpolation to interpolate on the resulting
%  plane

% find surrounding neighbors on x axis
%[a1,a2] =nearestNeighbors1D(x,xo);
ao = interp1(x,1:length(x),xo);
a1 = floor(ao);
a2 = a1 + 1;

% find surrounding neighbors on y axis
%[b1,b2] =nearestNeighbors1D(y,yo);
bo = interp1(y,1:length(y),yo);
b1 = floor(bo);
b2 = b1 + 1;

% Linearly interpolate horizontal indices
%ao=((a2-a1)/(x(a2)- x(a1)))*(xo-x(a1))+ a1; 
%bo=((b2-b1)/(y(b2)- y(b1)))*(yo-y(b1))+ b1; 

%% using linear interpolation vertically then bilinear interpolation horizontally

% get the four negihboring columns from the Z grid values
z11 = z3D(:,b1,a1);
z12 = z3D(:,b2,a1);
z21 = z3D(:,b1,a2);
z22 = z3D(:,b2,a2);

% get the four negihboring columns from the var3D grid values
v11 = var3D(:,b1,a1);
v12 = var3D(:,b2,a1);
v21 = var3D(:,b1,a2);
v22 = var3D(:,b2,a2);

% figure
% plot3(x(a1),y(b1),z11,'.')
% grid on
% hold on
% plot3(x(a1),y(b2),z12,'.')
% plot3(x(a2),y(b1),z21,'.')
% plot3(x(a2),y(b2),z22,'.')
% 
% plot3(xo,yo,zo,'ro')
% 
% figure
% plot3(a1,b1,z11,'.')
% grid on
% hold on
% plot3(a1,b2,z12,'.')
% plot3(a2,b1,z21,'.')
% plot3(a2,b2,z22,'.')
% 
% plot3(ao,bo,zo,'ro')
% 
% figure
% plot3(a1,b1,v11,'.')
% grid on
% hold on
% plot3(a1,b2,v12,'.')
% plot3(a2,b1,v21,'.')
% plot3(a2,b2,v22,'.')

%  Lineraly interpolate Z at zo, on each column
zi11 = interp1(z11,1:length(z11),zo); % linear interpolation between indices
zi12 = interp1(z12,1:length(z12),zo); % linear interpolation between indices
zi21 = interp1(z21,1:length(z21),zo); % linear interpolation between indices
zi22 = interp1(z22,1:length(z22),zo); % linear interpolation between indices

% get the two neihgbors on eahc column
zi11f = floor(zi11); zi11c=zi11f+1;
zi12f = floor(zi12); zi12c=zi12f+1;
zi21f = floor(zi21); zi21c=zi21f+1;
zi22f = floor(zi22); zi22c=zi22f+1;

% plot3(a1,b1,v11(zi11f),'ro'); plot3(a1,b1,v11(zi11c),'ro')
% plot3(a1,b2,v11(zi12f),'ro'); plot3(a1,b2,v11(zi12c),'ro')
% plot3(a2,b1,v11(zi21f),'ro'); plot3(a2,b1,v11(zi21c),'ro')
% plot3(a2,b2,v11(zi22f),'ro'); plot3(a2,b2,v11(zi22c),'ro')

% values of var3D at each of the columns
zind = [zi11f zi11c; zi12f zi12c;zi21f zi21c;zi22f zi22c];
if ~any(isnan(zind(:)))
    vi11 = ((v11(zi11c) - v11(zi11f))/(zi11c-zi11f))*(zi11-zi11f)+v11(zi11f);
    
    vi12 = ((v12(zi12c) - v12(zi12f))/(zi12c-zi12f))*(zi12-zi12f)+v12(zi12f);
    vi21 = ((v21(zi21c) - v21(zi21f))/(zi21c-zi21f))*(zi21-zi21f)+v21(zi21f);
    vi22 = ((v22(zi22c) - v11(zi22f))/(zi22c-zi22f))*(zi22-zi22f)+v11(zi22f);
    
    % plot3(a1,b1,vi11,'ko')
    % plot3(a1,b2,vi12,'ko')
    % plot3(a2,b1,vi21,'ko')
    % plot3(a2,b2,vi22,'ko')
        
    v_xy1=((a2-ao)/(a2-a1))*vi11 + ((ao-a1)/(a2-a1))*vi21;
    v_xy2=((a2-ao)/(a2-a1))*vi12 + ((ao-a1)/(a2-a1))*vi22;
    interpolatedResult = ((b2-bo)/(b2-b1))*v_xy1 + ((bo-b1)/(b2-b1))*v_xy2;
else
    interpolatedResult = nan;    
end
%%
nPlanes = size(var3D,1);
[L1, L2, L3]=meshgrid(a1:(a2),b1:b2,1:nPlanes);
Zidx=sub2ind(size(var3D),L3(:),L2(:),L1(:));
z3D_v = z3D(Zidx);
f = TriScatteredInterp(L1(:),L2(:),z3D_v,double(var3D(Zidx)),'linear');
interpolatedResult1 = f(ao,bo,zo);
% plot3(ao,bo,interpolatedResult,'ro')

if isnan(interpolatedResult) && ~isnan(interpolatedResult1)
%     disp('Interp Methood Discrepancy: Triangulation not nan')
end

if isnan(interpolatedResult1) && ~isnan(interpolatedResult)
%     disp('Interp Methood Discrepancy: Bilinear not nan')
end
end

