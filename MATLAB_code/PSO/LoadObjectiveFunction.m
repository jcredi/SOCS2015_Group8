function functionHandle = LoadObjectiveFunction(demand, capacity, muPenalty)
% LOADOBJECTIVEFUNCTION
%
% Loads the objective function of the optimizazion problem.

functionHandle = @(volumes) 1/mean(sum(volumes,2)./demand) + muPenalty*(...
    sum((max(sum(volumes)-capacity))).^2 );

end