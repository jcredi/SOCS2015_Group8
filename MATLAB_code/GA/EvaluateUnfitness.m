function unfitness = EvaluateUnfitness(chromosome, nCustomers, capacities, demands)

itemsBought = zeros(size(capacities)); % items bought in each store

for iCustomer = 1:nCustomers
    storeVisited = chromosome(iCustomer); % store visited by current customer
    if ~isnan(storeVisited)
        itemsBought(storeVisited) = itemsBought(storeVisited) + demands(iCustomer);
    end
end

constraints = max(0, itemsBought - capacities);
unfitness = sum(constraints);

end