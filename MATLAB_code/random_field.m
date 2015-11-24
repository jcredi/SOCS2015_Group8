C = 100; %number of customers
S = 10; % number of stores
size = 10; %size of the world
radius = 3; %interaction radius
signs = [ 0 0; 0 1; 1 0; 1 1; -1 -1; -1 1; 1 -1; 0 -1; -1 0;]; %periodicity
%initialization of the arrays
distance = ones(C,S); %minimum distance periodic boundaries
connections = ones(C,S); %0 and 1 for connection

%positions in the world
stor = rand(2,S) * size;
cust = rand(2,C) * size;
plot(cust(1,1:C), cust(2,1:C), 'b.', stor(1,1:S) , stor(2,1:S), 'ro' );

%help variables
a = ones(2,1);
b = 0;
minimum = 0;

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
        if minimum > radius
            connections(k,j) = 0;
        end
    end
end
