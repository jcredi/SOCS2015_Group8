%% InvestigateAlpha
% Little scipt to investigate the impact of alpha on the overall customer
% satisfaction

nMaps = 5;
alphaValues = logspace(-0.6, 1.5, 10);
nAlpha = numel(alphaValues);

nRetailers = 45; %number of customers
nWarehouses = 5; % number of stores
nManufacturers = 3;
worldSize = 1; %size of the world
retailersDemands = ones(1,nRetailers);
warehousesMaxCapacity = Inf;%(nRetailers/nWarehouses)*ones(nWarehouses,1);
manufacturersSupply = ceil(nRetailers/nManufacturers)*ones(nManufacturers,1);

finalFitness = zeros(nMaps, nAlpha);
finalCustSatisfaction = zeros(nMaps, nAlpha);

h = waitbar(0, 'Please wait...');
for iMap = 1:nMaps
    
    % Generate a new map
    [facilitiesPerLayer, positions, distances] = GenerateWorld(...
        worldSize, nRetailers, nWarehouses, nManufacturers);
    fprintf('Evaluating map %i of %i\n',iMap,nMaps);
    
    for iAlpha = 1:nAlpha
        alpha = alphaValues(iAlpha);
        fprintf('    Evaluating alpha value %i of %i\n',iAlpha,nAlpha);
        
        [bestSoFar, bestFitness] = GA3_solver(alpha, facilitiesPerLayer, ...
            distances, retailersDemands, manufacturersSupply );
        customerSatisfaction = EvaluateCustomerSatisfaction(bestSoFar);
        
        finalFitness(iMap, iAlpha) = bestFitness;
        finalCustSatisfaction(iMap, iAlpha) = customerSatisfaction;
        
    end
    
    waitbar(iMap/nMaps, h);
end
close(h);