%% InvestigateAlpha
% Little scipt to investigate the impact of alpha on the overall customer
% satisfaction

nMaps = 3;
alphaValues = logspace(-3, 1, 11);
nAlpha = numel(alphaValues);

finalFitness = zeros(nMaps, nAlpha);
finalCustSatisfaction = zeros(nMaps, nAlpha);

for iMap = 1:nMaps
    
    % Generate a new map
    [facilitiesPerLayer, positions, distances] = GenerateWorld(...
        worldSize, nRetailers, nWarehouses, nManufacturers);
    fprintf('Evaluating map %i of %i\n',iMap,nMaps);
    
    for iAlpha = 1:nAlpha
        alpha = alphaValues(iAlpha);
        fprintf('    Evaluating alpha value %i of %i\n',iAlpha,nAlpha);
        
        [bestSoFar, bestFitness] = GA3(alpha, worldSize, facilitiesPerLayer, ...
            positions, distances, retailersDemands, manufacturersSupply);
        customerSatisfaction = EvaluateCustomerSatisfaction(bestSoFar);
        
        finalFitness(iMap, iAlpha) = bestFitness;
        finalCustSatisfaction(iMap, iAlpha) = customerSatisfaction;
        
    end
    
    
end