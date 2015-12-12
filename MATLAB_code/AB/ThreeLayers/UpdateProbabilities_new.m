function updatedProbabilities = UpdateProbabilities_new(probabilities, shipments, ...
    requestsMatrix, probabilityReinforcement, probabilityDecay)
% UpdateProbabilities_new 
% Easier update:
% - no items delivered -> do nothing (allow exploration)
% - items delivered with negative profit -> set probability to zero
% - items delivered with positive profit -> increase by pGain
% Decrease all probability by pDecay

nCustomers = size(probabilities,2);
updatedProbabilities = (1-probabilityDecay).*probabilities;

for iCustomer = 1:nCustomers
    
    if shipments(iCustomer) ~= 0 % if this customer got some items, reinforce probability
        selectedSupplier = find(requestsMatrix(:,iCustomer));
        updatedProbabilities(selectedSupplier, iCustomer) = ...
                min(1, updatedProbabilities(selectedSupplier, iCustomer) + probabilityReinforcement);
    end
end

end