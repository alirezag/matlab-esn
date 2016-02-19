function [ statesData ] = ...
    runTheNetworkSyncHom( numIn, numP, states0,...
                          inputs, W, prefilters,postfilters, activation, transferFunc,bias)
%UNTITLED4 Running the network using synchronous updates using homogeneous
%transfer functions. 

%   Detailed explanation goes here
if (length(inputs)~=0)
  states0 = setInput(numIn,states0,inputs(1,:));
end
  %Initialize the states history.
  statesData = zeros(size(inputs,1),numIn+numP);
  statesData(1,:) = states0;
    for ni=2:(size(inputs,1))
        sums = activation(W,states0);
        
        for f=prefilters
           if mod(ni,f{1}{2})==0
              [sums, W]=f{1}{1}(sums,W,ni,f{1}{3}{1}); 
           end
        end
        states1 = states0;
        states1(numIn+1:end) = transferFunc(sums(numIn+1:end)+bias);
        for f=postfilters
           if mod(ni,f{1}{2})==0
              [states1, W]=f{1}{1}(states1,W,ni,f{1}{3}{1}); 
           end
        end
        states0 = states1;
        

        if (length(inputs)~=0)
        states0 = setInput(numIn,states0,inputs(ni,:));
        end
        
        statesData(ni,:) = states0;
    end

end

