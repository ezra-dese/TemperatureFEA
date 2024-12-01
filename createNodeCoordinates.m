function [node_coordinates] = createNodeCoordinates(nodes_x,nodes_y,total_nodes)

% Create a matrix to store node number, x, and y coordinates
node_coordinates = zeros(total_nodes, 3);  

% Assign node numbers and coordinates to each node
for i = 1:nodes_y
    for j = 1:nodes_x
        node_id = (i - 1) * nodes_x + j;  % Node ID

        % Calculate x and y positions
        x_position = (j - 1); 
        y_position = (i - 1);  

        % Store the node number and coordinates in the node_coordinates matrix
        node_coordinates(node_id, :) = [node_id, x_position, y_position];
    end
end
end