function [fitnessMean, fitnessStd] = ComputeABFitness(nRunsForAvegage, beta, alpha, ...
    nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
    manufacturersSupply, distances, visibility, fidelityRW, fidelityWM)
% ComputeABFitness

fitness = zeros(nRunsForAvegage,1);

for k = 1:nRunsForAvegage
    
    % Orders phase (customers to suppliers)
    ordersRW = PlaceOrders(retailersDemands,fidelityRW, visibility{1}, beta);
    demandsWM = sum(ordersRW,2) ;
    ordersWM = PlaceOrders(demandsWM,fidelityWM, visibility{2}, beta);
    
    % Shipments phase (suppliers to customers)
    distanceOffsetInput = zeros(nManufacturers);
    [shipmentsMW, distanceOffsetMW] = ShipItems_withFidelity(ordersWM, manufacturersSupply, distances{2}, alpha, fidelityWM, beta, distanceOffsetInput);
    [shipmentsWR, distanceOffsetWR] = ShipItems_withFidelity(ordersRW, shipmentsMW, distances{1}, alpha, fidelityRW, beta, distanceOffsetMW);
    
    % Do NOT update fidelity here
    
    % Instead, evaluate solution!
        
    tradeVolumeMatrixWM = ordersWM.*repmat(shipmentsMW,nManufacturers,1);
    [indexWarehousesRows,indexWarehousesCols] = find(tradeVolumeMatrixWM);
    indexWarehouses = NaN(1,nWarehouses);

    indexWarehouses(indexWarehousesCols) = indexWarehousesRows;
    tradeVolumeMatrixRW = ordersRW.*repmat(shipmentsWR,nWarehouses,1);
    [indexRetailersRows,indexRetailersCols] = find(tradeVolumeMatrixRW);
    indexRetailers = NaN(1,nRetailers);
    indexRetailers(indexRetailersCols) = indexRetailersRows;

    currentSolution={indexRetailers,indexWarehouses};

    fitness(k) = EvaluateFitness(currentSolution, retailersDemands, shipmentsMW, distances, alpha);

end

fitnessMean = mean(fitness); 
fitnessStd = std(fitness); 
        
end