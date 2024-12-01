function ESM = elementStiffnessMatricies(elements_y, elements_x,material_matrix, ...
    elementArea,element_width,element_height)

a = element_width;
b = element_height;

ESM = cell(elements_y, elements_x);

for i = 1:elements_y
    for j = 1:elements_x
        % Get the material constant
        k = material_matrix(i, j);  % Use the value directly from the material matrix
        
        % Compute the scaling factor for the current element stiffness matrix
        factor = (k./(6.*elementArea));

        % Define the local stiffness matrix K(e) for the current element
        KI = factor * [ ...
            2*(a^2 + b^2),   (a^2 - 2*b^2),   -(a^2 + b^2),   -(2*a^2 - b^2);
            (a^2 - 2*b^2),   2*(a^2 + b^2),   -(2*a^2 - b^2),  -(a^2 + b^2);
            -(a^2 + b^2), -(2*a^2 - b^2), 2*(a^2 + b^2), (a^2 - 2*b^2);
            -(2*a^2 - b^2), -(a^2 + b^2), (a^2 - 2*b^2), 2*(a^2 + b^2)
        ];

        % Store the local stiffness matrix
        ESM{i, j} = KI;
    end
end

end