

%% Network setup
type = 'sbm';               % Network model type ('sbm' or 'dcbm')
n = 3000;                   % Number of nodes
k = 5;                      % True number of communities
K0 = [3, 5];                % Hypothetical number of communities
kmax = 24;                 
alpha = 0.05;               % Significance level
loop = 500;                 % Number of realizations

%% Initialize arrays to store results.
Size_Qn=zeros(loop,length(K0));Qn=zeros(loop,length(K0));
Size_Lei=zeros(loop,length(K0));SizeBoot_Lei=zeros(loop,length(K0));Qn_Lei=zeros(loop,length(K0));QnBoot_Lei=zeros(loop,length(K0));
Size_Hu=zeros(loop,length(K0));SizeBoot_Hu=zeros(loop,length(K0));SizeAugBoot_Hu=zeros(loop,length(K0));
Qn_Hu=zeros(loop,length(K0));QnBoot_Hu=zeros(loop,length(K0));QnAugBoot_Hu=zeros(loop,length(K0));
Size_Han=zeros(loop,length(K0));Qn_Han=zeros(loop,length(K0));
LHu=zeros(loop,length(K0)); LLei=zeros(loop,length(K0));

for h=1:length(K0)
disp(h);
k0=K0(h); 
kk=kmax-k0+2;

% Community connection probabilities
p_in=0.5*n^(-2/9); p_off=0.1*n^(-2/9);
In_p=repelem(p_in,k);In_p=diag(In_p);
Out_p=repelem(p_off,k^2);Out_p=reshape(Out_p,k,k);Out_p=Out_p-diag(diag(Out_p));
B0=In_p+Out_p;

% Generate degree parameters
if strcmpi(type , 'sbm')
    omega0=ones(1,n);
elseif strcmpi(type , 'dcbm')
    o1=unifrnd(4/5,6/5);o2=[9/11 13/11];
    o=[o1 o2];
    prob=[0.8 0.1 0.1];
    i=1; j=1:n; v = randsrc(n,1,[o; prob]);
    omega0= sparse(i,j,v,1,n);
else
    error('The case does not exit!'); 
end

% Critical values of our method and Lei (2016)
per_tw=TW_Lei(n,0.5*alpha,alpha,1000);
twlei=per_tw(1);  
threva=Tracy_Percentile(n,k0,kmax,alpha,1000);   

%% Main loop for various methods
parfor c=1:loop
disp(c);
A=Generating(n,k,B0,omega0); %GenDCBM(n,k0,B0,omega0);

% Eigengap Ratio
[Size_Qn(c,h),Qn(c,h)]= EGR(A, kmax, k0, threva);

% Han et al. (2023)
m=n^(1/2);  %(1/3);
[Size_Han(c,h),Qn_Han(c,h)] = Han(A,k0,m,alpha);

% Hu et al. (2021)
Boot=100;
[hatA,position]=SP_kmeans(A,k0);
[hatB,hatQ,hatOmega,hatRho] = MLE(A,k0,position,omega0,type);
try
[Size_Hu(c,h),Qn_Hu(c,h)]=Hu_Or(hatRho,n,k0,alpha);
[SizeBoot_Hu(c,h),QnBoot_Hu(c,h)]=Hu_Boot(Qn_Hu(c,h),hatB,hatOmega,type,n,k0,Boot,alpha); 
[SizeAug_Hu,QnAug_Hu]=Hu_Aug(A,hatB,k0,hatOmega,type,alpha);
[SizeAugBoot_Hu(c,h),QnAugBoot_Hu(c,h)]=Hu_AugBoot(QnAug_Hu,hatOmega,type,hatB,n,k0,Boot,alpha);  
catch
    LHu(c,h)=1;
    continue
end

% Lei (2016)
try
[Size_Lei(c,h),Qn_Lei(c,h)] = Lei_Or(A,hatQ,twlei);
[SizeBoot_Lei(c,h),QnBoot_Lei(c,h)] = Lei_Boot(A,k0,hatB,hatQ,hatOmega,type,Boot,twlei);
catch
    LLei(c,h)=1;
    continue
end

end
end

%% Outputs
a=[sum(Size_Qn,1)/loop,sum(Size_Lei,1)./(loop-sum(LLei,1)),sum(SizeBoot_Lei,1)./(loop-sum(LLei,1))...,
    sum(Size_Hu,1)./(loop-sum(LHu,1)),sum(SizeAugBoot_Hu,1)./(loop-sum(LHu,1))...,
    sum(Size_Han,1)/loop];






