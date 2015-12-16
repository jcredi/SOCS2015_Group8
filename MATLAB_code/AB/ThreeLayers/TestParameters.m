% TestParameters 

betaValues = 0:0.2:2;
alpha = 0.3;
nRuns = 20000;
nRunsForAverage = 500;
fidelityReinforcement = 0.01;%logspace(-3,-1,7);
fidelityDecayRate = 0.01;%logspace(-3,-1,7);

% fitnessMean = zeros(numel(fidelityReinforcement), numel(fidelityDecayRate));
% fitnessStd = zeros(numel(fidelityReinforcement), numel(fidelityDecayRate));

% for iReinf = 1:numel(fidelityReinforcement)
%     
%     fprintf('i = %i\n', iReinf);    tic
%     for iDecay = 1:numel(fidelityDecayRate)
%         
%         fprintf('  j = %i\n', iDecay); tic

for iBeta = 1:numel(betaValues)
    beta = betaValues(iBeta);
        [fitnessMean(iBeta), fitnessStd(iBeta)] = ...
            AgentBasedSolver(fidelityReinforcement, fidelityDecayRate, ...
            beta, alpha, nRuns, nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
            manufacturersSupply, distances, visibility, nRunsForAverage, worldSize, positions);
    
end