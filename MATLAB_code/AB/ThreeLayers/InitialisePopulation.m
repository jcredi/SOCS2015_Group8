function population = InitialisePopulation(populationSize, nLayers, facilitiesPerLayer)
% InitialisePopulation
% In theory, this function should work for a supply chain of any given size

population = cell(populationSize, 1);

for iIndividual = 1:populationSize % for each individual
    
    population{iIndividual} = cell(nLayers-1,1); % create N-1 chromosomes

    for iLayer = 2:nLayers % for each chromosome

        nClients = facilitiesPerLayer(iLayer-1);
        nSuppliers = facilitiesPerLayer(iLayer);
    
        chromosome = randi(nSuppliers+1, 1, nClients);
        chromosome(chromosome == nSuppliers +1) = NaN; % allow empty supplier field
        population{iIndividual}{iLayer-1} = chromosome;
        
    end
end
    


end