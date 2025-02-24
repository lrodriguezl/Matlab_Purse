function drawBox(boxLength,boxWidth,xOrientation)

if xOrientation
    line([0 0],[boxWidth -boxWidth],...
        'Color',[0 0 0],'LineWidth',3,'LineStyle','--')
    
    line([boxLength boxLength],[boxWidth -boxWidth],...
        'Color',[0 0 0],'LineWidth',3,'LineStyle','--')
    
    line([0 boxLength],[boxWidth boxWidth],...
        'Color',[0 0 0],'LineWidth',3,'LineStyle','--')
    
    line([0 boxLength],[-boxWidth -boxWidth],...
        'Color',[0 0 0],'LineWidth',3,'LineStyle','--')
else
    line([boxWidth -boxWidth],[0 0],...
        'Color',[0 0 0],'LineWidth',3,'LineStyle','--')
    
    line([boxWidth -boxWidth],[-boxLength -boxLength],...
        'Color',[0 0 0],'LineWidth',3,'LineStyle','--')
    
    line([-boxWidth -boxWidth],[0 -boxLength],...
        'Color',[0 0 0],'LineWidth',3,'LineStyle','--')
    
    line([boxWidth boxWidth],[0 -boxLength],...
        'Color',[0 0 0],'LineWidth',3,'LineStyle','--')
end
end