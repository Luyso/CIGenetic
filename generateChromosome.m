function Chromosome = generateChromosome(max_n,min_n,inMLP1,pertInC1,inMLP2,pertInC2,...
    tarMLP1,newTarMLP1,tarMLP2,newTarMLP2,...
    inRBF1,inRBF2,tarRBF1,newTarRBF1,tarRBF2,newTarRBF2,...
    inANFIS1,inANFIS2,tarANFIS1,newTarANFIS1,tarANFIS2,newTarANFIS2)

%% Create the networks
n = randi([min_n,max_n],1,1);
MLP1Net = generate_mlp(inMLP1,tarMLP1,n);
n = randi([min_n,max_n],1,1);
MLP2Net = generate_mlp(inMLP2,tarMLP2,n);

%% Train networks with unsupervised and supervised data
MLP2Net = train(MLP2Net,pertInC2',newTarMLP1');
MLP1Net = train(MLP1Net,pertInC1',newTarMLP2');
                        
%%
MaxNeurons = 50;
Spread = rand();
RBF1Net = GenerateRBF(inRBF1,tarRBF1,Spread,MaxNeurons);
%%%%

Spread = rand();
RBF2Net = GenerateRBF(inRBF2,tarRBF2,Spread,MaxNeurons);

%% Train networks with unsupervised and supervised data
RBF2Net = train(RBF2Net,pertInC2',newTarRBF1'); 
RBF1Net = train(RBF1Net,pertInC1',newTarRBF2');
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section will be modified with the correspond function for the 
% ANFIS systems 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumMfs = 5;
NumEpochs = 20;
ANFIS1Net = GenerateANFIS(pertInC1,newTarANFIS2,NumMfs,NumEpochs);
ANFIS2Net = GenerateANFIS(pertInC2,newTarANFIS1,NumMfs,NumEpochs);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Chromosome = struct;
Chromosome.r1 = randi([1,3],1,1);
Chromosome.MLP1 = MLP1Net;
Chromosome.RBF1 = RBF1Net;
Chromosome.ANFIS1 = ANFIS1Net;
Chromosome.r2 = randi([1,3],1,1);
Chromosome.MLP2 = MLP2Net;
Chromosome.RBF2 = RBF2Net;
Chromosome.ANFIS2 = ANFIS2Net;

%%


end