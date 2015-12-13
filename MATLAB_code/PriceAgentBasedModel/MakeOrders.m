function [customerLayer,storeLayer] = MakeOrders(customerLayer,storeLayer,parameterSettings)

greed = parameterSettings.greed;

customerValues = customerLayer.priceHistory(end,:);
storePrices = storeLayer.priceHistory(end,:);
customerLocations = customerLayer.locations;
storeLocations = storeLayer.locations;

nbrOfCustomers = length(customerValues);
nbrOfStores = length(storePrices);

customerBackOrders = customerLayer.backOrders;
storeBackOrders = zeros(nbrOfStores,1);
storeDemands = zeros(1,nbrOfStores);

storeStock = storeLayer.stock;

influx = zeros(size(customerLayer.influx));

distances = zeros(nbrOfCustomers,nbrOfStores);

for i = 1:nbrOfCustomers
    for j = 1:nbrOfStores
        distances(i,j) = norm(customerLocations(i,:) - storeLocations(j,:));
    end
end



transportationCost = parameterSettings.transportationCost;

% TODO
% greed = 1;

% tradeProbabilities = GenerateTradeProbabilities(customerValues,storePrices,transportationCost,distances,greed);
% 
% 
tradeProbabilities = zeros(nbrOfCustomers,nbrOfStores);

for i = 1:nbrOfCustomers
    for j = 1:nbrOfStores
        tradeProbabilities(i,j) = max(0,customerValues(i) - storePrices(j) ...
            - transportationCost * distances(i,j));
        
        % TODO manipulate trade probabilities;
    end
end


while true
    % While there are possible transactions left to perform:
    if (sum(tradeProbabilities) == 0)
        break
    end
    
    if rand() < greed
        [~,ind] = max(tradeProbabilities(:));
        [i,j] = ind2sub(size(tradeProbabilities),ind);
%         
% [maxA,ind] = max(A(:));
% [m,n] = ind2sub(size(A),ind)
    else
        [i,j] = ChooseRandomIndexFromMatrix(tradeProbabilities);
    end
        
    
    if customerBackOrders(i) > 0
        
        while customerBackOrders(i) > 0
            
            storeBackOrders(j) = storeBackOrders(j) + 1;
            storeDemands(j) = storeDemands(j) + 1;
            
            customerBackOrders(i) = customerBackOrders(i) - 1;
            %         influx(i,j) = influx(i,j) + 1;
            if storeStock(j) > 0
                influx(i,j) = influx(i,j) + 1;
                storeStock(j) = storeStock(j) - 1;
            end
            
        end
        tradeProbabilities(i,:) = zeros;
        
    else
        tradeProbabilities(i,:) = zeros;
    end
end

storeLayer.demandHistory = [storeLayer.demandHistory(2:end,:); storeDemands];
storeLayer.backOrders = storeBackOrders;

customerLayer.influx = influx;

end



