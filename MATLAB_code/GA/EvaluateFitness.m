function fitness = EvaluateFitness(chromosome, nCustomers, payoffs)

fitness = 0;

for iCustomer = 1:nCustomers
    fitness = fitness + payoffs(chromosome(iCustomer), iCustomer);
end

end