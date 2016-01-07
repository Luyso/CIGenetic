%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                   Representation of the chromosome:                     %
%                                                                         %
%             |_r_|_MLP1_|_RBF1_|_ANFIS1_|_r_|_MLP2_|_RBF2_|_ANFIS2_|     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                  
%% Generate chromosomes (Estimated time 5*m mins)
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
    disp('Generated Chromosome number: ', i);

end

    