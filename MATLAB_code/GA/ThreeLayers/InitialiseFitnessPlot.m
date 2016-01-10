function maxFitnessFigure = InitialiseFitnessPlot(initialFitness)
% InitialiseFitnessPlot 
% Initialise the plot of the fitness of the best VIABLE solution

maxFitnessFigure = figure();
set(maxFitnessFigure, 'DoubleBuffer','on');
set(maxFitnessFigure, 'Position', [200,180,680,640], 'Color','w');
hold on;

maxFitnessFigure = plot(0, initialFitness,'LineWidth',1.5);
%xlim([1 nGenerations]);
xlabel('Generation');
ylabel('Supply chain profit (best solution)');
set(gca, 'FontSize', 16);
axis square;

drawnow;
hold off;

end