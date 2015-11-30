function fitness = EvaluateFitness2(chromosome, nCustomers, demands, distances, alpha)
% EvaluateFitness2
% Different fitness measure: 
%       flow of items - alpha*(transportation costs)
% where alpha is the cost of transporting one item per unit distance, and
% indeed investigating the effect of alpha is one of the goals of the project

% Flow term
isCustomerSatisfied = ~isnan(chromosome);
flow = sum(demands(isCustomerSatisfied)); 

% Transportation costs term
transportationCost = 0;
for iCustomer = 1:nCustomers
    if isCustomerSatisfied(iCustomer)
        costForThisCustomer = demands(iCustomer).*distances(chromosome(iCustomer), iCustomer);
        transportationCost = transportationCost + costForThisCustomer;
    end
end

fitness = flow - alpha*transportationCost;

end