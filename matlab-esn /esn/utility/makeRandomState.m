function [ states ] = makeRandomState( N )
%makeRandomState make random vector of size N drawn from uniform
%distribuiton on [-1,1].

    % make random states from uniform distributions
    states = rand(1,N)*2-1;
end

