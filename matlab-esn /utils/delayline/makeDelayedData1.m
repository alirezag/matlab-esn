function [ o ] = makeDelayedData1( in , tau)
%UNTITLED2 This will use moving windows on the timeseries in to create a
%data set with tau dimentions starting from time step t. Columns must must
% data dimensions and rows shold be time.
%  
    width = size(in,2);
    len = size(in,1);
    o = zeros(len-tau,(tau+1)*width);
    
    for ni=1:length(in)-tau
        o(ni,:) = [in(ni,:) in(ni+tau,:)];
        
    end
end

