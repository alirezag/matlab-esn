function [ e, MSE, NMSE, RNMSE, NRMSE, SAMP ] = calcErr( y, target )
%calcErr Calculate error using four different methods.

    % first get the raw error
    e = (y-target);

    % now get MSE
    MSE = mean(e.^2);

    % now get NMSE
    NMSE = MSE./var(target);

    % now get RNMSE
    RNMSE = sqrt(NMSE);

    % NRMSE
    NRMSE = sqrt(MSE)./(max(target)-min(target));

    % SAMP
    SAMP = 100*(mean(abs(e)./((abs(y)+abs(target)))));


end

