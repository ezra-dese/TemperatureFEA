function ReturnTemps = ApplyTempBCs(Nodes,elementSize,wallThickness,outsideTemp)
    %% Function Description: ApplyTempBCs
    %  Applies Temperature Boundary Condtions For Our House Geometry
    %  Inputs:
    %    "Nodes" - [NodeID, x_cordinate, y_cordinate]
    %    "elementSize" - Individual element size
    %    "wallThickness" - The house wall thickness
    %    "outsideTemp" - Temperature Outside
    %  Outputs:
    %    "Temps" - Vector of Temperatures with knowns and unknowns (syms)
     
    %% Dashboard
    % Constants Used In the Function

    % Wall Thickness in Element Size
    t = wallThickness/elementSize;
    
    % Global House Dim Converted to Number of Elements (see geomertry)
    x1 = 14/elementSize;
    x2 = 4/elementSize;
    x3 = x2+t;
    x4 = t;
    x5 = x1-t;
    x6 = x1-2/elementSize;
    x7 = x6-t;
    y1 = 8/elementSize;
    y2 = t;
    y3 = 2/elementSize;
    y4 = y3+t;
    y5 = (4/elementSize)-t;
    y6 = 4/elementSize;
    y7 = y1-t;
    y8 = y7-0.5/elementSize;
    
    %% Create Symbolic Temperature Vector
    n = height(Nodes);
    Temps = sym('T', [1, n]); % Create symbolic vector of temperatures 
    Temps = transpose(Temps); % Transpose Temps Vector
    
    %% Apply Boundary Conditions Using Logical Indexing
    % Boundary 1
    isBoundary1 = Nodes(:,2) == 0 & Nodes(:,3) >= y3 & Nodes(:,3) <= y1;

    % Boundary 2
    isBoundary2 = Nodes(:,3) == y1 & Nodes(:,2) >= 0 & Nodes(:,2) <= x6;

    % Boundary 3
    isBoundary3 = Nodes(:,2) == x6 & Nodes(:,3) >= y6 & Nodes(:,3) <= y1;

    % Boundary 4
    isBoundary4 = Nodes(:,3) == y6 & Nodes(:,2) >= x6 & Nodes(:,2) <= x1;

    % Boundary 5
    isBoundary5 = Nodes(:,2) == x1 & Nodes(:,3) >= 0 & Nodes(:,3) <= y6;

    % Boundary 6
    isBoundary6 = Nodes(:,3) == 0 & Nodes(:,2) >= x2 & Nodes(:,2) <= x1;

    % Boundary 7
    isBoundary7 = Nodes(:,2) == x2 & Nodes(:,3) >= 0 & Nodes(:,3) <= y3;

    % Boundary 8
    isBoundary8 = Nodes(:,3) == y3 & Nodes(:,2) >= 0 & Nodes(:,2) <= x2;

    % Combine all boundary conditions
    isBoundary = isBoundary1 | isBoundary2 | isBoundary3 | isBoundary4 | ...
                 isBoundary5 | isBoundary6 | isBoundary7 | isBoundary8;

    % Assign outside temperature to boundary nodes
    Temps(isBoundary) = outsideTemp;
    
  %% Remove Outside Temperatures
    isOutside1 = (Nodes(:,2) >= 0 & Nodes(:,2) < x2) & ...
    (Nodes(:,3) >= 0 & Nodes(:,3) < y3);
   
    isOutside2 = (Nodes(:,2) > x6 & Nodes(:,2) <= x1) & ...
                 (Nodes(:,3) > y6 & Nodes(:,3) <= y1);
    
    isOutside = isOutside1 | isOutside2;

    isInside = ~isOutside; % Nodes that are inside the house

    % Filter only inside temperatures
    ReturnTemps = Temps(isInside);
end