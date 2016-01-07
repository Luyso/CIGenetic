function Chromosome = generateChromosome(max_n,min_n,inMLP1,pertInC1,inMLP2,pertInC2,...
    tarMLP1,newTarMLP1,tarMLP2,newTarMLP2,...
    inRBF1,inRBF2,tarRBF1,newTarRBF1,tarRBF2,newTarRBF2,...
    inANFIS1,inANFIS2,tarANFIS1,newTarANFIS1,tarANFIS2,newTarANFIS2)

%% Create the networks
n = randi([min_n,max_n],1,1);
MLP1 = generate_mlp(inMLP1,tarMLP1,n);
n = randi([min_n,max_n],1,1);
MLP2 = generate_mlp(inMLP2,tarMLP2,n);

%% Train networks with unsupervised and supervised data
MLP2 = train(MLP2,pertInC2',newTarMLP1');
MLP1 = train(MLP1,pertInC1',newTarMLP2');
                        
%%
MaxNeurons = 50;
Spread = rand();
RBF1 = GenerateRBF(inRBF1,tarRBF1,Spread,MaxNeurons);
Spread = rand();
RBF2 = GenerateRBF(inRBF2,tarRBF2,Spread,MaxNeurons);

%% Train networks with unsupervised and supervised data
RBF2 = train(RBF2,pertInC2',newTarRBF1'); 
RBF1 = train(RBF1,pertInC1',newTarRBF2');
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section will be modified with the correspond function for the 
% ANFIS systems 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumMfs = 5;
NumEpochs = 20;
ANFIS1 = GenerateANFIS(pertInC1,newTarANFIS2,NumMfs,NumEpochs);
ANFIS2 = GenerateANFIS(pertInC2,newTarANFIS1,NumMfs,NumEpochs);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Chromosome = struct;
Chromosome.r1 = randi([1,3],1,1);
Chromosome.MLP1 = MLP1;
Chromosome.RBF1 = RBF1;
Chromosome.ANFIS1 = ANFIS1;
Chromosome.r2 = randi([1,3],1,1);
Chromosome.MLP2 = MLP2;
Chromosome.RBF2 = RBF2;
Chromosome.ANFIS2 = ANFIS2;

%%


end