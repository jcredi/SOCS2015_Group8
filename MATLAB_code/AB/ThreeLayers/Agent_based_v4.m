!synclient HorizTwoFingerScroll=0

% ====================================== %
% Parameters
runs = 5e4;
fidelityReinforcement = 0.01;
fidelityDecay = 0.01; % percent
beta = 1; % controls weight of fidelity over visibility:
          % beta = 0 -> only visibility
          % beta = 1 -> same importance
          % beta = 2 -> only fidelity

% ====================================== %
% Initializations
fidelityRW = ones(size(distances{1}));
fidelityWM = ones(size(distances{2}));
ordersRW = zeros(size(distances{1}));
ordersWM = zeros(size(distances{2}));
demandsWM = zeros(size(fidelityWM,2));
shipmentsMW = zeros(nWarehouses,1);
shipmentsWR = zeros(nRetailers,1);

[linksRetailersWarehouses, linksWarehousesManufacturers] =...
    InitialiseWorldPlot(worldSize, positions{1},...
    positions{2}, positions{3});
fitnessFigure = InitialiseFitnessPlot(NaN);

% ====================================== %
% Main loop
for k = 0:runs
    
    % Orders phase (customers to suppliers)
    ordersRW = PlaceOrders(retailersDemands,fidelityRW, visibility{1}, beta);
    demandsWM = sum(ordersRW,2) ;
    ordersWM = PlaceOrders(demandsWM,fidelityWM, visibility{2}, beta);
    
    % Shipments phase (suppliers to customers)
    distanceOffsetInput = zeros(nManufacturers);
    [shipmentsMW, distanceOffsetMW] = ShipItems_withFidelity(ordersWM, manufacturersSupply, distances{2}, alpha, fidelityWM, beta, distanceOffsetInput);
    [shipmentsWR, distanceOffsetWR] = ShipItems_withFidelity(ordersRW, shipmentsMW, distances{1}, alpha, fidelityRW, beta, distanceOffsetMW);
    
    % Fidelity update
    fidelityWM = UpdateFidelity(fidelityWM, shipmentsMW, ordersWM, fidelityReinforcement, fidelityDecay);
    fidelityRW = UpdateFidelity(fidelityRW, shipmentsWR, ordersRW, fidelityReinforcement, fidelityDecay);
    
    if mod(k,2000) == 0
        
        tradeVolumeMatrixWM = ordersWM.*repmat(shipmentsMW,nManufacturers,1);
        [indexWarehousesRows,indexWarehousesCols] = find(tradeVolumeMatrixWM);
        indexWarehouses = NaN(1,nWarehouses);
        %for i = indexWarehousesCols
         %   indexWarehouses(i) = indexWarehousesRows;
        %end
        indexWarehouses(indexWarehousesCols) = indexWarehousesRows;
        tradeVolumeMatrixRW = ordersRW.*repmat(shipmentsWR,nWarehouses,1);
        [indexRetailersRows,indexRetailersCols] = find(tradeVolumeMatrixRW);
        indexRetailers = NaN(1,nRetailers);
        %for i = indexRetailersCols
         %   indexRetailers(i) = indexRetailersRows;
        %end
        indexRetailers(indexRetailersCols) = indexRetailersRows;
        
        currentSolution={indexRetailers,indexWarehouses};
        DrawMultiNetwork(currentSolution, linksRetailersWarehouses, ...
            linksWarehousesManufacturers, positions{1}, positions{2}, ...
            positions{3}, shipmentsMW);
        
        fitness = EvaluateFitness(currentSolution, retailersDemands, shipmentsMW, distances, alpha);
        UpdateFitnessPlot(fitnessFigure, k, fitness);
    end
end