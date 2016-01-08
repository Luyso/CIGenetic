function Population = NN_initpop(nvars,FitnessFnc,options,max_n,min_n,inMLP1,pertInC1,inMLP2,pertInC2,...
    tarMLP1,newTarMLP1,tarMLP2,newTarMLP2,...
    inRBF1,inRBF2,tarRBF1,newTarRBF1,tarRBF2,newTarRBF2,...
    inANFIS1,inANFIS2,tarANFIS1,newTarANFIS1,tarANFIS2,newTarANFIS2)

%% Create the networks
n = randi([min_n,max_n],1,1);
MLP1 = generate_mlp(inMLP1,tarMLP1,n);
n = randi([min_n,max_n],1,1);
MLP2 = generate_mlp(inMLP2,tarMLP2,n);

% Generate new unsupervised data

NewTargetMLP2 = MLP1(pertInC1');
NewTargetMLP1 = MLP2(pertInC2');

% Train networks with unsupervised and supervised data

MLP2 = train(MLP2,pertInC2',NewTargetMLP1);
MLP1 = train(MLP1,pertInC1',NewTargetMLP2);
                        
%%
MaxNeurons = 50;
Spread = rand();
RBF1 = GenerateRBF(inRBF1,tarRBF1,Spread,MaxNeurons);
Spread = rand();
RBF2 = GenerateRBF(inRBF2,tarRBF2,Spread,MaxNeurons);

% Generate new unsupervised data
NewTargetRBF2 = RBF1(pertInC1');
NewTargetRBF1 = RBF2(pertInC2');

% Train networks with unsupervised and supervised data
RBF2 = train(RBF2,pertInC2',NewTargetRBF1); 
RBF1 = train(RBF1,pertInC1',NewTargetRBF2);

%%

NumMfs = randi([3,7],1,1);
NumEpochs = 20;

ANFIS1 = GenerateANFIS(inANFIS1,tarANFIS1,NumMfs,NumEpochs);
ANFIS2 = GenerateANFIS(inANFIS1,tarANFIS1,NumMfs,NumEpochs);

NewTargetANFIS2 = evalfis(pertInC1',ANFIS1);
NewTargetANFIS1 = evalfis(pertInC2',ANFIS2);

ANFIS1 = GenerateANFIS(pertInC1,NewTargetANFIS1,NumMfs,NumEpochs);
ANFIS2 = GenerateANFIS(pertInC2,NewTargetANFIS2,NumMfs,NumEpochs);
%%

Chromosome = struct;
Chromosome.r1 = randi([1,3],1,1);
Chromosome.MLP1 = MLP1;
Chromosome.RBF1 = RBF1;
Chromosome.ANFIS1 = ANFIS1;
Chromosome.r2 = randi([1,3],1,1);
Chromosome.MLP2 = MLP2;
Chromosome.RBF2 = RBF2;
Chromosome.ANFIS2 = ANFIS2;

Population = Chromosome;

end