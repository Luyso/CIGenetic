
% Load the inputs and targets

% Classifier 1 inputs
C1F1 = xlsread('neural_data.xlsx','K32:K101');
C1F2 = xlsread('neural_data.xlsx','L32:L101');
C1GP = xlsread('neural_data.xlsx','I32:I101');
C1F1T = C1F1';
C1F2T = C1F2';
C1GPT = C1GP';
inputsRBF1 = [C1F1T; C1F2T; C1GPT];
inputsMLP1 = [C1F1, C1F2, C1GP];
inputsANFIS1 = inputsMLP1;
% Classifier 1 targets
targetsRBF1 = xlsread('neural_data.xlsx','N32:N101');
targetsRBF1 = targetsRBF1';
targetsMLP1 = xlsread('neural_data.xlsx','N32:N101');
targetsANFIS1 = xlsread('neural_data.xlsx','N32:N101');
% Classifier 2 inputs
C2IR1 = xlsread('neural_data.xlsx','AA32:AA101'); % CLASSIFIER 2 INPUT RISK 1
C2IR2 = xlsread('neural_data.xlsx','AM32:AM101'); % CLASSIFIER 2 INPUT RISK 2
C2IR3 = xlsread('neural_data.xlsx','AY32:AY101'); % CLASSIFIER 2 INPUT RISK 3
C2IR1t = C2IR1';
C2IR2t = C2IR2';
C2IR3t = C2IR3';
inputsRBF2 = [C2IR1t; C2IR2t; C2IR3t];
inputsMLP2 = [C2IR1, C2IR2, C2IR3];
inputsANFIS2 = inputsMLP2;
% Classifier 2 targets
targetsMLP2 = xlsread('neural_data.xlsx','BA32:BA101');
targetsRBF2 = targetsMLP2';
targetsANFIS2 = targetsMLP2;


%%
MLP2Net = train(MLP2Net,C2InputPert',NewTargetMLP1');

MLP1Net = train(MLP1Net,InputC1',NewTargetMLP2');
                        

%% Generate chromosomes
max_n = 15;
min_n = 6;
m = 1;
Population = cell(1,m);

for i=1:m
Population{1,i} = generateChromosome(max_n,min_n,...
    inputsMLP1,InputC1,inputsMLP2,C2InputPert,...
    targetsMLP1,NewTargetMLP2,targetsMLP2,NewTargetMLP2,...
    inputsRBF1,inputsRBF2,...
    targetsRBF1,NewTargetRBF1,targetsRBF2,NewTargetRBF2,...
    inputsANFIS1,inputsANFIS2,...
    targetsANFIS1,NewTargetsANFIS1,targetsANFIS2,NewTargetANFIS2);


%%disp('Generated Chromosome number', i);
close all
end
close all