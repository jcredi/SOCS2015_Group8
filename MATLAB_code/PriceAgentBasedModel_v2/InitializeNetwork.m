function [layer,parameterSettings] = InitializeNetwork(problemParameters)

% If no problem parameters are given as argument to the function, theses
% standard parameters are set.
if (nargin == 0)
    
    nbrOfCustomers = 100;
    nbrOfWarehouses = 20;
    nbrOfSuppliers = 10;
    
    % These three vectors are constant parameters throughout the algorithm.
    customerDemand = ones(1,nbrOfCustomers);
    customerValues = ones(nbrOfCustomers,1);
    suppliersSupply = ones(nbrOfSuppliers,1) * 10;

else
    
    nbrOfCustomers = problemParameters.nbrOfCustomers;
    nbrOfWarehouses = problemParameters.nbrOfWarehouses;
    nbrOfSuppliers = problemParameters.nbrOfSuppliers;
    
    
    % These three vectors are constant parameters throughout the algorithm.
    customerDemand = problemParameters.customerDemands;
    customerValues = problemParameters.customerValues;
    suppliersSupply = problemParameters.suppliersSupply;
    
end

layerSizes = [nbrOfCustomers,nbrOfWarehouses,nbrOfSuppliers];

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
layer(1).demand = customerDemand;
layer(1).prices = customerValues;

layer(1).locations = rand(nbrOfCustomers,2);

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
    
    layer(i).locations = rand(nbrOfNodes,2);
    layer(i).influx = zeros(layerSizes(i),layerSizes(i+1));
end


% End (supplier) layer:
nbrOfNodes = layerSizes(end);
layer(end).name = 'Supplier layer';
layer(end).supply = suppliersSupply;

layer(end).demand = zeros(1,nbrOfNodes);

% Initialzie the manufacturer prices to 0;
layer(end).prices = zeros(1,nbrOfNodes);

layer(end).locations = rand(nbrOfNodes,2);

% Distances:

for iLayer = 1:length(layer) -1
    customerLocations = layer(iLayer).locations;
    storeLocations = layer(iLayer + 1).locations;
    layer(iLayer).distances = pdist2(customerLocations,storeLocations);
end

end

