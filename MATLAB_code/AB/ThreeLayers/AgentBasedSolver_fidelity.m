function [fitnessMean, fitnessStd] = AgentBasedSolver_fidelity(fidelityReinforcement, fidelityDecayRate, ...
    beta, alpha, runs, nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
    manufacturersSupply, distances, visibility, nRunsForAverage)
% AgentBasedSolver_fidelity
close all

% ====================================== %
% Initializations
fidelityRW = ones(size(distances{1}));
fidelityWM = ones(size(distances{2}));

% ====================================== %
% Main loop
for k = 0:runs
    
    % Orders phase (customers to suppliers)
    ordersRW = PlaceOrders(retailersDemands,fidelityRW, visibility{1}, beta);
    demandsWM = sum(ordersRW,2) ;
    ordersWM = PlaceOrders(demandsWM,fidelityWM, visibility{2}, beta);
    
    % Shipments phase (suppliers to customers)
    distanceOffsetInput = zeros(nManufacturers);
    [shipmentsMW, distanceOffsetMW] = ShipItems_withFidelity(ordersWM, manufacturersSupply, distances{2}, alpha, fidelityWM, beta, distanceOffsetInput);
    [shipmentsWR, ~] = ShipItems_withFidelity(ordersRW, shipmentsMW, distances{1}, alpha, fidelityRW, beta, distanceOffsetMW);
    
    % Fidelity update
    fidelityWM = UpdateFidelity(fidelityWM, shipmentsMW, ordersWM, fidelityReinforcement, fidelityDecayRate);
    fidelityRW = UpdateFidelity(fidelityRW, shipmentsWR, ordersRW, fidelityReinforcement, fidelityDecayRate);

end

% Then compute fitness of the model at steady-state
[fitnessMean, fitnessStd] = ComputeABFitness_fidelity(nRunsForAverage, beta, alpha, ...
    nRetailers, nWarehouses, nManufacturers, retailersDemands, ...
    manufacturersSupply, distances, visibility, fidelityRW, fidelityWM);


end