% function fit = fitnes(population)
function  Score = NN_Fitness(Population,InputsC1,TargetC1,InputsC2,TargetC2)
%To Calculate the first Objective O1 (MSE)
PopSize=1;
Population{1,1}.r1 =3;

for m=1:PopSize
    % MSE for C1 Part
    if(Population{1,m}.r1 == 1)
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
% Low--> 0-0.25  Medium-->0.25-0.75 High-->0.75-1
%  Classifier 2 output Ranges
% Low--> 0-0.4  Medium-->0.4-0.8 High-->0.8-1
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
        if (outputsC1(1,i) <= 0.25)
            if(outputsC2(1,i)< 0.0 || outputsC2(1,i) > 0.4) 
                mismatch= mismatch+1;
            end
        elseif (outputsC1(1,i) > 0.25) && (outputsC1(1,i) <= 0.75)
            if(outputsC2(1,i)< 0.4 || outputsC2(1,i) > 0.8) 
                mismatch= mismatch+1;
            end
        elseif (outputsC1(1,i) > 0.75)
            if(outputsC2(1,i)< 0.8) 
                mismatch= mismatch+1;
            end
    end
end

Score(2,m) = mismatch;
end
end
%%