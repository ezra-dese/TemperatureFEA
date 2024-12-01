function [x_criticalPoints, y_criticalPoints] = applyGeometry(elementSize,wallThickness)
    %% Function Description: applyGeometry
    %  Applies Desciribes the house geometry in elemental size
    %  Inputs:
    %    "wallThickness" - House Wall thicjness
    %    "elementSize" - Individual element size
    %  Outputs:
    %    "x_criticalPoints" - Vector of important x values
    %    "y_criticalPoints" - Vector of important y values
    
    % Wall Thickness converted from meters to number of elements
    t = wallThickness/elementSize;

    % x critical points 
    x1 = 14/elementSize;
    x2 = 4/elementSize;
    x3 = x2+t;
    x4 = t;
    x5 = x1-t;
    x6 = x1-2/elementSize;
    x7 = x6-t;
    x_criticalPoints = [x1 x2 x3 x4 x5 x6 x7].';

    % y critical points
    y1 = 8/elementSize;
    y2 = t;
    y3 = 2/elementSize;
    y4 = y3+t;
    y5 = (4/elementSize)-t;
    y6 = 4/elementSize;
    y7 = y1-t;
    y8 = y7-0.5/elementSize;
    y_criticalPoints = [y1 y2 y3 y4 y5 y6 y7 y8].';

end