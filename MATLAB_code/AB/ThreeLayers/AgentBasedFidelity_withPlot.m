%% AgentBasedFidelity_withPlot
close all; clc;

% Parameters
fidelityReinforcement = 0.01;%logspace(-3,-1,7);
fidelityDecayRate = 0.01;
beta = 1;
alpha = 0.5;
runs = 25000;

% ====================================== %
% Initializations
fidelityRW = ones(size(distances{1}));
fidelityWM = ones(size(distances{2}));

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
    [shipmentsWR, ~] = ShipItems_withFidelity(ordersRW, shipmentsMW, distances{1}, alpha, fidelityRW, beta, distanceOffsetMW);
    
    % Fidelity update
    fidelityWM = UpdateFidelity(fidelityWM, shipmentsMW, ordersWM, fidelityReinforcement, fidelityDecayRate);
    fidelityRW = UpdateFidelity(fidelityRW, shipmentsWR, ordersRW, fidelityReinforcement, fidelityDecayRate);
    
    if mod(k,500) == 0
        
        tradeVolumeMatrixWM = ordersWM.*repmat(shipmentsMW,nManufacturers,1);
        [indexWarehousesRows,indexWarehousesCols] = find(tradeVolumeMatrixWM);
        indexWarehouses = NaN(1,nWarehouses);
        
        indexWarehouses(indexWarehousesCols) = indexWarehousesRows;
        tradeVolumeMatrixRW = ordersRW.*repmat(shipmentsWR,nWarehouses,1);
        [indexRetailersRows,indexRetailersCols] = find(tradeVolumeMatrixRW);
        indexRetailers = NaN(1,nRetailers);
        
        indexRetailers(indexRetailersCols) = indexRetailersRows;
        
        currentSolution={indexRetailers,indexWarehouses};
        DrawMultiNetwork(currentSolution, linksRetailersWarehouses, ...
            linksWarehousesManufacturers, positions{1}, positions{2}, ...
            positions{3}, shipmentsMW);
        
        fitness = EvaluateFitness(currentSolution, retailersDemands, shipmentsMW, distances, alpha);
        UpdateFitnessPlot(fitnessFigure, k, fitness);
    end
end

% % Then compute fitness of the model at steady-state
% [fitnessMean, fitnessStd] = ComputeABFitness_fidelity(nRunsForAverage, beta, alpha, ...
%     nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
%     manufacturersSupply, distances, visibility, fidelityRW, fidelityWM);

