function [artccData] = getARTCCFromCRS(artccId)
%%
[conn] = CRS_config();
sqlQuery = ['SELECT ARTCCID, ICAO_ARTCCID, ARTCCNAME, SITESTATENAME, SITELATFMT, SITELONGFMT, INFOEFFDATE, FCLTYTYPE From '...
    'NFDC_AFF1 Where ( ARTCCID = ''' upper(artccId) ''' AND FCLTYTYPE = ''ARTCC'') '];

artccDataDirty=fetch(conn,sqlQuery);

infoDate= artccDataDirty(:,7);
dnum = zeros(size(infoDate));
notNull = ~strcmp(infoDate,'null');
dnum(notNull)=datenum(infoDate(notNull));
[vmax, k]=max(dnum);
mostRecentData = artccDataDirty(k,:);
%%
artccData = mostRecentData;
end