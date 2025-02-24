function [conv_fact_NM2U unit_label]= NM2Unit(x_units)

switch x_units
    case 1 % convert from NM to ft
        conv_fact_NM2U = 6076.12;
        unit_label = 'ft';
    case 2 % convert from NM to NM
        conv_fact_NM2U = 1;
        unit_label = 'NM';
    case 3% convert from NM to m
        conv_fact_NM2U = 1852;
        unit_label = 'm';
end

end