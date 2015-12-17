function layer = UpdatePrices(layer,parameterSettings)

nbrOfLayers = length(layer);

nbrOfPricesToUpdate = 1;

for iPrice = 1:nbrOfPricesToUpdate
    % Any layer can be chosen now!
%     iLayer = randi(nbrOfLayers - 1) + 1;
    iLayer = randi(nbrOfLayers);
    currentLayer = layer(iLayer);
    
    prices = currentLayer.prices;
    supply = currentLayer.supply;
    demand = currentLayer.demand;
    
    % Choose node to update:
    iNode = randi(length(prices));
    
    nodeSupply = supply(iNode);
    nodeDemand = demand(iNode);
    nodeOldPrice = prices(iNode);
   
    nodeNewPrice = UpdatePrice(nodeOldPrice,nodeSupply,nodeDemand,parameterSettings);
    
    prices(iNode) = nodeNewPrice;
    currentLayer.prices = prices;
    
    layer(iLayer) = currentLayer;
    
end

end

