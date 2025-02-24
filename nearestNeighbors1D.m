function [n1,n2] =nearestNeighbors1D(x,xo)

n1=find(x<=xo,1,'last');
n2=find(x>xo,1,'first');

end