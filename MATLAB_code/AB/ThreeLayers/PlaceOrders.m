function ordersArray = PlaceOrders(customersDemand, pheromone, visibility)
% PlaceOrders

ordersArray = zeros(size(pheromone));
nCustomers = length(customersDemand);
probabilities = pheromone.*visibility;

for iCustomer = 1:nCustomers
    tmpProbabilities = probabilities(:,iCustomer);
    
    if ~all(tmpProbabilities) == 0 % otherwise customer is an outcast and doesn't order
        tmpProbabilities = tmpProbabilities./sum(tmpProbabilities);
        partialSums = cumsum(tmpProbabilities);
        tempLogical = (rand < partialSums);
        iSupplier = find(tempLogical~=0, 1, 'first');
        ordersArray(iSupplier, iCustomer) = customersDemand(iCustomer);
    end
end


end