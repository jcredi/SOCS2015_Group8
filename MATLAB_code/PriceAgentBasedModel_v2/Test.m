function Test()

nbrOfOrders = 10;
tradeProbabilities = rand(10,5);
randomTransactions = zeros(1,nbrOfOrders);
iTransaction = 1;

    function UpdateRandomTransactions()
        randomTransactions = randp(tradeProbabilities(:),1,nbrOfOrders);
    end



    function [i,j] = ChooseTransaction()
        transaction = randomTransactions(iTransaction);
        [i,j] = ind2sub(size(tradeProbabilities),transaction);
        iTransaction = iTransaction + 1;
    end

UpdateRandomTransactions()

[i,j] = ChooseTransaction();
disp([i,j])

[i,j] = ChooseTransaction();
disp([i,j])

end

