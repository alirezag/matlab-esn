function [ states, outputs, inputs ] = prepOutputDelay( states,  outputs, inputs, tr , tau , predictt)
%prepOutput Align the output and states data approperiately
%   in both states and output the time should be in the columns and rows
%   should be different dimensions.


    states = states(:,tr+tau+1:end-predictt);
    outputs = outputs(:,tr+1+predictt:end-tau);
    inputs = inputs(:,tr+1:end-predictt);
end

