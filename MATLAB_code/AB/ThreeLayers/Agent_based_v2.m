!synclient HorizTwoFingerScroll=0

kappa = 0.01;
width = 0.2;


distancesCW =  distances{1};
probabilitiesWS = zeros(nWarehouses, nManufacturers);

probabilitiesCW = exp(-distances{1}.^2 / width^2);
probabilitiesWS = exp(-distances{2}.^2 / width^2);

disp(probabilitiesCW);
