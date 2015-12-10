function updatedProbabilities = UpdateProbabilities(probabilities, shipments, ...
    requestsMatrix, distances, alpha, probabilityGain)

nCustomers = size(probabilities,2);
updatedProbabilities = probabiities;


for iCustomer = 1:nCustomers
    selectedSupplier = find(requestsMatrix(:,iCustomer));
    if shipments(iCustomer) ~= 0 % if this customer got some items
        shipmentDistance = distances(selectedSupplier, iCustomer);
        profit = shipments(iCustomer) - alpha*shipmentDistance;
        
        if profit > 0
            updatedProbabilities(selectedSupplier, iCustomer) = ...
                updatedProbabilities(selectedSupplier, iCustomer)+probabilityGain;
        else
            updatedProbabilities(selectedSupplier, iCustomer) = ...
                updatedProbabilities(selectedSupplier, iCustomer)-probabilityGain;
        end
    else % this customer got nothing
        updatedProbabilities(selectedSupplier, iCustomer) = ...
                updatedProbabilities(selectedSupplier, iCustomer)-probabilityGain;
    end
    
end

end