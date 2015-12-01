function fitness = EvaluateFitness(genome, retailersDemands, warehousesDemands, distances, alpha)
% EvaluateFitness
% Fitness measure: 
%    +----------------------------------------------+
%    | flow of items - alpha*(transportation costs) |
%    +----------------------------------------------+
% where alpha is the cost of transporting one item per unit distance
% (investigating the effect of alpha is one of the goals of the project)


%% Flow term (only depends on end-customers)
retailersChromosome = genome{1};
isRetailerSatisfied = ~isnan(retailersChromosome);
flow = sum(retailersDemands(isRetailerSatisfied));
% (each end-customer either satisfies all its demand or buys nothing)


%% Transportation costs term (depends on the entire route of each item)
totalDistance = 0; % total distance travelled by shipped items

% layer 2 to layer 1
[nWarehouses, nRetailers] = size(distances{1});
for iRetailers = 1:nRetailers
    if isRetailerSatisfied(iRetailers)
        distanceFromWarehouse = retailersDemands(iRetailers).*distances{1}(retailersChromosome(iRetailers), iRetailers);
        totalDistance = totalDistance + distanceFromWarehouse;
    end
end    


% layer 3 to layer 2
warehousesChromosome = genome{2};
isWarehouseRestocked = ~isnan(warehousesChromosome);
for iWarehouse = 1:nWarehouses % now warehouses are clients
    if isWarehouseRestocked(iWarehouse)
        distanceFromManufacturer = warehousesDemands(iWarehouse).*...
            distances{2}(warehousesChromosome(iWarehouse), iWarehouse);
        % note: we are deliberately allowing uncovered orders here (will be
        % taken into account by unfitness measure, as in the 2-layer GA)
        % ....but CHECK if this works!!
        totalDistance = totalDistance + distanceFromManufacturer;
    end
end

%% Sum of the two terms
fitness = flow - alpha*totalDistance;

end