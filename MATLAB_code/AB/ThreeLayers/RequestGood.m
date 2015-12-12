function ordersArray = RequestGood(customersDemand, probabilities)
% RequestGood
ordersArray = zeros(size(probabilities));
iterations = length(customersDemand);
randOrder = randperm(iterations);

spinningWheel = cumsum(probabilities,1);
spinningWheel = spinningWheel ./ repmat(spinningWheel(end,:), size(probabilities,1) , 1 );
spins = rand(size(probabilities,2));
for k = 1:iterations
    indexS = find(spins(k) < spinningWheel(:,randOrder(k)),1);
    ordersArray(indexS, randOrder(k)) = customersDemand(randOrder(k));
end


end
