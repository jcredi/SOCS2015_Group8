function fitness = CalculateFitness(layer,alpha)

if nargin == 1
    % Default value for alpha if none is given as argument
    alpha = 0.5;
end

totalVolume = sum(sum(layer(1).influx));


totalDistanceTravelled = 0;
for iLayer = 1:length(layer) -1
    
    [nbrOfCustomers,nbrOfStores] = size(layer(iLayer).influx);
    
%     distances = zeros(nbrOfCustomers,nbrOfStores);
    
    distances = layer(iLayer).distances;
    influx = layer(iLayer).influx;
    
%     customerLocations = layer(iLayer).locations;
%     storeLocations = layer(iLayer + 1).locations;
%     
    
%     for i = 1:nbrOfCustomers
%         for j = 1:nbrOfStores
%             distances(i,j) = norm(customerLocations(i,:) - storeLocations(j,:));
%         end
%     end
    
    for i = 1:nbrOfCustomers
        for j = 1:nbrOfStores
            totalDistanceTravelled = totalDistanceTravelled + distances(i,j) * influx(i,j);
        end
    end
end


fitness = totalVolume - alpha * totalDistanceTravelled;

end

