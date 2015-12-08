function fitness = EvaluateFitnessAgent(trades, nCustomers, demands, distances, alpha)
% EvaluateFitness2
% Different fitness measure: 
%       flow of items - alpha*(transportation costs)
% where alpha is the cost of transporting one item per unit distance, and
% indeed investigating the effect of alpha is one of the goals of the project

% Flow term
flow = sum(sum(trades,1),2); 
% Transportation costs term
transportationCost = 0;
transportationMatrix = trades .* distances;
transportationCost = sum( sum(transportationMatrix,1),2);


fitness = flow - alpha*transportationCost;

end