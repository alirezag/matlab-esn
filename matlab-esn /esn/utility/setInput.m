function [ states ] = setInput( numIn, states, input )
%UNTITLED2 Set the input pattern on input nodes.
%   Detailed explanation goes here

states(1:numIn) = input;
end

