function [customerLayer,storeLayer] = Restock(customerLayer,storeLayer,parameterSettings)

customerValues = customerLayer.priceHistory(end,:);
storePrices = storeLayer.priceHistory(end,:);
customerLocations = customerLayer.locations;
storeLocations = storeLayer.locations;

nbrOfCustomers = length(customerValues);
nbrOfStores = length(storePrices);

storeStock = storeLayer.stock;
customerStock = zeros(nbrOfCustomers,1);
customerSupply = zeros(1,nbrOfCustomers);

% customerBackOrders = customerLayer.backOrders;

% influx = zeros(size(customerLayer.influx));

transportationCost = parameterSettings.transportationCost;

distances = zeros(nbrOfCustomers,nbrOfStores);

for i = 1:nbrOfCustomers
    for j = 1:nbrOfStores
        distances(i,j) = norm(customerLocations(i,:) - storeLocations(j,:));
    end
end

tradeProbabilities = zeros(nbrOfCustomers,nbrOfStores);

for i = 1:nbrOfCustomers
    for j = 1:nbrOfStores
        % TODO manipulate probabilities
        tradeProbabilities(i,j) = max(0,customerValues(i) - storePrices(j) ...
            - transportationCost * distances(i,j));
        
    end
end

greed = parameterSettings.greed;

while true
    % While there are possible transactions left to perform:
    if (sum(tradeProbabilities) == 0)
        break
    end
    
    if rand() < greed
        [~,ind] = max(tradeProbabilities(:));
        [i,j] = ind2sub(size(tradeProbabilities),ind);
    else
        [i,j] = ChooseRandomIndexFromMatrix(tradeProbabilities);
    end
    
%     [i,j] = ChooseRandomIndexFromMatrix(tradeProbabilities);
    
    if storeStock(j) > 0
        customerSupply(i) = customerSupply(i) + 1;
        customerStock(i) = customerStock(i) + 1;
        
        storeStock(j) = storeStock(j) - 1;
        
%         if customerBackOrders(i) > 0
%             influx(i,j) = influx(i,j) + 1;
%             customerBackOrders(i) = customerBackOrders(i) - 1;
%         end
%         influx(i,j) = influx(i,j) + 1;
    else
        tradeProbabilities(:,j) = zeros;
    end
    
end

customerLayer.supplyHistory = [customerLayer.supplyHistory(2:end,:); customerSupply];
% customerLayer.supplyHistory = zeros(size(customerLayer.supplyHistory));
customerLayer.stock = customerStock;

% customerLayer.influx = influx;

end

