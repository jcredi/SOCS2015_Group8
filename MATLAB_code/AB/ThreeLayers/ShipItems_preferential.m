function shippedItems = ShipItems_preferential(ordersArray, supply, distances, alpha)
%% ShipItems_preferential
% In case of SHORTAGE, preferably ship to nearest customers (= more profitable, or more loyal)

shippedItems = zeros(1,size(ordersArray,2));

% transform supply into a column vector, if necessary
if size(supply,2) < size(supply,1)
	supply = supply';
end

requestsToSuppliers = sum(ordersArray,2);

for iSupplier=1:length(supply)
    
    inStock = supply(iSupplier);
    customersIndices = find(ordersArray(iSupplier,:)); % find indices of customers of current supplier
    
    % case 1: supply exceeds demand -> satisfy demand
    if inStock >= requestsToSuppliers(iSupplier)
        shippedItems(customersIndices) = ordersArray(iSupplier,customersIndices);

    else
        % case 2: demands exceeds supply -> preferential shipment
        customersDistances = distances(iSupplier,customersIndices); % find distances
        [~, sortingOrder] = sort(customersDistances); % sort them
        orderedIndices = customersIndices(sortingOrder); % reorder customers list
        
        % then ship to this customers in order until out of stock
        while inStock > 0 && ~isempty(customersIndices)
            iCustomer = orderedIndices(1); % take first customer in the list
            order = ordersArray(iSupplier, iCustomer); % look how much he has ordered
            
            profit = order - alpha*order*distances(iSupplier, iCustomer); % compute profit for shipping to him
            if profit < 0 % if this customer is unprofitable
                orderedIndices(1) = []; % don't ship to him and remove him from the list
            elseif order < inStock % if there is enough in stock
                shippedItems(iCustomer) = order; % give him what he ordered
                inStock = inStock - order; % decrease the stock
                orderedIndices(1) = []; % and remove the customer from the list
            else % there are fewer items in stock than ordered by this customer
                shippedItems(iCustomer) = inStock; % give hime all that is left in stock
                inStock = 0; % set stock as depleted
            end
        end
        
    end

end

end
