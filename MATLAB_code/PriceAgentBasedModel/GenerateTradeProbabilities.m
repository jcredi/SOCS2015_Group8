function tradeProbabilities = GenerateTradeProbabilities(customerValues,storePrices,transportationCost,...
    customerLocations,storeLocations)

%GENERATETRADEPROBABILITIES Summary of this function goes here
%   Detailed explanation goes here

% transportationCost = parameterSettings.transportationCost;

nbrOfCustomers = length(customerValues);
nbrOfStores = length(storePrices);

distances = zeros(nbrOfCustomers,nbrOfStores);

for i = 1:nbrOfCustomers
    for j = 1:nbrOfStores
        distances(i,j) = norm(customerLocations(i,:) - storeLocations(j,:));
    end
end




tradeProbabilities = zeros(nbrOfCustomers,nbrOfStores);

for i = 1:nbrOfCustomers
    for j = 1:nbrOfStores
        tradeProbabilities(i,j) = max(0,customerValues(i) - storePrices(j) ...
            - transportationCost * distances(i,j));
        % TODO manipulate trade probabilities;
    end
end




end

