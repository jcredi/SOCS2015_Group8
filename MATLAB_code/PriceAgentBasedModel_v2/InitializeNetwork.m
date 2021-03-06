function [layer,parameterSettings] = InitializeNetwork(problemParameters)

% If no problem parameters are given as argument to the function, theses
% standard parameters are set.
if (nargin == 0)
    
    nbrOfRetailers = 100;
    nbrOfWarehouses = 20;
    nbrOfManufacturers = 10;
    
    % These three vectors are constant parameters throughout the algorithm.
    retailerDemand = ones(1,nbrOfRetailers);
    retailerValues = ones(nbrOfRetailers,1);
    manufacturerSupply = ones(nbrOfManufacturers,1) * 10;
    
    layer(1).locations = rand(nbrOfRetailers,2);
    layer(2).locations = rand(nbrOfWarehouses,2);
    layer(3).locations = rand(nbrOfManufacturers,2);
    
else
    
    nbrOfRetailers = problemParameters.nbrOfRetailers;
    nbrOfWarehouses = problemParameters.nbrOfWarehouses;
    nbrOfManufacturers = problemParameters.nbrOfManufacturers;
    
    
    % These three vectors are constant parameters throughout the algorithm.
    retailerDemand = problemParameters.retailerDemand;
    retailerValues = problemParameters.retailerValues;
    manufacturerSupply = problemParameters.manufacturerSupply;
    
    layer(1).locations = problemParameters.retailerLocations;
    layer(2).locations = problemParameters.warehouseLocations;
    layer(3).locations = problemParameters.manufacturerLocations;
    
end

layerSizes = [nbrOfRetailers,nbrOfWarehouses,nbrOfManufacturers];

% Initialize layer struct-array
layer(length(layerSizes)).name = '';

% Set parameters (default values)
parameterSettings.k = 0.01;
parameterSettings.allowedRelativePriceChange = 0.05;
parameterSettings.transportationCost = 1;
parameterSettings.greed = 0;

% First Layer;
nbrOfNodes = layerSizes(1);
layer(1).name = 'Customer layer';
layer(1).supply = zeros(1,nbrOfNodes);
layer(1).demand = retailerDemand;
layer(1).prices = retailerValues;

% layer(1).locations = rand(nbrOfRetailers,2);

layer(1).influx = zeros(layerSizes(1),layerSizes(2));

% Middle layers (only one warehouse layer in simple case.)
for i = 2 : length(layerSizes) - 1
    
    nbrOfNodes = layerSizes(i);
    
    layer(i).name = sprintf('Layer nr. %d',i);
    layer(i).supply = zeros(1,nbrOfNodes);
    layer(i).demand = zeros(1,nbrOfNodes);
    
%     % Initialize warehouse prices to 0.5;
%     layer(i).prices = ones(1,nbrOfNodes) * 0.5;
    
    layer(i).prices = zeros(1,nbrOfNodes) * 0.5;
    
%     layer(i).locations = rand(nbrOfNodes,2);
    layer(i).influx = zeros(layerSizes(i),layerSizes(i+1));
end


% End (supplier) layer:
nbrOfNodes = layerSizes(end);
layer(end).name = 'Supplier layer';
layer(end).supply = manufacturerSupply;

layer(end).demand = zeros(1,nbrOfNodes);

% Initialzie the manufacturer prices to 0;
layer(end).prices = zeros(1,nbrOfNodes);

% layer(end).locations = rand(nbrOfNodes,2);

% Distances:

for iLayer = 1:length(layer) -1
    customerLocations = layer(iLayer).locations;
    storeLocations = layer(iLayer + 1).locations;
    size(customerLocations)
    size(storeLocations)
    layer(iLayer).distances = pdist2(customerLocations,storeLocations);
end

end

