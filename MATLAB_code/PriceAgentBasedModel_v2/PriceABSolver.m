function returnFitness = PriceABSolver(alpha,nRetailers,nWarehouses,nManufacturers,retailerDemands,...
    manufacturerSupply,positions,nPriceUpdates,nRunsForAverage)
%PRICEABSOLVER Summary of this function goes here
%   Detailed explanation goes here

%% Set variables of the problem

nbrOfRetailers = nRetailers;
nbrOfWarehouses = nWarehouses;
nbrOfManufacturers = nManufacturers;

% assert(mod(nbrOfRetailers,nbrOfManufacturers) == 0);

problemParameters.nbrOfRetailers = nbrOfRetailers;
problemParameters.nbrOfWarehouses = nbrOfWarehouses;
problemParameters.nbrOfManufacturers = nbrOfManufacturers;

% problemParameters.retailerDemand = ones(1,problemParameters.nbrOfRetailers);
% problemParameters.retailerValues = ones(1,problemParameters.nbrOfRetailers);
% problemParameters.manufacturerSupply = ones(1,nbrOfManufacturers)*nbrOfRetailers/nbrOfManufacturers;

problemParameters.retailerDemand = retailerDemands;
problemParameters.retailerValues = ones(1,problemParameters.nbrOfRetailers);
problemParameters.manufacturerSupply = manufacturerSupply;

% problemParameters.retailerLocations = rand(nbrOfRetailers,2);
% problemParameters.warehouseLocations = rand(nbrOfWarehouses,2);
% problemParameters.manufacturerLocations = rand(nbrOfManufacturers,2);

retailerLocations = positions{1};
retailerLocations = retailerLocations';

warehouseLocations = positions{2};
warehouseLocations = warehouseLocations';

manufacturerLocations = positions{3};
manufacturerLocations = manufacturerLocations';

problemParameters.retailerLocations = retailerLocations';
problemParameters.warehouseLocations = warehouseLocations';
problemParameters.manufacturerLocations = manufacturerLocations';


%% Initialize network

fitnessValues = zeros(1,nRunsForAverage);

for iRun = 1:nRunsForAverage
    
    [layer,parameterSettings] = InitializeNetwork(problemParameters);
    parameterSettings.transportationCost = alpha;
    
    
    clc
    
    profile on
    
    parameterSettings.allowedPriceChange = 0.1;
    parameterSettings.k = 0.5;
    parameterSettings.decay = 1;
    
    startAllowedPriceChange = 0.01;
    endAllowedPriceChange = 0.0001;
    
    startK = 0.01;
    endK = 0.0001;
    
    
    nbrOfMeassurements = 1;
    nbrOfIterationsPerMeassurement = nPriceUpdates;
    
    nbrOfIterations = nbrOfMeassurements * nbrOfIterationsPerMeassurement;
    
    i = 1;
    fitness = zeros(1,nbrOfMeassurements);
    
    for iMeassurement = 1:nbrOfMeassurements
        for iIteration = 1:nbrOfIterationsPerMeassurement
            i = i + 1;
            x = i/nbrOfIterations;
            parameterSettings.allowedPriceChange = ...
                sigmoid(x,startAllowedPriceChange,endAllowedPriceChange);
            parameterSettings.k = sigmoid(x,startK,endK);
            
            layer = Trade(layer,parameterSettings);
            layer = UpdatePrices(layer,parameterSettings);
            
        end
        
        layer = MakeShipments(layer,parameterSettings);
        fitness(iMeassurement) = CalculateFitness(layer,parameterSettings.transportationCost);
        %     clf
        %     hold on
        %     figure(1)
        VisualizeNetwork(layer,fitness)
        pause(0.001)
        %     figure(2)
        %     plot(fitness)
        
    end
    
    fitness = fitness(end);
    fitnessValues(iRun) = fitness;
end

returnFitness = mean(fitnessValues);

end

