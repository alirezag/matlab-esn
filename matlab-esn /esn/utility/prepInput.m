function [ inputs ] = prepInput( inputs, tl )
%prepInput For the duration of transient length prepend input with zeros
%   the time seris given in inputs should goes foward in columns and the
%   rows hold different dimensions.

    inputs = [zeros(size(inputs,1),tl) inputs(:,1:end)];
    
end

