%% Main FEA script description

% This script runs the entire simulation, calling on the various different
% functions for running the simulation. There are 11 different functions 
% associated with this script - see readme, report or open them up to learn
% more about them. 
% 
% In this file there are 8 controllable paramters:
% - Outside Temperature
% - Furnance Heat Flux
% - element size
% - global width
% - global height
% - wall thickness
% - k air
% - k water
% - k wall
% - Customizing this allows you to customize the FE solution
% Some reccomendations: 
% - For Optimal results use 0.5 element size for coarse mesh and use 0.25
% for fine mesh. Usually going to 0.1 element size may take too much time


%% Initialize Matlab
close all
clc
clear all

%% Set Parameters

% House Conditions 
outsideTemp = -26; % (C)
furnaceFlux = 200; % (W/m2)

% Initalize Square Elements
element_size = 0.5; % Element Size (m)

a = element_size; % Element Length (m)     
b = a; % Element Height (m)       
elementArea = a * b; % Element Area (m2)

% House Paramaters (m)
global_width = 14; 
global_height = 8;
Wall_thickness = 0.5;

% Thermal Conductivity Values (W/mK)
K_air = 0.0025;    
K_window = 0.6;   
K_wall = 0.08;

% Apply House Geometry
[X,Y] = applyGeometry(element_size,Wall_thickness);

%% Discretization

% Generate Mesh with Mesh Function
[element_id, elements_x, elements_y, nodes_x, nodes_y] = mesh( ...
    global_width,global_height,element_size);

% Calculate Total Number of Nodes
total_nodes = nodes_x * nodes_y;

% Assign Each Node a Coordinate
node_coords = createNodeCoordinates(nodes_x,nodes_y,total_nodes);

% Generate Thermal Conductivity Matrix For each element
material_matrix = thermal_conductivity(element_size, K_air, K_window, ...
    K_wall, Wall_thickness);

% Create ESM and assign to each node based off material
element_stiffness_matrices = elementStiffnessMatricies(elements_y, ...
    elements_x,material_matrix, elementArea, a, b);

% Total number of nodes
total_nodes = nodes_x * nodes_y;
disp('Total Number of Nodes: ')
disp(total_nodes)

%% Create Global Stiffness Matrix

% Initialize the global stiffness matrix
    K = sym(zeros(nodes_x * nodes_y));
    
    for i = 1:elements_y
        for j = 1:elements_x
            
            % Get the node IDs for the current element's 4 corners
            krow = squeeze(element_id(i, j, :))'; % Get row nodes for the element, transpose to ensure it's a row vector
            kcol = krow;  % The column nodes are the same for symmetry in stiffness matrix
            
            % Retrieve the pre-calculated element stiffness matrix for the current element
            KI = element_stiffness_matrices{i, j};
    
            % Add the local stiffness matrix (KI) to the global stiffness matrix (K)
            K(krow, kcol) = K(krow, kcol) + KI;
        end
    end

%% Reduce Global Stiffness Matrix

% Reduce The Global Stifness Matrix to nodes inside the house
[K_reduced, isInside, Nodes_inside] = reduceK(K,node_coords, ...
    element_size, Wall_thickness);

disp('Reduced stiffness matrix:');
disp(size(K_reduced));

% Store coordinates of nodes in a seperate variable 
x_cords = node_coords(:,2);
y_cords = node_coords(:,3);

% Store coordinates of nodes inside the house
x_cords_inside = x_cords(isInside);
y_cords_inside = y_cords(isInside);

%% Apply Boundary Conditions

% Apply Temperature Boundary Condtions
T = ApplyTempBCs(node_coords, element_size, Wall_thickness, outsideTemp);

% Apply Heat Flux Boundary Conditions
q = ApplyHeatFluxBCs(node_coords, element_size, Wall_thickness, ...
    furnaceFlux, elementArea);

% Add the q and T vectors inside the house to Nodes_inside
Nodes_inside(:,2) = T;
Nodes_inside(:,3) = q;

%% Solve System of Equations:

% Write System of Equations
eqns = K_reduced * T == q;

% Solve System of Equations
sol = solve(eqns); 

%% Format and Compile Solutions

% Format Solutions
[tempSolutions,heatFluxSolutions] = formatTempSolutions(sol);

% Compile Solved Solutions and Known Temperatures (outside Temp)
Sol_plot = compileSolution(Nodes_inside, tempSolutions, outsideTemp, ...
    x_cords_inside, y_cords_inside);

%% Plot temperature heatmap

% Plot Temperature distribution
solutionHeatmap(Sol_plot,element_size, Wall_thickness)