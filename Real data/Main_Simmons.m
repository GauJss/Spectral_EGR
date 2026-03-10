%% Setup
clear;
K0=[1,2];
kmax=5;
alpha=0.05;
type='dcbm'; 

A=importdata('Simmons.txt');
n=size(A,1);

% Threshold
per_tw=TW_Lei(n,0.5*alpha,alpha,500);
twlei=per_tw(1);  
threva=zeros(length(K0),1);
parfor h=1:length(K0)
disp(h);
k0=K0(h);
threva(h)=Tracy_Percentile(n,k0,kmax,alpha,500);   
end
critical=[twlei;threva];
dlmwrite('SimmonCritical.txt',critical);


critical=importdata('SimmonCritical.txt');
twlei=critical(1);
threva=critical(2:size(critical,1));
sparse_a=zeros(1,6);

for h=1:length(K0)
disp(K0(h));
k0=K0(h);

% Eigengap Ratio
[Size_Qn,Qn]= EGR(A, kmax, k0, threva(h));

% Han et al. (2019)
m=n^(1/3);  %(1/2);
[Size_Han,Qn_Han] = Han(A,k0,m,alpha);

% Hu et al. (2021)
Boot=50;
[hatA,position]=SP_kmeans(A,k0);
% Degree Parameter
 if strcmpi(type , 'sbm')
     omega0=ones(1,n);
 elseif strcmpi(type , 'dcbm')
     for i=1:n
         di=sum(A(i,:)); 
         i1=position(i);
         pos=setdiff(find(position==i1),i);
         dj=sum(A(pos,:),2);
         omega0(:,i)=di*length(pos)/sum(dj);
     end
 else
     error('The case does not exit!'); 
 end

[hatB,hatQ,hatOmega,hatRho] = MLE(A,k0,position,omega0,type);
[Size_Hu,Qn_Hu]=Hu_Or(hatRho,n,k0,alpha);
[SizeBoot_Hu,QnBoot_Hu]=Hu_Boot(Qn_Hu,hatB,hatOmega,type,n,k0,Boot,alpha); 

% TW Lei (2016)
[Size_Lei,Qn_Lei] = Lei_Or(A,hatQ,twlei);
[SizeBoot_Lei,QnBoot_Lei] = Lei_Boot(A,k0,hatB,hatQ,hatOmega,type,Boot,twlei);

sparse_a=[sparse_a; Size_Qn, Size_Lei,SizeBoot_Lei,Size_Hu,SizeBoot_Hu,Size_Han; Qn, Qn_Lei, QnBoot_Lei, Qn_Hu, QnBoot_Hu, Qn_Han];
end
sparse_a(1,:)=[];
 

