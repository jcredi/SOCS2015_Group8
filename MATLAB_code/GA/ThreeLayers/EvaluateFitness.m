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
isCustomerSatisfied = ~isnan(retailersChromosome);
flow = sum(retailersDemands(isCustomerSatisfied));
% (each end-customer either satisfies all its demand or buys nothing)


%% Transportation costs term (depends on the entire route of each item)
totalDistance = 0; % total distance travelled by shipped items

% layer 2 to layer 1
distances2to1 = distances{1};
[nWarehouses, nCustomers] = size(distances2to1);
for iCustomer = 1:nCustomers
    if isCustomerSatisfied(iCustomer)
        distanceFromWarehouse = retailersDemands(iCustomer).*distances2to1(retailersChromosome(iCustomer), iCustomer);
        totalDistance = totalDistance + distanceFromWarehouse;
    end
end    

% layer 3 to layer 2
warehousesChromosome = genome{2};
distance3to2 = distances{2};
isWarehouseRestocked = ~isnan(warehousesChromosome);
for iWarehouse = 1:nWarehouses % now warehouses are clients
    if isWarehouseRestocked(iWarehouse)
        distanceFromManufacturer = warehousesDemands(iWarehouse).*...
            distance3to2(warehousesChromosome(iWarehouse), iWarehouse);
        % note: we are deliberately allowing uncovered orders here (will be
        % taken into account by unfitness measure, as in the 2-layer GA)
        % ....but CHECK if this works!!
        totalDistance = totalDistance + distanceFromManufacturer;
    end
end

%% Sum of the two terms
fitness = flow - alpha*totalDistance;

end