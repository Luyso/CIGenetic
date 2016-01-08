function state = gaplotbestfun(options,state,flag)
%GAPLOTBESTFUN Plots the best score and the mean score.

%   Copyright 2005-2014 The MathWorks, Inc. 

if(strcmp(flag,'init'))
    set(gca,'xlim',[1,options.Generations]);
    xlabel('Generation','interp','none');
    grid on
    ylabel('Fitness value','interp','none');
end

hold on;
generation = state.Generation;
best = min(state.Score);
plot(generation,best, 'v');
title(['Best: ',num2str(best)],'interp','none')
hold off;
        
