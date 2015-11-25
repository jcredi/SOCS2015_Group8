function goodness = ObjectiveFunction(volumes, demand, capacity, muPenalty)
% OBJECTIVEFUNCTION
%
% Call this function to evaluate a solution. Lower is better.

customerSatisfaction = 1/mean(sum(volumes,2)./demand);

capacityConstraints = sum(volumes)- capacity;
capacityConstraints(capacityConstraints < 0) = 0;
capacityConstraints = capacityConstraints.^2;

demandConstraints = sum(volumes,2)- demand;
demandConstraints(demandConstraints < 0) = 0;
demandConstraints = demandConstraints.^2;

goodness = customerSatisfaction + muPenalty*(sum(capacityConstraints) + ...
    sum(demandConstraints));

end