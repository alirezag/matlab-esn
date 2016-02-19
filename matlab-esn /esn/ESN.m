classdef ESN
% the main ESN class    
    properties
        N            = 0;
        numIn        = 0;
        numOut       = 0;
        W            = [];
        states0      = [];
        netstates    = [];
        obsstatidx   = [];
        results      = {};
        targets      = [];
        inputs       = [];
        outW         = [];
        connector    = [];
        simulator    = [];
        prefilters      = [];
        postfilters
        trainer      = [];
        trainer_multitau = [];
        tester_multitau  = [];
        trainer_analytic_multitau = [];
        tester_analytic_multitau  = [];
        tester       = [];
        initializer  = [];
        memcurv      = [];
        totalMem     = []; % this should be in theory the sum of memcurv
    end % properties
    methods
        function [net] = ESN(N, numIn, numOut, connector,...
                                simulator,obsstatidx, trainer,...
                                trainer_multitau, tester,...
                                tester_multitau ,prefilters,postfilters,...
                                initializer)
     
            net.N            = N;
            net.numIn        = numIn;
            net.numOut       = numOut;          
            net.connector    = connector;
            net.simulator    = simulator;
            net.prefilters   = prefilters;  % pre activation func filter
            net.postfilters  = postfilters; %post activation func filter
            net.trainer      = trainer;
            net.trainer_multitau = trainer_multitau;
            net.tester_multitau = tester_multitau;
            net.tester       = tester;
            net.initializer  = initializer;
            net.obsstatidx   = obsstatidx;
        end
        function W = getW(net)
           W = net.W(net.numIn+1:end,net.numIn+1:end);

        end
        function v = getv(net)
            v = net.W(1:net.numIn, net.numIn+1:end)'; 
        end
        function net = resetStates(net)
            net.netstates    = [];
            
        end
        function net = resetResults(net)
            net.results    = {};
            
        end
        function net = initState (net)
          net.states0 = zeros(1,net.numIn + net.N);
          net.states0(net.numIn+1:end) = net.initializer(net.N);
        end
    
        function net = initConn(net)
          net.W = net.connector(net.N,net.numIn);
          
        end

        function net =  simulate(net,inputs)
            net.inputs = inputs;
            net.netstates = [net.netstates; ...
                    net.simulator(net.numIn,net.N,...
                    net.states0,inputs,net.W,net.prefilters,net.postfilters)];
        end
   
        function [net]  = train(net,outputs)
            net.targets = outputs;           
            [ roW , y , OutAll, inputs , statesOut] = ....
                net.trainer(net.inputs,net.netstates(:,net.obsstatidx),net.targets);
            net.outW = roW; %protocol the first output should be the weights
            net.resetResults();
            net.results = {y,OutAll,inputs,statesOut};
        end
        function [net]  = train_multitau(net,outputs)
            net.targets = outputs;           
            [ roW , y , OutAll, inputs , statesOut] = ....
                net.trainer_multitau(net.inputs,net.netstates(:,net.obsstatidx),net.targets);
            net.outW = roW; %protocol the first output should be the weights
            net.resetResults();
            net.results = {y,OutAll,inputs,statesOut};
        end
        function [net]  = train_analytic_multitau(net,outputs)
            net.targets = outputs;           
            [ roW , y , OutAll, inputs , statesOut, memc,totalmc] = ....
                net.trainer_analytic_multitau(net,net.inputs,net.netstates(:,net.obsstatidx),net.targets);
            net.outW = roW; %protocol the first output should be the weights
            net.resetResults();
            net.memcurv = memc;
            net.totalMem = totalmc;
            net.results = {y,OutAll,inputs,statesOut};
        end        
        function [net]  = test(net,outputs)
            net.targets = outputs;           
            [  y , OutAll, inputs , statesOut] = ....
                net.tester(net.inputs,net.netstates(:,net.obsstatidx),net.targets,net.outW);
            net.resetResults();
            net.results = {y,OutAll,inputs,statesOut};
        end
        function [net]  = test_multitau(net,outputs)
            net.targets = outputs;           
            [  y , OutAll, inputs , statesOut] = ....
                net.tester_multitau(net.inputs,net.netstates(:,net.obsstatidx),net.targets,net.outW);
            net.resetResults();
            net.results = {y,OutAll,inputs,statesOut};
        end
        function [net]  = test_analytic_multitau(net,outputs)
            net.targets = outputs;           
            [  y , OutAll, inputs , statesOut] = ....
                net.tester_analytic_multitau(net.inputs,net.netstates(:,net.obsstatidx),net.targets,net.outW);
            net.resetResults();
            net.results = {y,OutAll,inputs,statesOut};
        end        
        function [ e, MSE, NMSE, RNMSE, NRMSE, SAMP ] = ...
                getErr(net,skip)
            [ e, MSE, NMSE, RNMSE, NRMSE, SAMP ] =...
                calcErr(net.results{1}(skip:end,:),net.results{2}(skip:end,:));
        end
    end % methods

end