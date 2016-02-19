function [ y ] = transferSigmoid( inputSignal )
% Sigmoid transfer function for reservoir
%  
   y = ( 1./(1+exp(-inputSignal )) );
end

