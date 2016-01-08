function [InputFismat,ANFISNet] = GenerateANFIS(inputsANFIS1,targetsANFIS1,NumMfs,NumEpochs)
trnOpt = [20,0.000001,0.01,0.9,1.1];
TrainData = [inputsANFIS1 targetsANFIS1];
MfType = 'gaussmf';  % Gaussian Membership functions
InputFismat = genfis1(TrainData, NumMfs, MfType); % Using Grid Partitioning
[ANFISNet MseAnfis1]  = anfis(TrainData, InputFismat, NumEpochs);
MinMSEAnfis1 = min(MseAnfis1);
end
