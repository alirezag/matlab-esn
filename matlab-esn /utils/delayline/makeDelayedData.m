function [ o ] = makeDelayedData( in , tau)
%UNTITLED2 This will use moving windows on the timeseries in to create a
%data set with tau dimentions starting from time step t. Columns must must
% data dimensions and rows shold be time.
%  
    width = size(in,2);
    Tlen = size(in,1);
    o = zeros(Tlen-tau,(tau+1)*width);
    
    for ni=1:Tlen-tau
        o(ni,:) = reshape(in(ni:ni+tau,:),1,width*(tau+1));
        
    end
end

