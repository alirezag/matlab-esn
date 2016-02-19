function [ funcobj ] = setupSimulator( vararg )
%SETUPSIMULATOR setup the function to run the ESN
%   the vararg:
%   1: activation function pointer
%   2: transfer function pointer
%   3: hidden node bias

    function [states] = implementation(numIn, numP, states0, inputs, W, prefilters,postfilters)
        states = runTheNetworkSyncHom( numIn, numP, states0,...
                              inputs, W, prefilters,postfilters, vararg{1}, vararg{2},vararg{3});
    end

    funcobj = @implementation;
                    
end

