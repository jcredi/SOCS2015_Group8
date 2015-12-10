!synclient HorizTwoFingerScroll=0

kappa = 0.01;
width = 0.2;
runs = 1e0;
probabilitiesRW = exp(-distances{1}.^2 / width^2);
probabilitiesWM = exp(-distances{2}.^2 / width^2);
requestedGoodsRW = zeros(size(probabilitiesRW));
requestedGoodsWM = zeros(size(probabilitiesWM));
shipmentsMW = zeros(nWarehouses,1);
shipmentsWR = zeros(nRetailers,1);
demandsWM = zeros(size(probabilitiesWM,2));
for k = 0:runs
    requestedGoodsRW = RequestGood(retailersDemands,probabilitiesRW);
    demandsWM = sum(requestedGoodsRW,2) ;
    requestedGoodsWM = RequestGood(demandsWM,probabilitiesWM);
    shipmentsMW = ShipItems(requestedGoodsWM, manufacturersSupply);
    shipmentsWR = ShipItems(requestedGoodsRW, shipmentsMW);
end

disp(shipmentsWR);