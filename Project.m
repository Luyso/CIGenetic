%% Load data like there is no tomorrow

gen_factors =  xlsread('neural_data.xlsx', 'D31:G101');
gen_perc = xlsread('neural_data.xlsx',  'I32:I101');
% Risk Caution MLP %%
R1L1 = xlsread('neural_data.xlsx','R32:R101');
R1L2 = xlsread('neural_data.xlsx','V32:V101');
R1L3 = xlsread('neural_data.xlsx','Z32:Z101');
R1T = xlsread('neural_data.xlsx','AA32:AA101');
% Risk 2
R2L1 = xlsread('neural_data.xlsx','AE32:AE101');
R2L2 = xlsread('neural_data.xlsx','AI32:AI101');
R2L3 = xlsread('neural_data.xlsx','AL32:AL101');
R2T = xlsread('neural_data.xlsx','AM32:AM101');
% Risk 3
R3L1 = xlsread('neural_data.xlsx','AQ32:AQ101');
R3L2 = xlsread('neural_data.xlsx','AU32:AU101');
R3L3 = xlsread('neural_data.xlsx','AX32:AX101');
R3T = xlsread('neural_data.xlsx','AY32:AY101');
% Input matrix
R1Input = [R1L1, R1L2, R1L3];
R2Input = [R2L1, R2L2, R2L3];
R3Input = [R3L1, R3L2, R3L3];

% Classifier 1 inputs
C1F1 = xlsread('neural_data.xlsx','K32:K101');
C1F2 = xlsread('neural_data.xlsx','L32:L101');
C1GP = xlsread('neural_data.xlsx','I32:I101');
C1F1T = C1F1';
C1F2T = C1F2';
C1GPT = C1GP';
inputsRBF1 = [C1F1T; C1F2T; C1GPT];
inputsMLP1 = [C1F1, C1F2, C1GP];
inputsANFIS1 = [C1F1 C1F2 C1GP];
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
% Classifier 2 targets
targetsMLP2 = xlsread('neural_data.xlsx','BA32:BA101');
targetsRBF2 = targetsMLP2';
targetsANFIS2 = targetsMLP2;
% Classifier 2 inputs
R1T = xlsread('neural_data.xlsx','AA32:AA101');
R2T = xlsread('neural_data.xlsx','AM32:AM101');
R3T = xlsread('neural_data.xlsx','AY32:AY101');
inputsANFIS2 = [R1T R2T R3T];

% Classifier 2 output
C2OUT = xlsread('neural_data.xlsx','BA32:BA101');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                  Part I - Design of the MLP networks                    %           
%                                                                         %
%        There will be three systems: GP, Risk 1,Risk 2 & Risk 3          %
%                                                                         %
% Estimated time: 15 mins                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                            %%%%%%%%%%%%%%%%
                         %%%%    GP MLP    %%%%
                            %%%%%%%%%%%%%%%%
max_n = 15;
min_n = 6;
[MSE_GP,MLP_GP] = getBest(gen_factors,gen_perc,max_n, min_n);

                            %%%%%%%%%%%%%%%%
                         %%%%  RISK 1 MLP  %%%%
                            %%%%%%%%%%%%%%%%

[MSE_R1,MLP_R1] = getBest(R1Input,R1T,max_n, min_n);
 
                            %%%%%%%%%%%%%%%%
                         %%%%  RISK 2 MLP  %%%%
                            %%%%%%%%%%%%%%%%

[MSE_R2,MLP_R2] = getBest(R2Input,R2T,max_n, min_n);

                            %%%%%%%%%%%%%%%%
                         %%%%  RISK 3 MLP  %%%%
                            %%%%%%%%%%%%%%%%

[MSE_R3,MLP_R3] = getBest(R3Input,R3T,max_n, min_n);

%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%             Part II - Design of the Classifiers C1 & C2                 %           
%                                                                         %
%  Each classifier x is composed by three systems: MLPx, RBFx and ANFISx  %
%                                                                         %
%              Training the Systems: Step one - Supervised data           %
%                                                                         %
%  Estimated time: 3 minutes                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                              %%%%%%%%%%%%%%%%%%
                           %%%%% CLASSIFIER 1 %%%%%
                              %%%%%%%%%%%%%%%%%%

% MLP1 %
%%%%%%%%
n = 9; % randi([min_n,max_n],1,1);
MLP1 = generate_mlp(inputsMLP1,targetsMLP1,n);

% RBF1 %
%%%%%%%%
MaxNeurons = 50;
Spread = 0.5;
RBF1 = GenerateRBF(inputsRBF1,targetsRBF1,MaxNeurons,Spread);

% ANFIS 1 %
%%%%%%%%%%%
% Classifier 1 output
NumMfs = 5;
NumEpochs = 20;
ANFIS1 = GenerateANFIS(inputsANFIS1,targetsANFIS1,NumMfs,NumEpochs);


                              %%%%%%%%%%%%%%%%%%
                           %%%%% CLASSIFIER 2 %%%%%
                              %%%%%%%%%%%%%%%%%%

% MLP2 %
%%%%%%%%
n = randi([min_n,max_n],1,1);
iterations = 10;
MLP2 = generate_mlp(inputsMLP2,targetsMLP2,n);

% RBF2 %
%%%%%%%%
MaxNeurons = 50;
Spread = rand();
RBF2 = GenerateRBF(inputsRBF2,targetsRBF2,Spread,MaxNeurons);

% ANFIS 2 %
%%%%%%%%%%%
NumEpochs = 20;
ANFIS2 = GenerateANFIS(inputsANFIS2,C2OUT,NumMfs,NumEpochs);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                   Training the systems: Step two.                       %

%             First of all, Perturbation.m file must be run               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                        % MLP1 & MLP2 %

MLP2 = train(MLP2,C2InputPert',NewTargetMLP1');
MLP1 = train(MLP1,InputC1',NewTargetMLP2');
                        
                        % RBF1 & RBF2 %
                        
% Unsupervised data (only inputs) --> RFB1 Output ---> Target of RBF2 
% --> Output of RBF2 --> Target of RBF1

RBF2 = train(RBF2,C2InputPert',NewTargetRBF1'); 
RBF1 = train(RBF1,InputC1',NewTargetRBF2');

                        % ANFIS1 & ANFIS2 %

%Now we have to Train Six System with above Training Samples
%For Classifier 1[Training ANFIS1]
NumMfs = 5;
NumEpochs = 20;
ANFIS1Net = GenerateANFIS(InputC1,NewTargetANFIS2,NumMfs,NumEpochs);
ANFIS2Net = GenerateANFIS(C2InputPert,NewTargetsANFIS1,NumMfs,NumEpochs);

%% At this point generate the new population %%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% Fitness Function
TargetC1 = xlsread('neural_data.xlsx','N32:N101');
InputsC1 = inputsANFIS1;
InputsC2 = inputsMLP2;
TargetC2 = xlsread('neural_data.xlsx','BA32:BA101');
%
Score = NN_Fitness(Population,InputsC1,TargetC1,InputsC2,TargetC2);

%%
% Parameter for each function:
neurons = randi([MinNeurons,MaxNeurons],1,1); % Number of neurons for MLP
spread = rand(); % Spread value for RBF
MembershipFunctions = randi([3,7],1,1); % Number of mem. funct. for ANFIS


%% Missmatch

TargetC1 = xlsread('neural_data.xlsx','N32:N101');
TargetC2 = xlsread('neural_data.xlsx','BA32:BA101');
Pairs = [TargetC1 TargetC2];
j=1;
k=1;
l=1;
for i=1:70
if (Pairs(i,1)>0.52) 
    AHigh(j,:) = Pairs(i,:);
    j = j+1;

    elseif (Pairs(i,1)<=0.3) 
    ALow(k,:) = Pairs(i,:);
    k = k+1;
    
    else
        AMedium(l,:) = Pairs(i,:);
        l=l+1;
        
end
end

min(AHigh(:,2))
max(ALow(:,2))
max(AMedium(:,2))