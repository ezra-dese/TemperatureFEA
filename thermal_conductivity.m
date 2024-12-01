function [A] = thermal_conductivity(elementSize, K_air, K_window, K_wall,Wall_thickness)
%% Define Constants

% Call in Grid X and Y Points
[X,Y] = applyGeometry(elementSize,Wall_thickness);

% Assign X Critical Points
x1 = X(1);
x2 = X(2);
x3 = X(3);
x4 = X(4);
x5 = X(5);
x6 = X(6);
x7 = X(7);

% Assign Y Critical Points 
y1 = Y(1);
y2 = Y(2);
y3 = Y(3);
y4 = Y(4);
y5 = Y(5);
y6 = Y(6);
y7 = Y(7);
y8 = Y(8);

%% Build Structures on the Grid

% Grid of zeros for outer boundary
A = zeros(x1,y1);

% Walls:
A(1:y4,x2:x3) = K_wall;
A(1:y6,x5:x1) = K_wall;
A(y5:y6,x7:x1) = K_wall;
A(y7:y1,1:x6) = K_wall;
A(y4:y1,1:x4) = K_wall;

% Windows: 
A(y3:y4,1:x2) = K_window;
A(1:y2,x3:x5) = K_window;
A(y6:y7,x7:x6) = K_window;

% Fill in Air Indoors
A(A == 0) = K_air;

% Outer Boundary (Outside Regions)
A(1:y3, 1:x2) = 0; 
A(y6:y1, x6:x1) = 0;

end