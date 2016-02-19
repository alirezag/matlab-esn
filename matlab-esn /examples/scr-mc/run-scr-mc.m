addpath ../../../QESN/Library3
addpath ../../../QESN/Library3/utility
addpath ../../../QESN/Library3/training
addpath ../../../QESN/Library3/time_evolution
addpath ../../../QESN/Library3/res_trans_func
addpath ../../../QESN/Library3/res_conn
addpath ../../../QESN/Library3/quantization
addpath ../../../QESN/Library3/calc_err
addpath ../../../QESN/Library3/filters
addpath ../../Library/delayline/
addpath ../../Library/NarmaX
addpath ../20may2014

randnum = rng('shuffle');

inputwL = [0.0001 0.00025:0.00025:0.001 0.0025:0.0025:0.01 0.025:0.025:0.1 0.2:0.1:.30];
reswL = [0.9];
gammaL = [0.005];
timeLen =2100;
numexp = 20;


N=50;
tranLen = 100;
damL = [0];
%damStdevL = [.01:0.01:0.1 0.2:0.05:.5 0.6 1];
damStdevL = [0.01];
tau = 100;
taut =100; 
timeLen = timeLen + 2*taut;

%% Here prepare the transfer functions
TFs = {};
for ni=1:2:49
    TFs{end+1} = transferTanhTaylor(ni);
end
TFs{end+1} = @transferTanh;

inifunc = @makeZeroState;
simulatorfunc = {};
trainerfunc = setupTrainer(tranLen, tau, 304);
testerfunc  = setupTester(tranLen, tau, 304);
     
% trainsient tau predict


trainerfuncmultitau = setupTrainer_multitau(tranLen, tau, 0);
testerfuncmultitau = setupTester_multitau(tranLen, tau, 0);

lpi = [3];
xshift = - 0.5;
coeff = 1;
yshift = 0;

mc = zeros(length(inputwL),length(reswL),length(TFs),numexp,tau);
tmc = zeros(length(inputwL),length(reswL),length(TFs),numexp,tau);


filters     = {}; 

for ini=1:length(inputwL)
    for ni=1:numexp
inputw=inputwL(ini);
resw=reswL(1);
gamma=gammaL(1);

    inputs.data = rand(1,2*timeLen)'*coeff + xshift ;
    
    connfunc = setupConnRodanSCR([ inputw, resw]); 
    %connfunc = setupConnESNFullSpectral([ inputw, resw]); 
   
        obsstatidx = [2:N+1];
        net = ESN(N,1,1,connfunc,simulatorfunc,obsstatidx,...
                        trainerfunc,trainerfuncmultitau,testerfunc,testerfuncmultitau,filters,inifunc);
        net = net.initConn();       
        
        for fi=1:length(TFs)
        ['ini:' num2str(inputw) '; r:' num2str(resw) '; exp:' num2str(ni) ...
            '; fi:' num2str(fi)]    
        simulatorfunc = setupSimulator({@calcSummation;TFs{fi}}); 
        net.simulator = simulatorfunc;
  
        [mymc , net] =  doMC(net,inputs,tranLen,timeLen,tau,taut);
        %[mc , net] =  doNMC(net,tranLen,timeLen,tau,taut,lpi);
        mc(ini,1,fi,ni,:) = mymc;
        end


    end
end

save('taylortanh_SCR_MC.mat','N','tau','taut','tranLen',...
    'timeLen','mc','inputwL','TFs','reswL','numexp');