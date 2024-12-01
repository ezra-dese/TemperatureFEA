function returnHeatFlux = ApplyHeatFluxBCs(Nodes,elementSize,wallThickness,furnaceFlux,area)
%% Function Description: ApplyHeatFluxBCs
    %  Applies Temperature Boundary Condtions For Our House Geometry
    %  Inputs:
    %    "Nodes" - [NodeID, x_cordinate, y_cordinate]
    %    "elementSize" - Individual element size
    %    "wallThickness" - The house wall thickness
    %    "furnaceFlux" - Flux from Furnance
    %  Outputs:
    %    "heatFlux" - Vector of Fluxes with knowns and unknowns (syms)
%% Dashboard: Define Constants used inside of the function
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
%% Create Symbolic Heat Flux Vector
    n = height(Nodes); % index for Nodes 
    heatFlux = sym('q', [1, n]); % Create symbolic vector of Fluxes
    heatFlux = transpose(heatFlux); % Transpose heatFlux Vector

%% Algorithm: Apply Heat Flux
    % Identifiy Furnance Nodes
    isFurnace = (Nodes(:,2) >= x4 & Nodes(:,2) <= x3) & ...
                (Nodes(:,3) >= y8 & Nodes(:,3) <= y7);

    % Number of nodes inside the furnace area
    numFurnaceNodes = sum(isFurnace);

    % Calculate heat flux and distribute over furnace nodes
    heatFlux(isFurnace) = area .* furnaceFlux ./ numFurnaceNodes;

    % Boundary Nodes
    isBoundary = ...
        (Nodes(:,2) == 0 & Nodes(:,3) >= y3 & Nodes(:,3) <= y1) | ...  % Boundary 1
        (Nodes(:,3) == y1 & Nodes(:,2) >= 0 & Nodes(:,2) <= x6) | ...  % Boundary 2
        (Nodes(:,2) == x6 & Nodes(:,3) >= y6 & Nodes(:,3) <= y1) | ... % Boundary 3
        (Nodes(:,3) == y6 & Nodes(:,2) >= x6 & Nodes(:,2) <= x1) | ... % Boundary 4
        (Nodes(:,2) == x1 & Nodes(:,3) >= 0 & Nodes(:,3) <= y6) | ...  % Boundary 5
        (Nodes(:,3) == 0 & Nodes(:,2) >= x2 & Nodes(:,2) <= x1) | ...  % Boundary 6
        (Nodes(:,2) == x2 & Nodes(:,3) >= 0 & Nodes(:,3) <= y3) | ...  % Boundary 7
        (Nodes(:,3) == y3 & Nodes(:,2) >= 0 & Nodes(:,2) <= x2);       % Boundary 8

    % For boundaries, keep symbolic; others set to zero
    heatFlux(~isFurnace & ~isBoundary) = 0;

    %% Remove Outside Flux Variables

    isOutside1 = (Nodes(:,2) >= 0 & Nodes(:,2) < x2) & ...
                 (Nodes(:,3) >= 0 & Nodes(:,3) < y3);
   
    isOutside2 = (Nodes(:,2) > x6 & Nodes(:,2) <= x1) & ...
                 (Nodes(:,3) > y6 & Nodes(:,3) <= y1);
    
    isOutside = isOutside1 | isOutside2;

    isInside = ~isOutside; % Nodes that are inside the house

    % Filter only inside temperatures
    returnHeatFlux = heatFlux(isInside);
end
