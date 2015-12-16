% TestParameters 

beta = 1;
alpha = 0.3;
nRuns = 10000;
nRunsForAverage = 500;
fidelityReinforcement = logspace(-3,-1,10);
fidelityDecayRate = logspace(-3,-1,10);

fitnessMean = zeros(numel(fidelityReinforcement), numel(fidelityDecayRate));
fitnessStd = zeros(numel(fidelityReinforcement), numel(fidelityDecayRate));

for iReinf = 1:numel(fidelityReinforcement)
    
    fprintf('i = %i', iReinf);
    for iDecay = 1:numel(fidelityDecayRate)
        
        fprintf('j = %i', iDecay);
        [fitnessMean(iReinf,iDecay), fitnessStd(iReinf,iDecay)] = ...
            AgentBasedSolver(fidelityReinforcement(iReinf), fidelityDecayRate(iDecay), ...
            beta, alpha, nRuns, nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
            manufacturersSupply, distances, visibility, nRunsForAverage);
    
    end
    
end