function solutionHeatmap(solution,elementSize,wallThickness)
%% Function Description: solutionHeatmap
    %  Takes in a matrix with the temperature distribution, x coords and y
    %  coords. 
    %  Inputs:
        % "Solution" - Matrix with temp, x-cords and y-coords
    %  Outputs:
    %    Heatmap

[X_crit,Y_crit] = applyGeometry(elementSize,wallThickness);

% Extract temperature, x, and y coordinates from solution matrix
Temperature = solution(:,1);
x_coords = solution(:,2) * elementSize;  % Convert to meters
y_coords = solution(:,3) * elementSize;  % Convert to meters

% Create a grid for x and y
x_unique = unique(x_coords);
y_unique = unique(y_coords);
[X, Y] = meshgrid(x_unique, y_unique);

% Interpolate temperature values on the grid
Z = griddata(x_coords, y_coords, Temperature, X, Y, 'cubic');

% Convert boundary values to meters
x2_m = X_crit(2) * elementSize;
x6_m = X_crit(6) * elementSize;
x1_m = X_crit(1) * elementSize;
y3_m = Y_crit(3) * elementSize;
y6_m = Y_crit(6) * elementSize;
y1_m = Y_crit(1) * elementSize;

% Mask data outside the house boundaries
isOutside1 = (X >= 0 & X < x2_m) & (Y >= 0 & Y < y3_m);
isOutside2 = (X > x6_m & X <= x1_m) & (Y > y6_m & Y <= y1_m);
isOutside = isOutside1 | isOutside2;

% Set temperatures outside the house to NaN
Z(isOutside) = NaN;

% Plot temperature distribution using surf
figure;
surf(X, Y, Z, 'EdgeColor', 'none');
colormap('jet');  % Use 'jet' colormap for heatmap
colorbar;  % Add colorbar
title('Temperature Distribution');
xlabel('X Coordinate (m)');
ylabel('Y Coordinate (m)');
view(2);  % 2D view for heatmap
hold on;

% Plot boundaries in meters
plot3([0, 0], [y3_m, y1_m], [max(Z(:)), max(Z(:))], 'k', 'LineWidth', 2);
plot3([0, x6_m], [y1_m, y1_m], [max(Z(:)), max(Z(:))], 'k', 'LineWidth', 2);
plot3([x6_m, x6_m], [y6_m, y1_m], [max(Z(:)), max(Z(:))], 'k', 'LineWidth', 2);
plot3([x6_m, x1_m], [y6_m, y6_m], [max(Z(:)), max(Z(:))], 'k', 'LineWidth', 2);
plot3([x1_m, x1_m], [0, y6_m], [max(Z(:)), max(Z(:))], 'k', 'LineWidth', 2);
plot3([x2_m, x1_m], [0, 0], [max(Z(:)), max(Z(:))], 'k', 'LineWidth', 2);
plot3([x2_m, x2_m], [0, y3_m], [max(Z(:)), max(Z(:))], 'k', 'LineWidth', 2);
plot3([0, x2_m], [y3_m, y3_m], [max(Z(:)), max(Z(:))], 'k', 'LineWidth', 2);

hold off;
axis equal;  % Ensure equal scaling on both axes

end