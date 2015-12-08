function unfitness = EvaluateUnfitness(genome, warehousesDemands, ...
    warehousesMaxCapacity, manufacturersSupply)
% EvaluateUnfitness

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

% penalty 1: asking to manufacturers more than their supply
violatedManufacturersSupply = max(0, requestsToManufacturers - manufacturersSupply);

% penalty 2: exceeding warehouses capacity
if ~iscolumn(warehousesDemands)
    warehousesDemands = warehousesDemands';
end
violatedWarehouseCapacity = max(0, warehousesDemands - warehousesMaxCapacity);

% penalty 3: shipping uncovered items from warehouses
unsuppliedWarehouses = isnan(ordersChromosome);
unsuppliedItemsShipped = warehousesDemands(unsuppliedWarehouses);

unfitness = sum(violatedManufacturersSupply) + ...
            sum(violatedWarehouseCapacity) + ...
            sum(unsuppliedItemsShipped);
end