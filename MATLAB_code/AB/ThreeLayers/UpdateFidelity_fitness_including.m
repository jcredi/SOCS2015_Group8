function updatedFidelity = UpdateFidelity_fitness_including(fidelity, shipments, ...
    ordersMatrix, fidelityReinforcement, fidelityDecay)
% UpdateFidelity
% - decrease all fidelity values by a constant factor (1-fidelityDecay)
% - increase fidelity to supplier when orders are satisfied

nCustomers = size(fidelity,2);
updatedFidelity = max(1e-32,(1-fidelityDecay).*fidelity); % decay
%updatedFidelity = fidelity-fidelityDecay; % decay

for iCustomer = 1:nCustomers
    
    if shipments(iCustomer) ~= 0 % if this customer got some items, reinforce probability
        selectedSupplier = find(ordersMatrix(:,iCustomer));
        updatedFidelity(selectedSupplier, iCustomer) = ...
                min(1, updatedFidelity(selectedSupplier, iCustomer)+fidelityReinforcement);
    end
end

end