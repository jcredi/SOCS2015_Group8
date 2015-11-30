function mutatedChromosome = Mutate(chromosome, mutationProbability, nCustomers, nStores)
% Mutate

mutatedChromosome = chromosome;

for iCustomer = 1:nCustomers
    if rand() < mutationProbability
        newStore = randi(nStores+1);
        if newStore == nStores+1
            newStore = NaN;
        end
        mutatedChromosome(iCustomer) = newStore;
        
        % or swap mutations
        % WARNING: only use swap mutations if using problem specific
        % operators!!!
        
%         swapWith = randi(nCustomers);
%         tmp = chromosome(iCustomer);
%         chromosome(iCustomer) = chromosome(swapWith);
%         chromosome(swapWith) = tmp;
    end
end

end