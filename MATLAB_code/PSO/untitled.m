%ResourceAllocation
clear; close all; clc

nCustomers = 100;
nStores = 10;
volumes = rand(nCustomers,nStores);
demand = 10*ones(nCustomers,1);
capacity = 100*ones(1, nStores);
muValues = [1, 10, 100, 1000];
muPenalty = 1000;