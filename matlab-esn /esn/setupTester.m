function [ funcobj ] = setupTester( transientLength,tau,predictt )
%SETUPTRAINER returns a funtion that receives input, observed states, and
%target and test the output layer. 
%   transientLength: the washout period.
%   tau: time before the output is produced
%   predictt: prediction horizen



    function [  y , OutAll, inputs , statesOut] = ...
            implementation (inputs,statesdata,outputs, W) 
        [  y , OutAll, inputs , statesOut] = ...
        doTestOLR( inputs , statesdata, outputs, W ,...
        transientLength , tau, predictt  );
    end
    funcobj = @implementation;
end

