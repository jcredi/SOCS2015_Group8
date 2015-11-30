function warehousesDemands = EvaluateWarehousesDemands(genome, nWarehouses, retailersDemands)

warehousesDemands = zeros(nWarehouses,1); % items bought in each store
retailersOrders = genome{1};
nRetailers = length(retailersOrders);

for iRetailer = 1:nRetailers
    warehouseCalled = retailersOrders(iRetailer); % store visited by current customer
    if ~isnan(warehouseCalled)
        warehousesDemands(warehouseCalled) = warehousesDemands(warehouseCalled) + ...
            retailersDemands(iRetailer);
    end
    
end

end