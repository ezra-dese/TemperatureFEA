function Solution = compileSolution(nodesInside,solvedTemperatures, ...
    outsideTemp, x_cords_inside, y_cords_inside)

% Initialize Temp with the correct size
Temp = zeros(height(nodesInside), 1);  
counter = 0;  % Initialize counter for solved Temperatures

% Loop through each row of Nodes_inside
for i = 1:height(nodesInside)
    % Check if the current value is symbolic and equivalent to -26
    if isequal(nodesInside(i,2), sym(outsideTemp))
        Temp(i,1) = outsideTemp;  % Assign outsideTemp for -26 symbolic entries
    else
        counter = counter + 1;  % Increment the counter
        Temp(i,1) = solvedTemperatures(counter);  % Assign value from TempsSolutions
    end
end

Temp = double(Temp);

Solution = [Temp, x_cords_inside, y_cords_inside];


end