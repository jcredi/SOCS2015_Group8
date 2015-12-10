function totalCost = CalculateTransportationCosts(layer,parameterSettings)
%CALCULATETRANSPORTATIONCOSTS Summary of this function goes here
%   Detailed explanation goes here


nbrOfLayers = length(layer);

totalDistanceTravelled = 0;

transportationCost = parameterSettings.transportationCost;



for iLayer = 1:nbrOfLayers - 1
    
%     numberOfCustomers = length(layer(iLayer).prices);
%     numberOfStores = length(layer(iLayer + 1).prices);
    
    influx = layer(iLayer).influx;

    [numberOfCustomers,numberOfStores] = size(influx);
    
    customerLocations = layer(iLayer).locations;
    storeLocations = layer(iLayer + 1).locations;
    
    distances = zeros(numberOfCustomers,numberOfStores);
    
    for i = 1:numberOfCustomers
        for j = 1:numberOfStores
            distances(i,j) = norm(customerLocations(i,:) - storeLocations(j,:));
        end
    end
    
    for i = 1:numberOfCustomers
        for j = 1:numberOfStores
            totalDistanceTravelled = totalDistanceTravelled +  distances(i,j) * influx(i,j);
        end
    end

end

totalCost = transportationCost * totalDistanceTravelled;

end

