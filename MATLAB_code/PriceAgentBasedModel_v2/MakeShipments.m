function layer = MakeShipments( layer, parameterSettings)
%MAKESHIPMENTS Summary of this function goes here
%   Detailed explanation goes here

retailerDemands = layer(1).demand;

manufacturerSupply = layer(3).supply;

transportationCost = parameterSettings.transportationCost;

retailerPrices = layer(1).prices;
warehousePrices = layer(2).prices;
manufacturerPrices = layer(3).prices;

retailerLocations = layer(1).locations;
warehouseLocations = layer(2).locations;
manufacturerLocations = layer(3).locations;

nbrOfRetailers = length(retailerPrices);
nbrOfWarehouses = length(warehousePrices);
nbrOfManufacturers = length(manufacturerPrices);

shipmentToRetailerFromWarehouse = zeros(nbrOfRetailers,nbrOfWarehouses);
shipmentToWarehouseFromManufacturer = zeros(nbrOfWarehouses,nbrOfManufacturers);


feasabilityTransactionRetailerWarehouse = zeros(nbrOfRetailers,nbrOfWarehouses);

feasabilityTransactionWarehouseManufacturer = zeros(nbrOfWarehouses,nbrOfManufacturers);

distancesRetailerWarehouse = pdist2(retailerLocations,warehouseLocations);
distancesWarehouseManufacturer = pdist2(warehouseLocations,manufacturerLocations);

for iRetailer = 1:nbrOfRetailers
    for jWarehouse = 1:nbrOfWarehouses
        feasabilityTransactionRetailerWarehouse(iRetailer,jWarehouse) = ...
            max(0,retailerPrices(iRetailer) - warehousePrices(jWarehouse) ...
            - transportationCost * distancesRetailerWarehouse(iRetailer,jWarehouse));
    end
end

for iWarehouse = 1:nbrOfWarehouses
    for jManufacturer = 1:nbrOfManufacturers
        feasabilityTransactionWarehouseManufacturer(iWarehouse,jManufacturer) = ...
            max(0,warehousePrices(iWarehouse) - manufacturerPrices(jManufacturer) ...
            - transportationCost * distancesWarehouseManufacturer(iWarehouse,jManufacturer));
    end
end


loopDone = false;
ctr = 0;
% 'STARTING LOOP'
while ~loopDone
    ctr = ctr + 1;
%     ctr
    
    % Check if there are any feasable transactions between retailers and
    % Warehouses:
    if sum(feasabilityTransactionRetailerWarehouse(:)) == 0
%         'NOT OK!'
        break
    end
        
    
    % Beginning at retailer end:
    [~,ind] = max(feasabilityTransactionRetailerWarehouse(:));
    [iRetailer,jWarehouse] = ind2sub(size(feasabilityTransactionRetailerWarehouse),ind);
    
    % Check if iRetailer is OK:
    if ~retailerDemands(iRetailer) > 0
%         'retailer NOT OK!'
        feasabilityTransactionRetailerWarehouse(iRetailer,:) = zeros;
        continue
    end
    
    % Check if jWarehouse is OK:
    if sum(feasabilityTransactionWarehouseManufacturer(jWarehouse,:)) > 0
%         'warehouse NOT OK!'
        [~,kManufacturer] = max(feasabilityTransactionWarehouseManufacturer(jWarehouse,:));
    else
        feasabilityTransactionRetailerWarehouse(:,jWarehouse) = zeros;
        continue
    end
    
    % Check if kManufacturer is OK:
    if ~manufacturerSupply(kManufacturer) > 0
%         'Manufacturer NOT OK!'
        feasabilityTransactionWarehouseManufacturer(:,kManufacturer) = zeros;
        continue
    end
    
    % Make sure jWarehouse can only choose kManufacturer:
    tempFeasability = feasabilityTransactionWarehouseManufacturer(jWarehouse,kManufacturer);
    feasabilityTransactionWarehouseManufacturer(jWarehouse,:) = zeros;
    feasabilityTransactionWarehouseManufacturer(jWarehouse,kManufacturer) = tempFeasability;
    
    
    
    retailerDemands(iRetailer) = retailerDemands(iRetailer) - 1;
    manufacturerSupply(kManufacturer) = manufacturerSupply(kManufacturer) - 1;
    
    shipmentToRetailerFromWarehouse(iRetailer,jWarehouse) = ...
        shipmentToRetailerFromWarehouse(iRetailer,jWarehouse) + 1;
    
    shipmentToWarehouseFromManufacturer(jWarehouse,kManufacturer) = ...
        shipmentToWarehouseFromManufacturer(jWarehouse,kManufacturer) + 1;
    
    
    
    
    
    % Beginning at manufacturer end:
    
    
    
    
end

layer(1).influx = shipmentToRetailerFromWarehouse;
layer(2).influx = shipmentToWarehouseFromManufacturer;



end

% 
% 
% 
% customerPrices = customerLayer.prices;
% storePrices = storeLayer.prices;
% 
% 
% customerLocations = customerLayer.locations;
% storeLocations = storeLayer.locations;
% 
% nbrOfCustomers = length(customerPrices);
% nbrOfStores = length(storePrices);
% 
% storeStock = storeLayer.supply;
% 
% %TODO do not put this parameter here!
% % decay = 0.2;
% 
% decay = parameterSettings.decay;
% customerSupply = customerLayer.supply * (1 - decay);
% 
% % customerSupply = zeros(1,nbrOfCustomers);
% 
% % customerBackOrders = customerLayer.backOrders;
% 
% % influx = zeros(size(customerLayer.influx));
% 
% transportationCost = parameterSettings.transportationCost;
% 
% nbrOfOrders = sum(storeStock);
% 
% % randomTransactions = zeros(1,nbrOfOrders);
% iTransaction = 1;
% 
% 
% % 
% %     function UpdateRandomTransactions()
% %         if sum(tradeProbabilities(:)) > 0 
% %             randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
% %         end
% %     end
% 
% 
% %     function [i,j] = ChooseTransaction()
% %         transaction = randomTransactions(iTransaction);
% %         [i,j] = ind2sub(size(tradeProbabilities),transaction);
% %         iTransaction = iTransaction + 1;
% %     end
% 
% 
% 
% 
% 
% % 
% % distances = zeros(nbrOfCustomers,nbrOfStores);
% % 
% % for i = 1:nbrOfCustomers
% %     for j = 1:nbrOfStores
% %         distances(i,j) = norm(customerLocations(i,:) - storeLocations(j,:));
% %     end
% % end
% 
% distances = customerLayer.distances;
% 
% 
% tradeProbabilities = zeros(nbrOfCustomers,nbrOfStores);
% 
% for i = 1:nbrOfCustomers
%     for j = 1:nbrOfStores
%         % TODO manipulate probabilities
%         tradeProbabilities(i,j) = max(0,customerPrices(i) - storePrices(j) ...
%             - transportationCost * distances(i,j));
%         
%     end
% end
% 
% % greed = parameterSettings.greed;
% 
% % UpdateRandomTransactions()
% 
% while iTransaction < nbrOfOrders
%     % While there are possible transactions left to perform:
%     if (sum(tradeProbabilities) == 0)
%         break
%     end
%     
%     [~,ind] = max(tradeProbabilities(:));
%     [i,j] = ind2sub(size(tradeProbabilities),ind);
%     % --------------Random start------------------------%
%     %     if rand() < greed
%     %         [~,ind] = max(tradeProbabilities(:));
%     %         [i,j] = ind2sub(size(tradeProbabilities),ind);
%     %     else
%     % %         [i,j] = ChooseTransaction();
%     %         % Choose a random transaction:
%     %         transaction = randomTransactions(iTransaction);
%     %         [i,j] = ind2sub(size(tradeProbabilities),transaction);
%     %         iTransaction = iTransaction + 1;
%     %
%     
%     % --------------Random end------------------------%
%     
%     
%     %         [i,j] = ChooseRandomIndexFromMatrix(tradeProbabilities);
%     % end
%     
%     if storeStock(j) > 0
%         customerSupply(i) = customerSupply(i) + 1*decay;
%         storeStock(j) = storeStock(j) - 1;
%         
%         %         if customerBackOrders(i) > 0
%         %             influx(i,j) = influx(i,j) + 1;
%         %             customerBackOrders(i) = customerBackOrders(i) - 1;
%         %         end
%         %         influx(i,j) = influx(i,j) + 1;
%     else
%         tradeProbabilities(:,j) = zeros;
%         %         UpdateRandomTransactions();
%     end
% end
% 
% customerLayer.supply = customerSupply;
% 
% 
% 
% 
% 
