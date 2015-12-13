function [layer,parameterSettings] = InitializeNetwork(problemParameters)


% If no problem parameters are given as argument to the function, theses
% standard parameters are set.
if (nargin == 0)
    
    nbrOfCustomers = 100;
    nbrOfWarehouses = 20;
    nbrOfSuppliers = 10;
    
    % These three vectors are constant parameters throughout the algorithm.
    customerDemands = ones(1,nbrOfCustomers);
    customerValues = ones(nbrOfCustomers,1);
    suppliersSupply = ones(nbrOfSuppliers,1) * 10;

else
    
    nbrOfCustomers = problemParameters.nbrOfCustomers;
    nbrOfWarehouses = problemParameters.nbrOfWarehouses;
    nbrOfSuppliers = problemParameters.nbrOfSuppliers;
    
    
    % These three vectors are constant parameters throughout the algorithm.
    customerDemands = problemParameters.customerDemands;
    customerValues = problemParameters.customerValues;
    suppliersSupply = problemParameters.suppliersSupply;
    
end

layerSizes = [nbrOfCustomers,nbrOfWarehouses,nbrOfSuppliers];

% The number of stored values of prices, supply and demand. To use in for
% example PID-control.
nbrOfStoredTimesteps = 20;

% Initialize layer struct-array
layer(length(layerSizes)).name = '';

% Set parameters (default values)
parameterSettings.k = 0.01;
parameterSettings.allowedRelativePriceChange = 0.05;
parameterSettings.transportationCost = 1.5;
parameterSettings.greed = 0;

% First Layer;
nbrOfNodes = layerSizes(1);
layer(1).name = 'Customer layer';
layer(1).supplyHistory = zeros(nbrOfStoredTimesteps,nbrOfNodes);

layer(1).demandHistory = zeros(nbrOfStoredTimesteps,nbrOfNodes);
layer(1).priceHistory = NaN(nbrOfStoredTimesteps,nbrOfNodes);

for i = 1:nbrOfStoredTimesteps
    layer(1).demandHistory(i,:) = customerDemands;
    layer(1).priceHistory(i,:) = customerValues;
end

layer(1).locations = rand(nbrOfCustomers,2);

layer(1).stock = zeros(nbrOfNodes,1);
layer(1).backOrders = customerDemands;

layer(1).influx = zeros(layerSizes(1),layerSizes(2));

% Middle layers (only one warehouse layer in simple case.)
for i = 2 : length(layerSizes) - 1
    
    nbrOfNodes = layerSizes(i);
    
    layer(i).name = sprintf('Layer nr. %d',i);
    layer(i).supplyHistory = zeros(nbrOfStoredTimesteps,nbrOfNodes);
    layer(i).demandHistory = zeros(nbrOfStoredTimesteps,nbrOfNodes);
    layer(i).priceHistory = ones(nbrOfStoredTimesteps,nbrOfNodes) * 1;
    
    layer(i).stock = zeros(nbrOfNodes,1);
    layer(i).backOrders = zeros(nbrOfNodes,1);
    
    layer(i).locations = rand(nbrOfNodes,2);
    layer(i).influx = zeros(layerSizes(i),layerSizes(i+1));
end


% End (supplier) layer:
nbrOfNodes = layerSizes(end);
layer(end).name = 'Supplier layer';
layer(end).supplyHistory = zeros(nbrOfStoredTimesteps,nbrOfNodes);

for i = 1:size(layer(end).supplyHistory,1)
    layer(end).supplyHistory(i,:) = suppliersSupply;
end

layer(end).demandHistory = zeros(nbrOfStoredTimesteps,nbrOfNodes);
layer(end).priceHistory = ones(nbrOfStoredTimesteps,nbrOfNodes);

layer(end).stock = suppliersSupply;
layer(end).backOrders = zeros(nbrOfNodes,1);

layer(end).locations = rand(nbrOfNodes,2);

end

