function  [hours, minutes] = dateDiff(date1,date2)
%%
filePath='C:\Users\lrodriguez\Documents\My Projects\Active Projects\IPP\FY20\Data\IPP_Portal\IPP_times_IN.xlsx';
[D1,D2,D3]=xlsread(filePath);
%%
ids = D2(2:end,1);
ipp_id = D2(2:end,14);
y1=D1(:,1);
m1=D1(:,2);
d1=D1(:,3);
h1=D1(:,4);
mm1=D1(:,5);
y2=D1(:,6);
m2=D1(:,7);
d2=D1(:,8);
h2=D1(:,9);
mm2=D1(:,10);
ss = zeros(size(y1));
t_start = datetime(y1,m1,d1,h1,mm1,ss);
t_end = datetime(y2,m2,d2,h2,mm2,ss);
dt_min = minutes(t_end-t_start);
dt_hr = hours(t_end-t_start);
%%
filename='C:\Users\lrodriguez\Documents\My Projects\Active Projects\IPP\FY20\Data\IPP_Portal\IPP_times_OUT.xlsx';
xlswrite(filename,{'lead','ID','interval hours','interval min'},'times','a1')
xlswrite(filename,ipp_id,'times','a2')
xlswrite(filename,ids,'times','b2')
xlswrite(filename,[dt_hr,dt_min],'times','c2')

end