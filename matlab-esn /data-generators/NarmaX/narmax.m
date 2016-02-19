function [o] = narmax(in,t,init) 
% this will generate the narma output for input sequence in and the order
% t.
    o = ones(size(in)).*init;
    
    for ni=t+1:size(in,1)
        o(ni,:) = 0.3.*o(ni-1,:) + 0.05.*o(ni-1,:).*sum(o(ni-t:ni-1,:))+...
                1.5.*in(ni-t,:).*in(ni-1,:) + 0.1;
       
    end

end