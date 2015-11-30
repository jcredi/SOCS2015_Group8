%!synclient HorizTwoFingerScroll=0
C = 100; %number of customers
S = 10; % number of stores
size = 10; %size of the world
radius = 1; %interaction radius
width = 0.005 * radius; %for the Gaussian
zero_prob = 1e-5; %prob if no connection
gain = 100; %gain due profitable shopping
runs = 100; %shopping runs
signs = [ 0 0; 0 1; 1 0; 1 1; -1 -1; -1 1; 1 -1; 0 -1; -1 0;]; %periodicity

%initialization of the arrays
distance = ones(C,S); %minimum distance periodic boundaries
connections = ones(C,S); %0 and 1 for connection
probabilities = ones(C,S) - 1; 
spinning_wheel = ones(C,S);
demand = ones(C,1);
capacity = ones(S,1) * C/S;
output = ones(runs,1);

%positions in the world
stor = rand(2,S) * size;
cust = rand(2,C) * size;
plot(cust(1,1:C), cust(2,1:C), 'b.', stor(1,1:S) , stor(2,1:S), 'ro' );

%help variables
a = ones(2,1);
b = 0;
minimum = 0;

%here we initialize the network
for k = 1:C
    for j = 1:S
        minimum = 100;
        %this loop will take care of the periodic boundary conditions
        for m = 1:9 %we need the length of the signs 9
            a(1) = cust(1,k) - stor(1,j) - size * signs(m,1);
            a(2) = cust(2,k) - stor(2,j) - size * signs(m,2);
            b = sqrt(dot(a,a));
            %disp(b);
            if b < minimum
                minimum = b;
            end
        end
        %write minimum distance in the distance array
        distance(k,j) = minimum;
        %delete connection if distance is larger then radius
        %build a gaussian to get somehow an initial probability
        if minimum > radius
            connections(k,j) = 0;
            probabilities(k,j) = zero_prob;
        else
            probabilities(k,j) = exp( - minimum^2 / width^2);
        end
    end
end


%perform n shopping runs
for p = 1:runs
    %at every iteration the demand is reset and the capacity is filled up
    summe = 0;
    demand = ones(C,1);
    capacity = ones(S,1) * C / S;

    %create a spinning wheel to select a shop with probability p
    for l = 1:C
        summe = 0;
        for n = 1:S
            summe = summe + probabilities(l,n);
            spinning_wheel(l,n) = summe;
        end
        spinning_wheel(l,1:S) = spinning_wheel(l,1:S) / summe;
        probabilities(l,1:S) = probabilities(l,1:S) / summe;
    end
    
    %initialize indices for choosing randomly customers and shops with
    %prob. p
    index_shift_C = 0;
    index_S = 0;
    index_vector = ones(C,1);
    index_loop = 0;
    
    %iterates randomly over all customers and choose store with probability p
    for o = 1:C
        index_vector = find(demand); %find unsatisfied customers
        index_shift_C = floor(rand * length(index_vector)); 
        index_loop = index_vector(index_shift_C + 1); %choose a random unsatisfied customer
        random = rand;
        index_S = find(random < spinning_wheel(o,1:S),1);%find his shop with spinning the wheel
        
        if capacity(index_S) > 0 %In stock?
            capacity(index_S) = capacity(index_S) - 1;
            demand(index_loop) = demand(index_loop) - 1;
            %profit from successful shopping
            probabilities(index_loop,index_S) = probabilities(index_loop,index_S) + gain;
        else
            probabilities(index_loop,index_S) = probabilities(index_loop,index_S);
        end
        
    end
    %calculate the left over capacity
    output(p) = sum(capacity);
end
plot(output)
%index_vector
