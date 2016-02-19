function [mc net] = doMC(net,inputs,tranLen,timeLen,tau,taut)

input = inputs.data(1:timeLen,1);
        input = prepInput(input',tranLen)';
        net = net.initState();
        net = net.resetStates();
        net = net.resetResults();        
        net = net.simulate(input);   
        outputs = makeDelayedData(input,taut);%legPoly(makeDelayedData(input,taut),lpi)+yshift;
        outputs = [ zeros(taut,taut+1); outputs];
        net = net.train_multitau(outputs);

        
        input = inputs.data(timeLen+1:2*timeLen,1);
        input = prepInput(input',tranLen)';
        net = net.initState();
        net = net.resetStates();
        net = net.resetResults();        
        net = net.simulate(input);  
        outputs = makeDelayedData(input,taut); %legPoly(makeDelayedData(input,taut),lpi)+yshift;
        outputs = [ zeros(taut,taut+1); outputs];
        net = net.test_multitau(outputs);

        MC = corr(net.results{1},net.results{2}).^2;
        MC=diag(MC)';
        mc = MC(length(MC)-1:-1:1);
        
end