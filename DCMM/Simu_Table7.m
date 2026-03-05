

% Network Setup
density = 'sparse';  % Density type ('dense' or 'sparse')
k = 5;              % Number of communities
K0 = [3, 5];        % Tested number of communities
n = 3000;           % Number of nodes
kmax = 24;          % Maximum number of communities to test
alpha = 0.05;       % Significance level
loop = 500;         % Number of simulations

% Initialize matrices to store results
Size_Qn=zeros(loop,length(K0));Qn=zeros(loop,length(K0));
Size_Han=zeros(loop,length(K0));Qn_Han=zeros(loop,length(K0)); 

for h=1:length(K0)
disp(h);
k0=K0(h);

% Set sparsity and probability values based on the network density type
if strcmpi(density , 'dense')
    sparsity=1;
elseif strcmpi(density , 'sparse')
    sparsity=0.5*n^(-2/9);
else
    error('The case does not exit!');
end


if strcmpi(density , 'dense')
    p_in=0.5; p_off=0.1; 
elseif strcmpi(density , 'sparse')
    p_in=0.5*n^(-2/9); p_off=0.1*n^(-2/9);
else
    error('The case does not exit!'); 
end
B0=p_in*eye(k)+p_off*(ones(k)-eye(k));


% Parallel loop over simulations
parfor c=1:loop
disp(c);

% Define parameters for generating DCMM
x=0.2; npi=(1/k-0.03)*n; rho=0.1;  GenHanB='Han'; 
[A,P]=GenHanDCMM(n,npi,k,B0,rho,sparsity,x,GenHanB);  

% Threshold Calculation
[threva,Asynull]=Tracy_Percentile(n,k0,kmax,alpha,1000);   

% Eigengap Ratio
[Size_Qn(c,h),Qn(c,h)]= EGR(A, kmax, k0, threva);

% Han et al. (2023) Method
m=n^(1/3);  
[Size_Han(c,h),Qn_Han(c,h)] = Han(A,k0,m,alpha);

end
end

% Outputs
a=[sum(Size_Qn,1)/loop,sum(Size_Han,1)/loop];




