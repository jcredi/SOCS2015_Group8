function updatedProbabilities = UpdateProbabilities_proportional(probabilities, shipments, ...
    requestsMatrix, distances, alpha, scalingFactor)

nCustomers = size(probabilities,2);
updatedProbabilities = probabilities;


for iCustomer = 1:nCustomers
    selectedSupplier = find(requestsMatrix(:,iCustomer));
    if shipments(iCustomer) ~= 0 % if this customer got some items
        shipmentDistance = distances(selectedSupplier, iCustomer);
        profit = shipments(iCustomer) - alpha*shipmentDistance;
        
        updatedProbabilities(selectedSupplier, iCustomer) = ...
                updatedProbabilities(selectedSupplier, iCustomer)+scalingFactor*profit;
    end
end

end