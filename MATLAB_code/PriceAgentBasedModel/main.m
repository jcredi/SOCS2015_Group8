

%% Set variables of the problem

clear
clc

nbrOfCustomers = 100;
nbrOfWarehouses = 10;
nbrOfSuppliers = 2;

assert(mod(nbrOfCustomers,nbrOfSuppliers) == 0);

problemParameters.nbrOfCustomers = nbrOfCustomers;
problemParameters.nbrOfWarehouses = nbrOfWarehouses;
problemParameters.nbrOfSuppliers = nbrOfSuppliers;

problemParameters.customerDemands = ones(1,problemParameters.nbrOfCustomers);
problemParameters.customerValues = ones(1,problemParameters.nbrOfCustomers);
problemParameters.suppliersSupply = ones(1,nbrOfSuppliers)*nbrOfCustomers/nbrOfSuppliers;


%% Initialize network
[layer,parameterSettings] = InitializeNetwork(problemParameters);

%% Set custom locations if desired...
customRetailerLocations = ginput(problemParameters.nbrOfCustomers);
customWarehouseLocations = ginput(problemParameters.nbrOfWarehouses);
customSupplierLocations = ginput(problemParameters.nbrOfSuppliers);

layer(1).locations = customRetailerLocations;
layer(2).locations = customWarehouseLocations;
layer(3).locations = customSupplierLocations;

%%
VisualizeNetwork(layer)

%% Main algorithm
startGreed = 0.1;
endGreed = 0.1;

parameterSettings.allowedPriceChange = 0.05;
parameterSettings.k = 0.05;

startAllowedPriceChange = 0.5;
endAllowedPriceChange = 0.01;

startK = 1;
endK = 0.01;


nbrOfIterations = 10000;

fitness = zeros(1,nbrOfIterations);

for i = 1:nbrOfIterations
    
    x = i/nbrOfIterations;
    parameterSettings.greed = (1-x)*startGreed + x*endGreed;
    parameterSettings.allowedPriceChange = ...
        (1-x)*startAllowedPriceChange + x*endAllowedPriceChange;
    parameterSettings.k = (1-x)*startK + x*endK;
    
    if (mod(i,100) == 0)
        VisualizeNetwork(layer)
        pause(0.001)
        i
    end
    layer = Trade(layer,parameterSettings);
    layer = UpdatePrices(layer,parameterSettings);
    
    fitness(i) = CalculateFitness(layer,parameterSettings.transportationCost);
    
end
%%
VisualizeNetwork(layer)

%%
clf
plot(fitness)




%%

clc
clf
clear

[layer,parameterSettings] = InitializeNetwork();

parameterSettings.k = 0.01;
parameterSettings.allowedRelativePriceChange = 0.05;
parameterSettings.transportationCost = 0.4;

startGreed = 0;
endGreed = 0;

nbrOfTimesteps = 2000;

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

% 
%  if i == 120
%      input('')
%  end
%  
%  
%  if i == 240
%      input('')
%  end
    
    

end

'FINISHED'

%%
prices = linspace(0,1,50);

parameterSettings.greed = 0.7;

nbrOfPrices = length(prices);
nbrOfTimesteps = 5;

supplyData = zeros(nbrOfTimesteps,nbrOfPrices);
demandData = zeros(nbrOfTimesteps,nbrOfPrices);

iLayer = 2;
iNode = 1;

for iPrice = 1:nbrOfPrices
    for iTime = 1:nbrOfTimesteps
        
        layer(iLayer).priceHistory(end,iNode) = prices(iPrice);
        
        layer = Trade(layer,parameterSettings);
        
        supplyData(iTime,iPrice) = layer(iLayer).supplyHistory(end,iNode);
        demandData(iTime,iPrice) = layer(iLayer).demandHistory(end,iNode);
    end
    iPrice
end

%%
clf

hold on
plotData(prices,supplyData)

plotData(prices,demandData)


% ylim([0,20])


%%

clf
hold on

plot(nodePrice*10,'.-')
plot(nodeSupply,'.-')
plot(nodeDemand,'.-')

%%

nodes(1).demand = 3;
nodes(1).supply = 9;
nodes(1).price = 10;
nodes(1).location = [0.2,1];

nodes(2).demand = 1;
nodes(2).supply = 2;
nodes(2).price = 3.12;
nodes(2).location = [1,1.2];

nodes(3).demand = 8;
nodes(3).supply = 7;
nodes(3).price = 2.1;
nodes(3).location = [2,0.5];

for iNode = 1:length(nodes)
    nodes(iNode).text = sprintf('supply: %d\ndemand: %d\nprice %.f', ...
        nodes(iNode).supply,nodes(iNode).demand,nodes(iNode).price);
end



clf
hold on
for iNode = 1:length(nodes)
    plot(nodes(iNode).location(1),nodes(iNode).location(2),'*')
    text(nodes(iNode).location(1),nodes(iNode).location(2),nodes(iNode).text)
end

xlim([0,3])
ylim([0,2])



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


clf
subplot(1,1,1)
plot(fitness)
xlabel('time')
ylabel('fitness')

%%

















