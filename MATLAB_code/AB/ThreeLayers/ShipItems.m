function suppliedItems = ShipItems(ordersArray, supply)
%% ShipItems
% Output: suppliedItems, ROW vector

% transform supply into a column vector, if necessary
if size(supply,2) < size(supply,1)
	supply = supply';
end

suppliedItems = zeros(1,size(ordersArray,2));

for supplier=1:length(supply)
    inStock = supply(supplier);
    customersList = find(ordersArray(supplier,:));
    
    while inStock > 0 && ~isempty(customersList)% as long as there are items in stock
        iCustomer = randi(numel(customersList)); % pick a random entry of the customers list
        customer = customersList(iCustomer);
        
        order = ordersArray(supplier, customer);
        
        if order < inStock % if this customers can be satisfied
            suppliedItems(customer) = order; % give him what he ordered
            inStock = inStock - order; % decrease the stock
            customersList(iCustomer) = []; % and remove customer from the list (consider it satisfied)
        else % there are fewer items in stock than ordered by this customer
            suppliedItems(customer) = inStock; % give hime what is left in stock
            inStock = 0;
        end
    end
end

end
