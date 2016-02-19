function [ funcobj ] = setupConnRodanSCR( vararg )
%SETUPCONNRODANSCR This function knows how to setup connections for the
%Rodan SCR according Rodan 2011 IEEE Transactions on NN. 
% This will be a simple size reservoir with homogeneous weights and
% homogeneous input weihts with randomly assigned signs. 
%
% the elements of vararg:
% 1: input coefficient
% 2: reservoir weights

    function [W, sr] = implementation(numP,numIn)
        [W, sr]= makeWeightMatrixSCRHom(numP, numIn, vararg(1),vararg(2));
    end
    funcobj = @implementation;

end

