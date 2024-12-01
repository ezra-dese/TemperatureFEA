function [tempSolutions,heatFluxSolutions] = formatTempSolutions(sol)

    nTemps = 0; % Counter for temperatures
    nHeatFlux = 0; % Counter for heat fluxes
    
    % Preallocate vectors for storage
    tempSolutions = [];
    heatFluxSolutions = [];
    
    % Loop through all field names in sol (Symbolic Temp Names)
    fields = fieldnames(sol);
    
    for i = 1:length(fields)
        field = fields{i};  % Get the field name (e.g., 'T1', 'q1', etc.)
        value = vpa(sol.(field));  % Get numerical value using vpa
        
        % Check if it's a temperature or heat flux variable
        if startsWith(field, 'T')  % Temperature variable
            nTemps = nTemps + 1;
            tempSolutions(nTemps, 1) = value;  %#ok<AGROW> % Store in temperature vector
        elseif startsWith(field, 'q')  % Heat flux variable
            nHeatFlux = nHeatFlux + 1;
            heatFluxSolutions(nHeatFlux, 1) = value;  %#ok<AGROW> % Store in heat flux vector
        end
    end

end