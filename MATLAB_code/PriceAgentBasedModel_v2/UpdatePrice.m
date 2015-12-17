function newPrice = UpdatePrice(oldPrice,supply,demand,parameterSettings)

k = parameterSettings.k;
allowedRelativePriceChange = parameterSettings.allowedRelativePriceChange;

% Limit price to minimum 0;
newPrice = max(0, oldPrice + k * (demand - supply));
% Limit price to maximum 1;
newPrice = min(1, newPrice);

newPrice = LimitChange(newPrice,oldPrice,allowedRelativePriceChange);

assert(~isnan(newPrice))

end


