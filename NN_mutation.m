function mutatedPopulation = NN_mutation(parents,options,nvars,FitnessFnc,state,Score,Population,MutationFncArgs)


%%
 a = randi([1,3],1,1)
%%
prob  = 0.99 + (1.01 - 0.99).*rand();

for i=1:50
 Population{1,i}.r1 = a;
    
if (Population{1,i}.r1 == 1 ) 
    Population{1,1}.MLP1.IW{1,1} =Population{1,1}.MLP1.IW{1,1}*prob;
end

if (Population{1,1}.r1 == 2 )
   spread = max(1,(0.8326/Population{1,1}.RBF1.b{1,1})*prob);
   Population{1,1}.RBF1.b{1,1} =  Population{1,1}.RBF1.b{1,1}/spread;
   Population{1,1}.RBF1.IW{1,1} = Population{1,1}.RBF1.IW{1,1}*prob 

end

if (Population{1,i}.r1 == 3 )
 
    %%
  for k=1:3
      for j=1:5
          Population{1,i}.ANFIS1.input(k).mf(j).params= Population{1,i}.ANFIS1.input(k).mf(j).params .* prob;
      end
  end
  for c=1:125
      Population{1,i}.ANFIS1.output.mf(c).params = Population{1,i}.ANFIS1.output.mf(j).params*prob
  end
      %%
  
   
    
end
  
    


end

end


