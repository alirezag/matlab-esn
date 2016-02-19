function [ W,sr ] = makeWeightMatrixSCRHom(numP, numIn, inputcoeff,r)
%makeWeightMatrixSCRHom Implement the weight matrix for simple cycle reservoir with
%homogeneous input weight and reservoir weight
% the input weighs are -1 and +1 from Bernouli distribution and multiplied
% by the coefficient.
% numP: reservior size
% numIn: number of inputs
% inputcoeff: input coefficient
% r: spectral radius of the reservoir weight matrix.

  

        Wres = zeros(numP,numP);
        for ni=1:numP-1
            Wres(ni+1,ni) = r;
        end
        Wres(1,numP) = r;
        Win = (randi(2,numP,numIn).*2-3).*inputcoeff;
        W= [ Win Wres ];
        W = [zeros(numIn,numP + numIn) ; W]';
        sr = max(max(abs(real(eig(Wres)))));
    

end

