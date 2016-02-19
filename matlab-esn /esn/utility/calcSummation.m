function [ new_states ] = calcSummation( W , states )
% calcsummation is the presynaptic integration which for a regular neural
% network is just a dot product of the states and weights.

    % multiply the weights by the states of inputs and sum all of them.
    new_states = (states*W);

end

