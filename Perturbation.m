%%function output = perturb(input,max_range,min_range)
% Load data
filename = 'neural_data.xlsx';

NewF1 =  xlsread(filename, 'D32:D81');
NewF2 =  xlsread(filename, 'E32:E81');
NewF3 =  xlsread(filename, 'F32:F81');
NewF4 =  xlsread(filename, 'G32:G81');
NewF5 =  xlsread(filename, 'K32:K81');
NewF6 =  xlsread(filename, 'L32:L81');

NewFs = [NewF1, NewF2, NewF3, NewF4];



%% Generate new data with a certain perturbation

INCpert = 1 + (1.1-1).*rand(50,4); % Max 10% of perturbation
DECPert = 0.9 + (1-0.90).*rand(50,4); % Max 20% of perturbation

INCPertNewFs = INCpert.*NewFs;
DECPertNewFs = DECPert.*NewFs;

% Check any value exceeds the range [0,1]
for i = 1:4
    for j = 1:50
    if (INCPertNewFs(j,i) > 1), INCPertNewFs(j,i)=1; end
    end
end
  
for i = 1:4
    for j = 1:50
    if (DECPertNewFs(j,i) > 1), DECPertNewFs(j,i)=1; end
    end
end
    
%% Plot results F1 and F4 %%

% Max 10% disturbance
close all
subplot(2,2,1), plot(NewF1,NewF4,'+'), title('F1 VS F4');
subplot(2,2,2), plot(INCPertNewFs(:,1),NewF4,'+'), title('PertF1 VS F4');
subplot(2,2,3), plot(NewF1,INCPertNewFs(:,4),'+'), title('F1 VS PertF4');
subplot(2,2,4), plot(INCPertNewFs(:,1),INCPertNewFs(:,4),'+'), title('PertF1 VS PertF4');

% Max 20% disturbance
figure
subplot(2,2,1), plot(NewF1,NewF4,'o'), title('F1 VS F4');
subplot(2,2,2), plot(DECPertNewFs(:,1),NewF4,'o'), title('PertF1 VS F4');
subplot(2,2,3), plot(NewF1,DECPertNewFs(:,4),'o'), title('F1 VS PertF4');
subplot(2,2,4), plot(DECPertNewFs(:,1),DECPertNewFs(:,4),'o'), title('PertF1 VS PertF4');

std(NewF1)
std(INCPertNewFs(:,1))
std(NewF4)
std(INCPertNewFs(:,4))

%% Plot results F2 and F3 %%
% Max 10% disturbance
close all
subplot(2,2,1), plot(NewF2,NewF3,'+'), title('F2 VS F3');
subplot(2,2,2), plot(INCPertNewFs(:,2),NewF3,'+'), title('PertF2 VS F3');
subplot(2,2,3), plot(NewF2,INCPertNewFs(:,3),'+'), title('F2 VS PertF3');
subplot(2,2,4), plot(INCPertNewFs(:,2),INCPertNewFs(:,3),'+'), title('PertF2 VS PertF3');

% Max 20% disturbance
figure
subplot(2,2,1), plot(NewF2,NewF3,'o'), title('F2 VS F3');
subplot(2,2,2), plot(DECPertNewFs(:,2),NewF3,'o'), title('PertF2 VS F3');
subplot(2,2,3), plot(NewF2,DECPertNewFs(:,3),'o'), title('F2 VS PertF3');
subplot(2,2,4), plot(DECPertNewFs(:,2),DECPertNewFs(:,3),'o'), title('PertF2 VS PertF3');
