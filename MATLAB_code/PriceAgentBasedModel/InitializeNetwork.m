function [layer,parameterSettings] = InitializeNetwork()
clc
clear

% rng(1000)

nbrOfCustomers = 100;
nbrOfSuppliers = 10;

nbrOfStoredTimesteps = 5;
nbrOfTimesteps = 20;

layerSizes = [nbrOfCustomers,20,nbrOfSuppliers];

% These three vectors are constant parameters throughout the algorithm.
customerDemands = ones(1,nbrOfCustomers);
customerValues = ones(nbrOfCustomers,1)*5;
suppliersSupply = ones(nbrOfSuppliers,1) * 10;

% Initialize layer struct-array
layer(length(layerSizes)).name = '';

% Set parameters:
parameterSettings.k = 0.01;
parameterSettings.allowedRelativePriceChange = 0.05;
parameterSettings.transportationCost = 1.5;


nbrOfNodes = layerSizes(1);
layer(1).name = 'Customer layer';
layer(1).supplyHistory = zeros(nbrOfTimesteps,nbrOfNodes);

layer(1).demandHistory = zeros(nbrOfTimesteps,nbrOfNodes);
layer(1).priceHistory = NaN(nbrOfTimesteps,nbrOfNodes);

for i = 1:nbrOfTimesteps
    layer(1).demandHistory(i,:) = customerDemands;
    layer(1).priceHistory(i,:) = customerValues;
end

layer(1).locations = rand(nbrOfCustomers,2);

layer(1).stock = zeros(nbrOfNodes,1);
layer(1).backOrders = customerDemands;

layer(1).influx = zeros(layerSizes(1),layerSizes(2));

for i = 2 : length(layerSizes) - 1
    
    nbrOfNodes = layerSizes(i);
    
    layer(i).name = sprintf('Layer nr. %d',i);
    layer(i).supplyHistory = zeros(nbrOfTimesteps,nbrOfNodes);
    layer(i).demandHistory = zeros(nbrOfTimesteps,nbrOfNodes);
    layer(i).priceHistory = ones(nbrOfTimesteps,nbrOfNodes) * 1;
    
    layer(i).stock = zeros(nbrOfNodes,1);
    layer(i).backOrders = zeros(nbrOfNodes,1);
    
    layer(i).locations = rand(nbrOfNodes,2);
    layer(i).influx = zeros(layerSizes(i),layerSizes(i+1));
end


nbrOfNodes = layerSizes(end);
layer(end).name = 'Supplier layer';
layer(end).supplyHistory = zeros(nbrOfTimesteps,nbrOfNodes);

for i = 1:size(layer(end).supplyHistory,1)
    layer(end).supplyHistory(i,:) = suppliersSupply;
end

layer(end).demandHistory = zeros(nbrOfTimesteps,nbrOfNodes);
layer(end).priceHistory = ones(nbrOfTimesteps,nbrOfNodes);

layer(end).stock = suppliersSupply;
layer(end).backOrders = zeros(nbrOfNodes,1);

layer(end).locations = rand(nbrOfNodes,2);

end

