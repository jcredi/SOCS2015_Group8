function layer = UpdatePrices(layer,parameterSettings)

nbrOfLayers = length(layer);

nbrOfPricesToUpdate = 1;

for iPrice = 1:nbrOfPricesToUpdate

iLayer = randi(nbrOfLayers - 1) + 1;

% for iLayer = 2:nbrOfLayers
    
    currentLayer = layer(iLayer);
    
    price = currentLayer.priceHistory(end,:);
    
    supplyHistory = currentLayer.supplyHistory;
    demandHistory = currentLayer.demandHistory;
    
    % Choose node to update:
    iNode = randi(length(price));
    
    nodeSupplyHistory = supplyHistory(:,iNode);
    nodeDemandHistory = demandHistory(:,iNode);
    nodePriceHistory = currentLayer.priceHistory(:,iNode);
    
    nodeNewPrice = UpdatePrice(nodePriceHistory,nodeSupplyHistory,nodeDemandHistory,parameterSettings);
    
    currentPrices = currentLayer.priceHistory(end,:);
    currentPrices(iNode) = nodeNewPrice;
    
    currentLayer.priceHistory = [currentLayer.priceHistory(2:end,:); currentPrices];
    
    layer(iLayer) = currentLayer;
    
% end
end

end

