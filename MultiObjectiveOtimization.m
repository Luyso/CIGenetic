addpath('globaloptim2');
nvars=1;
FitnessFCN = @NN_Fitness;

options = gaoptimset;
options = gaoptimset(options,'PopulationSize',50,'Generations',100);
options = gaoptimset(options,'PopulationType','custom','CrossoverFraction',0,'Vectorized','on');
options = gaoptimset(options,'InitialPopulation',Population); %'MutationFcn',@NN_mutation
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'PlotFcns',@gaplotpareto2);

options

disp('Options loaded correctly');
%%
X = gamultiobj2(FitnessFCN,nvars,[],[],[],[],[],[],options);
disp('Pareto Set X generated');