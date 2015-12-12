!synclient HorizTwoFingerScroll=0

width = 2;
runs = 5e5;
probabilityReinforcement = 0.01;
probabilityDecay = 0.01; % percent

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
    requestedGoodsRW = PlaceOrders(retailersDemands,probabilitiesRW, visibility{1});
    demandsWM = sum(requestedGoodsRW,2) ;
    requestedGoodsWM = PlaceOrders(demandsWM,probabilitiesWM, visibility{2});
    
    % Shipments phase
    shipmentsMW = ShipItems_preferential(requestedGoodsWM, manufacturersSupply, distances{2}, alpha);
    shipmentsWR = ShipItems_preferential(requestedGoodsRW, shipmentsMW, distances{1}, alpha);
    
    % Probabilities update
    probabilitiesWM = UpdateProbabilities_new(probabilitiesWM, shipmentsMW, requestedGoodsWM, probabilityReinforcement, probabilityDecay);
    probabilitiesRW = UpdateProbabilities_new(probabilitiesRW, shipmentsWR, requestedGoodsRW, probabilityReinforcement, probabilityDecay);
    
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