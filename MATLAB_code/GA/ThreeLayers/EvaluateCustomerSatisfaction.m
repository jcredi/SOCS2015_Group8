function customerSatisfaction = EvaluateCustomerSatisfaction(solution)
%% EvaluateCustomerSatisfaction

customers = solution{1};
isCustomerSatisfied = ~isnan(customers);

customerSatisfaction = sum(isCustomerSatisfied)/numel(isCustomerSatisfied);

end