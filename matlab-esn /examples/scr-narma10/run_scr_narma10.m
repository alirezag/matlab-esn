addpath(genpath('../../../'))

randnum = rng('shuffle');

inputw = [.1];
resw = [0.8];
timeLen =2100;
N=100;
in_dim = 1;out_dim = 1;
tranLen = 100;
tau = 0; % how many time steps before the output is produced
taut = 0; % number of delay taps in the output (for memory tasks)
predict = 0;
timeLen = timeLen + 2*taut;
inifunc = @makeZeroState;

% setup the simulator: integrator, transfer function, bias
simulatorfunc = setupSimulator({@calcSummation;@transferTanh;0}); 

% Setup trainer and tester: trainsient, tau, predict,
trainerfunc = setupTrainer(tranLen, tau, predict);
testerfunc  = setupTester(tranLen, tau, predict);
trainerfuncmultitau = {};
testerfuncmultitau = {};

% setup filters
prefilters     = {}; 
postfilters     = {};

% setup connections: input weight coefficient, and spectral radius
connfunc = setupConnRodanSCR([ inputw, resw]); 

% setup observed states
obsstatidx = [1+in_dim:N+in_dim];

% initialize the ESN object and the connections
net = ESN(N,in_dim,out_dim,connfunc,simulatorfunc,obsstatidx,...
                trainerfunc,trainerfuncmultitau,testerfunc,testerfuncmultitau,prefilters,postfilters,inifunc);
net = net.initConn();       


% generate narma 10 data
inputs.data = rand(2*timeLen,1)*0.5;
while isinf(mean(narmax(inputs.data,10,0)))
    inputs.data = rand(2*timeLen,1)*0.5;
end  

%initialize input stream
input = inputs.data(1:timeLen,1);
input = prepInput(input',tranLen)';
% initialize network states
net = net.initState();
net = net.resetStates();
net = net.resetResults();
% run the network
net = net.simulate(input);  
% train the network
net = net.train(narmax(input,10,0));


% initalize input stream
input = inputs.data(timeLen+1:2*timeLen,1);
input = prepInput(input',tranLen)';
% initialize network states
net = net.initState();
net = net.resetStates();
net = net.resetResults();   
% run the network
net = net.simulate(input);  
% test the network
net = net.test(narmax(input,10,0));

% calculate error from offset 200
[ e, MSE, NMSE, RNMSE, NRMSE, SAMP ] = net.getErr(200);
NMSE
%% visualize

visLen = 200;
offset = 100;
timeidx = [1:visLen]+offset;

px = 2; py=3;
subplot(py,px,1)        
plot(net.results{3}(timeidx,:))
title('input')
subplot(py,px,2) 
plot([net.results{1}(timeidx,:) net.results{2}(timeidx,:)])
title('output'); legend('output','target');
subplot(py,px,3:4);
plot(e(timeidx).^2);
title('squared-error');
subplot(py,px,5)
plot(net.netstates(timeidx,:));
title('raw net states');
subplot(py,px,6)
plot(net.results{4}(:,timeidx)');
title('observed states')
