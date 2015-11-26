%PSO
clear; close all; clc

nCustomers = 100;
nStores = 10;
volumes = rand(nCustomers,nStores);
demand = ones(nCustomers,1);
capacity = 10*ones(1, nStores);
muValues = [1, 10, 100, 1000];
muPenalty = 1000;

%====================================%
% Parameters
%====================================%
swarmSize = 50;
spaceDimension = numel(volumes);
inertiaWeight = 1.4; % starting value
inertiaWeightDecreaseRate = 0.99;
minInertiaWeight = 0.3;
c1 = 2;
c2 = 2;
xMin = 0;
xMax = max(demand);
alpha = 1;
deltaT = 1;
maximumVelocity = alpha/deltaT*(xMax-xMin);
maxIterations = 10000;


%====================================%
% Initialisations
%====================================%
[positions, velocities] = InitialisePositionsVelocities(swarmSize,...
  nCustomers, nStores, xMin, xMax, alpha, deltaT);
particleBest = positions;
particleBestEval = Inf(swarmSize,1);
swarmBest = nan(nCustomers,nStores);
swarmBestEval = Inf;

%====================================%
% PSO loop
%====================================%
fprintf('Running Particle Swarm Optimizer with %i particles...',swarmSize);
tic
h = waitbar(0, 'Running PSO - Please wait...');
for muPenalty = muValues
    
    inertiaWeight = 1.4;
    
for iIteration = 1:maxIterations
  
    integerPositions = round(positions);
    functionValues = EvaluateParticles(integerPositions, demand, capacity, muPenalty);

    [particleBest,particleBestEval,swarmBest,swarmBestEval] = UpdateBestPositions(...
      particleBest,particleBestEval,swarmBest,swarmBestEval,positions,functionValues);

    velocities = UpdateVelocities(velocities,positions,inertiaWeight,c1,c2,...
        particleBest,swarmBest,deltaT,maximumVelocity);
    positions = positions + velocities*deltaT;
    positions(positions<0) = 0; 
    
    inertiaWeight = UpdateInertiaWeight(inertiaWeight,...
    inertiaWeightDecreaseRate,minInertiaWeight);

    waitbar(iIteration/maxIterations, h);
end
end
close(h);

finalVolumes = round(swarmBest);
fprintf('\n  %i iterations completed in %4.3f seconds.',iIteration,toc);
fprintf('\n\nObjective function minimum: %f\n',swarmBestEval);
fprintf('Customer satisfaction: %f\n', mean(sum(finalVolumes,2)./demand));

