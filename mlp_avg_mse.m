function [result, testMseMean,testRegMean] = mlp_avg_mse( gen_factors, gen_perc, neurons, trials )

%calcola la trasposta
inputs = gen_factors';
targets = gen_perc';

result = cell(1);

for i = 1:trials 
                %creazione rete
                net = fitnet(neurons);
                % Divisione dati input
                net.divideParam.trainRatio = 70/100;
                net.divideParam.valRatio = 15/100;
                net.divideParam.testRatio = 15/100;
                
                % Training della rete
                [net,tr] = train(net,inputs,targets);
                
                % Test
                outputs = net(inputs);
               
                %Calcolo Performance sul set del testing
                testTargets = targets  .* tr.testMask{1};
                testPerformance(i) = perform(net,testTargets,outputs);
                
                reg(i) = regression(testTargets,outputs);
                disp(['iter: ',num2str(i)]);
                
                net_perf =struct;
                net_perf.net = net;
                net_perf.tr = tr;
                net_perf.perf = testPerformance(i);
                result{i} = net_perf;
           
            
                
end    

            disp(['Mse: ',num2str(testPerformance)]);
            disp(['regression: ',num2str(reg)]);
            testMseMean = mean( testPerformance);
            testRegMean = mean(reg);
            
            disp(['Test mse mean: ',num2str(testMseMean)]);
            disp(['Test regression mean: ', num2str(testRegMean)]);
                
            
            
            
            
            
            
end


