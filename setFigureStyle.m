function setFigureStyle(h)

% Extract handles
ah = findobj(h,'Type','Axes','-not','Tag','Legend'); % Axes
lineh = findobj(h,'Type','Line'); % Lines
th = findall(h,'-property','Fontsize');  % Text

% Adjust line plots.
set(lineh,'Linewidth',2,'markersize',6); % Thick lines.
set(findobj(lineh,'Marker','.'),'markersize',16); %Big dots.

% Set text fonts
set(th,'Fontname','Arial','FontWeight','Normal','FontSize',12);
for i = 1:length(ah)
    set(get(ah(i),'Title'),'FontSize',16);
    set(get(ah(i),'Xlabel'),'Fontsize',14);
    set(get(ah(i),'YLabel'),'Fontsize',14);
end

set(h,'FontName','Arial','FontSize',14)

end