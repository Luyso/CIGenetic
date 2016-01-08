function  Score = NN_Fitness(Population)

C1F1 = xlsread('neural_data.xlsx','K32:K101');
C1F2 = xlsread('neural_data.xlsx','L32:L101');
C1GP = xlsread('neural_data.xlsx','I32:I101');
InputsC1 = [C1F1 C1F2 C1GP];
TargetC1 = xlsread('neural_data.xlsx','N32:N101');
C2IR1 = xlsread('neural_data.xlsx','AA32:AA101'); % CLASSIFIER 2 INPUT RISK 1
C2IR2 = xlsread('neural_data.xlsx','AM32:AM101'); % CLASSIFIER 2 INPUT RISK 2
C2IR3 = xlsread('neural_data.xlsx','AY32:AY101'); % CLASSIFIER 2 INPUT RISK 3
InputsC2 = [C2IR1, C2IR2, C2IR3];
TargetC2 = xlsread('neural_data.xlsx','BA32:BA101');
PopSize = 50;
Population = Population';
%To Calculate the first Objective O1 (MSE)
disp ('Calculating the first Objective O1');
for m=1:PopSize
    % MSE for C1 Part
    if(Population{m,1}.r1 == 1)
        OutputsMLP1 = Population{1,m}.MLP1(InputsC1');
        MSE1(1,m) = mse(Population{1,m}.MLP1,TargetC1,OutputsMLP1);
    elseif (Population{1,m}.r1 == 2)
        OutputsRBF1 = Population{1,m}.RBF1(InputsC1');
        MSE1(1,m) = mse(Population{1,m}.RBF1,TargetC1,OutputsRBF1);
    else
        OutputsANFIS1 = evalfis(InputsC1',Population{1,m}.ANFIS1);
        MSE1(1,m) = immse(TargetC1,OutputsANFIS1);
    end
% MSE for C2 Part
    if(Population{1,m}.r2 == 1)
        OutputsMLP2 = Population{1,m}.MLP2(InputsC2');
        MSE2(1,m) = mse(Population{1,m}.MLP2,TargetC2,OutputsMLP2);
    elseif (Population{1,1}.r2 == 2)
        OutputsRBF2 = Population{1,m}.RBF2(InputsC2');
        MSE2(1,m) = mse(Population{1,m}.RBF2,TargetC2,OutputsRBF2);
    else
        OutputsANFIS2 = evalfis(InputsC2',Population{1,m}.ANFIS2);
        MSE2(1,m) =immse(TargetC2,OutputsANFIS2);
      end
    Score(1,m) = min(MSE1(1,m),MSE2(1,m));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% ToCalcultae the Second ObjectiveO2 (#of Mismatches)
%  Classifier 1 output Ranges
% Low--> 0-0.2  Medium-->0.2-0.6 High-->0.6-1
%  Classifier 2 output Ranges
% Low--> 0-0.18  Medium-->0.18-0.45 High-->0.45-1
%A mismatch occurs if for the same input sample C1 Range is different from
%C2 Range

for m=1:PopSize
    if (Population{1,m}.r1 == 1)
        outputsC1 = Population{1,m}.MLP1(InputsC1');
    elseif (Population{1,m}.r1 == 2)
            outputsC1 = Population{1,m}.RBF1(InputsC1'); 
    else (Population{1,m}.r1 == 3)
              outputsC1 = evalfis(InputsC1',Population{1,m}.ANFIS1); 
              outputsC1 = outputsC1';
              
    end
outputsC1

    if (Population{1,m}.r2 == 1)
        outputsC2 = Population{1,m}.MLP2(InputsC2');

    elseif (Population{1,m}.r2 == 2)
            outputsC2 = Population{1,m}.RBF2(InputsC2'); 
    else (Population{1,m}.r2 == 3)
              outputsC2 = evalfis(InputsC2',Population{1,m}.ANFIS2);
               outputsC2 = outputsC2';
    end

    % Finding # of mismatches now
    mismatch=0;
for i=1:length(outputsC1)
        if (outputsC1(1,i) <= 0.2)
            if(outputsC2(1,i)< 0.0 || outputsC2(1,i) > 0.18) 
                mismatch= mismatch+1;
            end
        elseif (outputsC1(1,i) > 0.2) && (outputsC1(1,i) <= 0.6)
            if(outputsC2(1,i)< 0.18 || outputsC2(1,i) > 0.45) 
                mismatch= mismatch+1;
            end
        elseif (outputsC1(1,i) > 0.6)
            if(outputsC2(1,i)< 0.45) 
                mismatch= mismatch+1;
            end
    end
end

Score(2,m) = mismatch;
end
end
%%