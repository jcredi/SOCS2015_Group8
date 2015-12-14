function shippedItems = ShipItems_withFidelity(ordersArray, supply, distances, alpha, fidelity)
%% ShipItems_withFidelity
% In case of SHORTAGE, preferably ship to trusted and nearest customers

shippedItems = zeros(1,size(ordersArray,2));

% transform supply into a column vector, if necessary
if size(supply,2) < size(supply,1)
	supply = supply';
end

for iSupplier=1:length(supply)
    
    inStock = supply(iSupplier);
    customersIndices = find(ordersArray(iSupplier,:)); % find indices of customers of current supplier
    
    if ~isempty(customersIndices) % if this store received orders

        customersDistances = distances(iSupplier,customersIndices); % find distances
        customersVisibility = 1./customersDistances;
        customersFidelity = fidelity(iSupplier,customersIndices);

        tmpProbabilities = customersFidelity.*customersVisibility;
    
        
        
        while inStock > 0 && ~isempty(tmpProbabilities)
            
            % pick one unserved customer
            tmpProbabilities = tmpProbabilities./sum(tmpProbabilities);
            partialSums = cumsum(tmpProbabilities);
            tempLogical = (rand < partialSums);
            tmpIndex = find(tempLogical~=0, 1, 'first');
            iCustomer = customersIndices(tmpIndex);
            
            order = ordersArray(iSupplier, iCustomer);
            profit = order - alpha*order*distances(iSupplier, iCustomer); % compute profit for shipping to him
            if profit < 0 % if this customer is unprofitable
                customersIndices(tmpIndex) = []; % don't ship to him and remove him from the list
                tmpProbabilities(tmpIndex) = [];
            elseif order < inStock % if there is enough in stock
                shippedItems(iCustomer) = order; % give him what he ordered
                inStock = inStock - order; % decrease the stock
                customersIndices(tmpIndex) = []; % and remove him from the list
                tmpProbabilities(tmpIndex) = [];
            else % there are fewer items in stock than ordered by this customer
                shippedItems(iCustomer) = inStock; % give hime all that is left in stock
                inStock = 0; % set stock as depleted
            end
            
        end
        

    end
    
end

end
