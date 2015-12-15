!synclient HorizTwoFingerScroll=0

kappa = 0.01;
%<<<<<<< HEAD
width = 2;
runs = 1e4;
%=======
width = 1.0;
runs = 1e5;
probabilityGain = 0.1;
probabilityDecay = 1e-3;

%>>>>>>> c5610a0cb7002f52d3177861ae61e4be436cfbeb
probabilitiesRW = exp(-distances{1}.^2 / width^2);
probabilitiesWM = exp(-distances{2}.^2 / width^2);
probabilitiesRW = probabilitiesRW./repmat(sum(probabilitiesRW,1),nWarehouses,1);
probabilitiesWM = probabilitiesWM./repmat(sum(probabilitiesWM,1),nManufacturers,1);
requestedGoodsRW = zeros(size(probabilitiesRW));
requestedGoodsWM = zeros(size(probabilitiesWM));
shipmentsMW = zeros(nWarehouses,1);
shipmentsWR = zeros(nRetailers,1);
demandsWM = zeros(size(probabilitiesWM,2));

FitnessFigure = InitialiseFitnessPlot(NaN);



[linksRetailersWarehouses, linksWarehousesManufacturers] =...
    InitialiseWorldPlot(worldSize, positions{1},...
    positions{2}, positions{3});

for k = 0:runs
    requestedGoodsRW = RequestGood(retailersDemands,probabilitiesRW);
    demandsWM = sum(requestedGoodsRW,2) ;
    requestedGoodsWM = RequestGood(demandsWM,probabilitiesWM);
    shipmentsMW = ShipItems(requestedGoodsWM, manufacturersSupply);
    shipmentsWR = ShipItems(requestedGoodsRW, shipmentsMW);
    probabilitiesWM = UpdateProbabilities_proportional(probabilitiesWM, shipmentsMW, ...
        requestedGoodsWM, distances{2}, alpha, probabilityGain) ;
    probabilitiesRW = UpdateProbabilities_proportional(probabilitiesRW, shipmentsWR, ...
        requestedGoodsRW, distances{1}, alpha, probabilityGain) ;
    if mod(k,100) == 0
        
        tradeVolumeMatrixWM = requestedGoodsWM.*repmat(shipmentsMW,nManufacturers,1);
        [indexWarehousesRows,indexWarehousesCols] = find(tradeVolumeMatrixWM);
        indexWarehouses = NaN(1,nWarehouses);
        indexWarehouses(indexWarehousesCols) = indexWarehousesRows;
        tradeVolumeMatrixRW = requestedGoodsRW.*repmat(shipmentsWR,nWarehouses,1);
        [indexRetailersRows,indexRetailersCols] = find(tradeVolumeMatrixRW);
        indexRetailers = NaN(1,nRetailers);
        indexRetailers(indexRetailersCols) = indexRetailersRows;
        bestSolution={indexRetailers,indexWarehouses};
        
        fitness = EvaluateFitness(bestSolution,retailersDemands,shipmentsMW, distances, alpha);
        UpdateFitnessPlot(FitnessFigure, k, fitness);
        DrawMultiNetwork(bestSolution, linksRetailersWarehouses, ...
            linksWarehousesManufacturers, positions{1}, positions{2}, ...
            positions{3}, shipmentsMW);
    end
end