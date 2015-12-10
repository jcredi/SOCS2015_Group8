

clc
clf
clear

[layer,parameterSettings] = InitializeNetwork();

parameterSettings.k = 0.01;
parameterSettings.allowedRelativePriceChange = 0.05;
parameterSettings.transportationCost = 0.4;

startGreed = 0;
endGreed = 0.5;


nbrOfTimesteps = 20000;

influx = zeros(1,nbrOfTimesteps);
prices = zeros(nbrOfTimesteps,3);
cost = zeros(1,nbrOfTimesteps);

supply = zeros(nbrOfTimesteps,3);
demand = zeros(nbrOfTimesteps,3);

totalVolume = zeros(1,nbrOfTimesteps);

% Study single node:
nodePrice = zeros(1,nbrOfTimesteps);
nodeSupply = zeros(1,nbrOfTimesteps);
nodeDemand = zeros(1,nbrOfTimesteps);

nodeLayer = 2;
nodeIndex = 2;


% startK = 0.5;
% endK = 0.01;

timeResolution = 20;

for i = 1:nbrOfTimesteps
    
    x = (i/nbrOfTimesteps);
    
    
    parameterSettings.greed = x*endGreed + (1-x)*startGreed;
    
    
    
%     parameterSettings.k = (1-x)*startK + x*endK;
    
%     parameterSettings.k = 0.0000001 + 0.5/(0.5*i);
    
    
    layer = Trade(layer,parameterSettings);
    layer = UpdatePrices(layer,parameterSettings);
    
    
    influx(i) = sum(sum(layer(1).influx));
    
    prices(i,1) = sum(sum(layer(1).priceHistory(end,:)));
    prices(i,2) = sum(sum(layer(2).priceHistory(end,:)));
    prices(i,3) = sum(sum(layer(3).priceHistory(end,:)));
    
    demand(i,1) = sum(sum(layer(1).demandHistory(end,:)));
    demand(i,2) = sum(sum(layer(2).demandHistory(end,:)));
    demand(i,3) = sum(sum(layer(3).demandHistory(end,:)));
    
    supply(i,1) = sum(sum(layer(1).supplyHistory(end,:)));
    supply(i,2) = sum(sum(layer(2).supplyHistory(end,:)));
    supply(i,3) = sum(sum(layer(3).supplyHistory(end,:)));
    
    
    nodePrice(i) = layer(nodeLayer).priceHistory(end,nodeIndex);
    nodeSupply(i) = layer(nodeLayer).supplyHistory(end,nodeIndex);
    nodeDemand(i) = layer(nodeLayer).demandHistory(end,nodeIndex);
    
    
    
    
%     supply
    
    cost(i) = CalculateTransportationCosts(layer,parameterSettings);
    
    
%     if (mod(i,timeResolution) == 0)
%         parameterSettings.k
%         i
%         VisualizeNetwork(layer)
%         input('')
%     end
    
if mod(i,20) == 0
    disp(sprintf('Curent iteration: %d', i))
    VisualizeNetwork(layer)
    pause(0.001)
end
    
    

end

'FINISHED'

%%

clf
hold on

plot(nodePrice*10,'.-')
plot(nodeSupply,'.-')
plot(nodeDemand,'.-')

%%
clf

hold on
% plot(prices(:,1))
plot(prices(:,2))
plot(prices(:,3))



%%
clf
size(demand)

subplot(3,1,1)
hold on
plot(supply(:,1))
plot(supply(:,2))
plot(supply(:,3))

subplot(3,1,2)
hold on
plot(demand(:,1))
plot(demand(:,2))
plot(demand(:,3))

fitness = influx - cost;

subplot(3,1,3)
plot(fitness)
ylim([-10,100])


%%
subplot(1,1,1)
plot(fitness)


%%


VisualizeNetwork(layer)


%% Plot flux:

layer.influx

% Plot locations
layer(1).locations

clf
hold on

markers = {'b.','r.','g.'};
lines = {'b','r'};

for iLayer = 1:3
    X = layer(iLayer).locations(:,1);
    Y = layer(iLayer).locations(:,2);
    
    plot(X,Y,markers{iLayer},'MarkerSize',15)
    xlabel('x coordinate')
    ylabel('y coordinate')
end

for iLayer = 1:length(layer) - 1
    customerLocations = layer(iLayer).locations;
    storeLocations = layer(iLayer + 1).locations;
    
    influx = layer(iLayer).influx;
    
    lines = size(influx);
    lines = influx * (1/(sum(sum(influx))))* 30;
    lineColors = {'b','r'}
    
    [nbrOfCustomers,nbrOfStores] = size(influx);
    
    for i = 1:nbrOfCustomers
        for j = 1:nbrOfStores
            if influx(i,j) > 0
            plot([customerLocations(i,1),storeLocations(j,1)],...
                [customerLocations(i,2),storeLocations(j,2)],lineColors{iLayer})
            end
%             plot([customerLocations(i,1),storeLocations(j,1)],...
%                 [customerLocations(i,2),storeLocations(j,2)],lineColors{iLayer},...
%             'LineWidth',lines(i,j) + 0.01)
        end
    end
    
end


%%

clc
clear

% rng(1000)

nbrOfCustomers = 2;
nbrOfSuppliers = 2;

nbrOfStoredTimesteps = 5;
nbrOfTimesteps = 20;

layerSizes = [nbrOfCustomers,2,nbrOfSuppliers];

% These three vectors are constant parameters throughout the algorithm.
% customerDemands = randi(100,nbrOfCustomers,1);
customerDemands = ones(1,nbrOfCustomers)*100;
% customerDemands = [2,3];


customerValues = ones(nbrOfCustomers,1)*20;
suppliersSupply = ones(nbrOfSuppliers,1)*100;
% suppliersSupply = [5,1];


% Initialize layer struct-array
layer(length(layerSizes)).name = '';

% Set parameters:
parameterSettings.k = 0.5;
parameterSettings.allowedRelativePriceChange = 0.1;
parameterSettings.transportationCost = 0.9;


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
    layer(i).priceHistory = ones(nbrOfTimesteps,nbrOfNodes) * 0.5;
    
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




%%

nbrOfIterations = 1000;

totalVolume = zeros(nbrOfIterations,length(layer));
totalPrice = zeros(nbrOfIterations,length(layer));
totalDemand = zeros(nbrOfIterations,length(layer));
totalSupply = zeros(nbrOfIterations,length(layer));
fitnessValues = zeros(nbrOfIterations,1);

% Main algorithm
for iteration = 1:nbrOfIterations
%     disp(sprintf('Current iteration: %d',iteration))
    if (mod(iteration,100) == 0)
        iteration
    end
    
    layer = Trade(layer)
    
    
%     for i = 1:length(layer)-1
%         [layer(i),layer(i+1)] = Trade(layer(i),layer(i+1),parameterSettings);
%         layer(i+1) = UpdatePrices(layer(i+1),parameterSettings);
%         
%     end
    
    for iLayer = 1:length(layer)
        totalVolume(iteration,iLayer) = sum(sum(layer(iLayer).influx));
        totalPrice(iteration,iLayer) = sum(layer(iLayer).priceHistory(end,:));
        totalDemand(iteration,iLayer) = sum(layer(iLayer).demandHistory(end,:));
        totalSupply(iteration,iLayer) = sum(layer(iLayer).supplyHistory(end,:));
    end
    fitnessValues(iteration) = CalculateFitness(layer);
end

%%
clf
plot(fitnessValues)
xlabel('time')
ylabel('fitness')

%%

subplot(1,2,1)
plot(totalVolume(:,1))

subplot(1,2,2)
plot(totalVolume(:,2))

%%

A = totalPrice
% A = totalDemand
% A = totalSupply


subplot(1,3,1)
plot(A(:,1))

subplot(1,3,2)
plot(A(:,2))


subplot(1,3,3)
plot(A(:,3))



%%



A = 4;



if A > 0
    while A > 0
        A = A - 1
    end
else
    'a'
end


%%




A = [1,2;3,4];

[maxA,ind] = max(A(:));
[m,n] = ind2sub(size(A),ind)






