function layer = Trade(layer, parameterSettings)

nbrOfLayers = length(layer);

% Calculate supply throughout network:
for i = 1:nbrOfLayers - 1;
    iLayer = nbrOfLayers - i;
    [layer(iLayer),layer(iLayer + 1)] = ...
        Restock(layer(iLayer),layer(iLayer + 1), parameterSettings);
end



% Calculate demand throughout network:
for iLayer = 1:nbrOfLayers - 1
    [layer(iLayer),layer(iLayer + 1)] = ...
        MakeOrders(layer(iLayer),layer(iLayer + 1),parameterSettings);
end




end

