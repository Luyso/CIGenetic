function net = generate_mlp(gen_factors, gen_perc,n)

iterations = 10;    
[res,testmse,testreg]= mlp_avg_mse(gen_factors,gen_perc,n,iterations);
Mse = testmse;
Array = res;

for j= 1:iterations
    perform(j) = Array{j}.perf;
end
 
for p = 1:iterations
    if (min(perform) == Array{p}.perf), net = Array{p}.net; end       
end;
   

end
