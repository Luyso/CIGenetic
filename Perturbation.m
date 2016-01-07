%%function output = perturb(input,max_range,min_range)
% Load data
filename = 'neural_data.xlsx';
NewF1 =  xlsread(filename, 'D32:D81');
NewF2 =  xlsread(filename, 'E32:E81');
NewF3 =  xlsread(filename, 'F32:F81');
NewF4 =  xlsread(filename, 'G32:G81');
NewF5 =  xlsread(filename, 'K32:K81');
NewF6 =  xlsread(filename, 'L32:L81');

NewFs = [NewF1, NewF2, NewF3, NewF4];

%Risk Input Perturbation
R1L1New = xlsread('neural_data.xlsx','R32:R81');
R1L2New = xlsread('neural_data.xlsx','V32:V81');
R1L3New = xlsread('neural_data.xlsx','Z32:Z81');

R2L1New = xlsread('neural_data.xlsx','AE32:AE81');
R2L2New = xlsread('neural_data.xlsx','AI32:AI81');
R2L3New = xlsread('neural_data.xlsx','AL32:AL81');

R3L1New = xlsread('neural_data.xlsx','AQ32:AQ81');
R3L2New = xlsread('neural_data.xlsx','AU32:AU81');
R3L3New = xlsread('neural_data.xlsx','AX32:AX81');


for i=1:50
R1L1Pert(i) = randi([0 2],1,1);
R2L1Pert(i) = randi([0 2],1,1);
R3L1Pert(i) = randi([0 2],1,1);
end

% Generate new data with a certain perturbation

INCpert = 1 + (1.01-1).*rand(50,4); % Max 1% of perturbation
DECPert = 0.99 + (1-0.99).*rand(50,4); % Max 1% of perturbation

INCPertNewFs = INCpert.*NewFs;
DECPertNewFs = DECPert.*NewFs;

% Check any value exceeds the range [0,1]
for i = 1:4
    for j = 1:50
    if (INCPertNewFs(j,i) > 1), INCPertNewFs(j,i)=1; end
    end
end
  
for i = 1:4
    for j = 1:50
    if (DECPertNewFs(j,i) > 1), DECPertNewFs(j,i)=1; end
    end
end

% Generate unsupervised data for next training - Classifier 1
Perturbed_inputs = [INCPertNewFs(:,1),NewF2,NewF3,NewF4];
Union1 = [Perturbed_inputs' gen_factors'];
Union1 = Union1'; % 120x4
outputsnew = MLP_GP.net(Union1'); % 1x120
F5 = [NewF5' C1F1'];
F5 = F5';
F6 = [NewF6' C1F2'];
F6 = F6';
InputC1 = [outputsnew' F5 F6]; % 120x1 U 120x2
NewTargetMLP1 = MLP1(InputC1')'; % 1x120
NewTargetRBF1 = RBF1(InputC1')'; % 1x120
NewTargetsANFIS1 = evalfis(InputC1',ANFIS1);

% Generate unsupervised data for next training - Classifier 2
R1InputPert = [R1L1Pert' R1L2New R1L3New];
R2InputPert = [R2L1Pert' R2L2New R2L3New];
R3InputPert = [R3L1Pert' R3L2New R3L3New];
R1InputPert = [R1InputPert' R1Input'];
R1InputPert = R1InputPert';
R2InputPert = [R2InputPert' R2Input'];
R2InputPert = R2InputPert';
R3InputPert = [R3InputPert' R3Input'];
R3InputPert = R3InputPert';
% Calculating Outputs of Nets with those Perturbed Inputs
OutMLPR1 = MLP_R1.net(R1InputPert');
OutMLPR1= OutMLPR1';
OutMLPR2 = MLP_R2.net(R2InputPert');
OutMLPR2= OutMLPR2';
OutMLPR3 = MLP_R3.net(R3InputPert');
OutMLPR3= OutMLPR3';
% Combining outputs for Input to C2
C2InputPert = [OutMLPR1 OutMLPR2 OutMLPR3];
% Calculating Outputs(Targets for C1) from C2
NewTargetMLP2 = MLP2(C2InputPert');
NewTargetMLP2 = NewTargetMLP2';
NewTargetRBF2 = RBF2(C2InputPert');
NewTargetRBF2 = NewTargetRBF2'; 
NewTargetANFIS2 = evalfis(C2InputPert', ANFIS2); 

%% Plot results F1 and F4 %%

% Max 10% disturbance
close all
subplot(2,2,1), plot(NewF1,NewF4,'+'), title('F1 VS F4');
subplot(2,2,2), plot(INCPertNewFs(:,1),NewF4,'+'), title('PertF1 VS F4');
subplot(2,2,3), plot(NewF1,INCPertNewFs(:,4),'+'), title('F1 VS PertF4');
subplot(2,2,4), plot(INCPertNewFs(:,1),INCPertNewFs(:,4),'+'), title('PertF1 VS PertF4');

% Max 20% disturbance
figure
subplot(2,2,1), plot(NewF1,NewF4,'o'), title('F1 VS F4');
subplot(2,2,2), plot(DECPertNewFs(:,1),NewF4,'o'), title('PertF1 VS F4');
subplot(2,2,3), plot(NewF1,DECPertNewFs(:,4),'o'), title('F1 VS PertF4');
subplot(2,2,4), plot(DECPertNewFs(:,1),DECPertNewFs(:,4),'o'), title('PertF1 VS PertF4');

std(NewF1)
std(INCPertNewFs(:,1))
std(NewF4)
std(INCPertNewFs(:,4))

%% Plot results F2 and F3 %%
% Max 10% disturbance
close all
subplot(2,2,1), plot(NewF2,NewF3,'+'), title('F2 VS F3');
subplot(2,2,2), plot(INCPertNewFs(:,2),NewF3,'+'), title('PertF2 VS F3');
subplot(2,2,3), plot(NewF2,INCPertNewFs(:,3),'+'), title('F2 VS PertF3');
subplot(2,2,4), plot(INCPertNewFs(:,2),INCPertNewFs(:,3),'+'), title('PertF2 VS PertF3');

% Max 20% disturbance
figure
subplot(2,2,1), plot(NewF2,NewF3,'o'), title('F2 VS F3');
subplot(2,2,2), plot(DECPertNewFs(:,2),NewF3,'o'), title('PertF2 VS F3');
subplot(2,2,3), plot(NewF2,DECPertNewFs(:,3),'o'), title('F2 VS PertF3');
subplot(2,2,4), plot(DECPertNewFs(:,2),DECPertNewFs(:,3),'o'), title('PertF2 VS PertF3');
%%