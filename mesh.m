function  [element_id, elements_x, elements_y, nodes_x, nodes_y] = mesh(global_width ...
    ,global_height,element_size)

% Number x and y elements
elements_x = global_width / element_size;
elements_y = global_height / element_size;

% Number of x and y nodes
nodes_x = elements_x + 1;
nodes_y = elements_y + 1;

% Initialize the element_id matrix
element_id = zeros(elements_y, elements_x, 4);

% Fill in element Id Matrix
    for i = 1:elements_y
        for j = 1:elements_x
            bottom_left = (i - 1) * nodes_x + j;
            bottom_right = (i - 1) * nodes_x + j + 1;
            top_left = i * nodes_x + j;
            top_right = i * nodes_x + j + 1;
            
            % Store the four corner nodes for the current element 
            element_id(i, j, :) = [bottom_left, bottom_right, top_left, top_right];
        end
    end
end