function [K_reduced,isInside,Nodes_inside] = reduceK(K,node_coords,element_size,Wall_thickness)

[X,Y] = applyGeometry(element_size,Wall_thickness);

% Find Nodes Outside
isOutside1 = (node_coords(:,2) >= 0 & node_coords(:,2) < X(2)) & ...
             (node_coords(:,3) >= 0 & node_coords(:,3) < Y(3));
       
isOutside2 = (node_coords(:,2) > X(6) & node_coords(:,2) <= X(1)) & ...
             (node_coords(:,3) > Y(6) & node_coords(:,3) <= Y(1));
        
isOutside = isOutside1 | isOutside2;
   
% Nodes that are inside the house
isInside = ~isOutside;  
 
% Get the indices of the nodes inside
insideIndices = find(isInside);  
Nodes_inside = sym(node_coords(insideIndices,1));

% Reduce the matrix A to only include rows and columns of inside nodes
K_reduced = K(insideIndices, insideIndices);  % Keep only rows and columns of inside nodes

end