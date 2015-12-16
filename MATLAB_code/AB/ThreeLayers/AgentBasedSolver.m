function [fitnessMean, fitnessStd] = AgentBasedSolver(fidelityReinforcement, fidelityDecayRate, ...
    beta, alpha, runs, nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
    manufacturersSupply, distances, visibility, nRunsForAvegage, worldSize, positions)
% AgentBasedSolver
close all

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
    shipmentsMW = ShipItems_withFidelity(ordersWM, manufacturersSupply, distances{2}, alpha, fidelityWM, beta);
    shipmentsWR = ShipItems_withFidelity(ordersRW, shipmentsMW, distances{1}, alpha, fidelityRW, beta);
    
    % Fidelity update
    fidelityWM = UpdateFidelity(fidelityWM, shipmentsMW, ordersWM, fidelityReinforcement, fidelityDecayRate);
    fidelityRW = UpdateFidelity(fidelityRW, shipmentsWR, ordersRW, fidelityReinforcement, fidelityDecayRate);

    
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

% Then compute fitness of the model at steady-state
[fitnessMean, fitnessStd] = ComputeABFitness(nRunsForAvegage, beta, alpha, ...
    nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
    manufacturersSupply, distances, visibility, fidelityRW, fidelityWM);


end