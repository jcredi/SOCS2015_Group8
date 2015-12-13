function newPrice = UpdatePrice(priceHistory,supplyHistory,demandHistory,parameterSettings)

% if (nargin == 3)
%     k = 0.1;
%     allowedRelativePriceChange = 0.3;
% else
    k = parameterSettings.k;
    allowedRelativePriceChange = parameterSettings.allowedRelativePriceChange;
% end

oldPrice = priceHistory(end);
oldDemand = demandHistory(end);
oldSupply = supplyHistory(end);

newPrice = max(0, oldPrice + k * (oldDemand - oldSupply));

newPrice = LimitChange(newPrice,oldPrice,allowedRelativePriceChange);

assert(~isnan(newPrice))

end


