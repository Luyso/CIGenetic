%% function fit = fitnes(population)

Population{1,1}.r1 = 3;
%%
if (Population{1,1}.r1 == 1)
    outputsC1 = Population{1,1}.MLP1(InputC1');
    
elseif (Population{1,1}.r1 == 2)
        outputsC1 = Population{1,1}.RBF1(InputC1'); 
else (Population{1,1}.r1 == 3)
          outputsC1 = evalfis(InputC1',Population{1,1}.ANFIS1);   
end


if (Population{1,1}.r2 == 1)
    outputsC2 = Population{1,1}.MLP2(C2InputPert');
    
elseif (Population{1,1}.r2 == 2)
        outputsC2 = Population{1,1}.RBF2(C2InputPert'); 
else (Population{1,1}.r2 == 3)
          outputsC2 = evalfis(C2InputPert',Population{1,1}.ANFIS2);   
end