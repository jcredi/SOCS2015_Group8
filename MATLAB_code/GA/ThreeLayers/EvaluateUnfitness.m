function unfitness = EvaluateUnfitness(genome, warehousesDemands, ...
    warehousesMaxCapacity, manufacturersSupply)

requestsToManufacturers = zeros(size(manufacturersSupply));
ordersChromosome = genome{2};

nWarehouses = length(warehousesDemands);
for iWarehouse = 1:nWarehouses
    manufacturerCalled = ordersChromosome(iWarehouse);
    if ~isnan(manufacturerCalled)
        requestsToManufacturers(manufacturerCalled) = ...
            requestsToManufacturers(manufacturerCalled) + warehousesDemands(iWarehouse);
    end
end

% penalty 1
violatedManufacturersSupply = max(0, requestsToManufacturers - manufacturersSupply);

% penalty 2
violatedWarehouseCapacity = max(0, warehousesDemands - warehousesMaxCapacity);


unfitness = sum(violatedManufacturersSupply) + sum(violatedWarehouseCapacity);
end