function layer = UpdatePrices(layer,parameterSettings)

nbrOfLayers = length(layer);

nbrOfPricesToUpdate = 10;

for iPrice = 1:nbrOfPricesToUpdate

iLayer = randi(nbrOfLayers - 1) + 1;

% for iLayer = 2:nbrOfLayers
    
    currentLayer = layer(iLayer);
    
    price = currentLayer.priceHistory(end,:);
    
    supplyHistory = currentLayer.supplyHistory;
    demandHistory = currentLayer.demandHistory;
    
    % Choose node to update:
    i = randi(length(price));
    
    nodeSupplyHistory = supplyHistory(:,i);
    nodeDemandHistory = demandHistory(:,i);
    nodePriceHistory = currentLayer.priceHistory(:,i);
    
    nodeNewPrice = UpdatePrice(nodePriceHistory,nodeSupplyHistory,nodeDemandHistory,parameterSettings);
    
    currentPrices = currentLayer.priceHistory(end,:);
    currentPrices(i) = nodeNewPrice;
    
    currentLayer.priceHistory = [currentLayer.priceHistory(2:end,:); currentPrices];
    
    layer(iLayer) = currentLayer;
    
% end
end

end

