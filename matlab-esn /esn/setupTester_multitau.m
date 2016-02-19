function [ funcobj ] = setupTester_multitau( transientLength,tau,predictt )
%SETUPTRAINER returns a funtion that receives input, observed states, and
%target and test the output layer for multiple delays simultaneously. 
%   transientLength: the washout period.
%   tau: time before the output is produced
%   predictt: prediction horizen


    function [  y , OutAll, inputs , statesOut] = ...
            implementation (inputs,statesdata,outputs, W) 
        [  y , OutAll, inputs , statesOut] = ...
        doTestOLR_multitau( inputs , statesdata, outputs, W ,...
        transientLength , tau, predictt  );
    end
    funcobj = @implementation;
end

