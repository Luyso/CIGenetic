function [Mse net] = getBest(gen_factors, gen_perc,max_n,min_n)
    i=1;
    iterations = 10;
    Mse(10)=zeros;
    MinCell(iterations)= zeros;
    Min_Net(iterations ) = zeros;
    Array{1,max_n-min_n} = zeros;

for n = min_n : max_n 
[res,testmse,testreg]= mlp_avg_mse(gen_factors,gen_perc,n,iterations);
Mse(i) = testmse;
Reg(i) = testreg;
Array{i} = res;
i=i+1;
end
%%
Minimum = min(Mse);


for j= 1:i-1
    if (Mse(j) == Minimum)
        Min_Net = j;
    end
end
 
    for p = 1:iterations
        MinCell(p) = Array{Min_Net}{p}.perf;
        
    end;
   [minimo, minimoindice] = min(MinCell);
   
   net = Array{1,Min_Net}{1,minimoindice}

end
