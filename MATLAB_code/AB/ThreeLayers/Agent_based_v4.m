!synclient HorizTwoFingerScroll=0

width = 2;
runs = 1e6;
probabilityGain = 0.01;
%probabilityDecay = 1e-5;

probabilitiesRW = ones(size(distances{1}));
probabilitiesWM = ones(size(distances{2}));
requestedGoodsRW = zeros(size(distances{1}));
requestedGoodsWM = zeros(size(distances{2}));

shipmentsMW = zeros(nWarehouses,1);
shipmentsWR = zeros(nRetailers,1);
demandsWM = zeros(size(probabilitiesWM,2));

[linksRetailersWarehouses, linksWarehousesManufacturers] =...
    InitialiseWorldPlot(worldSize, positions{1},...
    positions{2}, positions{3});
fitnessFigure = InitialiseFitnessPlot(NaN);

for k = 0:runs
    
    % Orders phase
    requestedGoodsRW = RequestGood(retailersDemands,probabilitiesRW);
    demandsWM = sum(requestedGoodsRW,2) ;
    requestedGoodsWM = RequestGood(demandsWM,probabilitiesWM);
    
    % Shipments phase
    shipmentsMW = ShipItems_preferential(requestedGoodsWM, manufacturersSupply, distances{2});
    shipmentsWR = ShipItems_preferential(requestedGoodsRW, shipmentsMW, distances{1});
    
    % Probabilities update
    probabilitiesWM = UpdateProbabilities_proportional(probabilitiesWM, shipmentsMW, requestedGoodsWM, distances{2}, alpha, probabilityGain);
    probabilitiesRW = UpdateProbabilities_proportional(probabilitiesRW, shipmentsWR, requestedGoodsRW, distances{1}, alpha, probabilityGain);
    
    if mod(k,1000) == 0
        
        tradeVolumeMatrixWM = requestedGoodsWM.*repmat(shipmentsMW,nManufacturers,1);
        [indexWarehousesRows,indexWarehousesCols] = find(tradeVolumeMatrixWM);
        indexWarehouses = NaN(1,nWarehouses);
        %for i = indexWarehousesCols
         %   indexWarehouses(i) = indexWarehousesRows;
        %end
        indexWarehouses(indexWarehousesCols) = indexWarehousesRows;
        tradeVolumeMatrixRW = requestedGoodsRW.*repmat(shipmentsWR,nWarehouses,1);
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