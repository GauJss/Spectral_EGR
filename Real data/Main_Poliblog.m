%% Setup
clear;
K0=[1,2];
kmax=5;
alpha=0.05;

A=importdata('PoliticalBlog.xlsx'); 

n=size(A,1);
sparse_a=zeros(1,3);
for h=1:length(K0)
disp(h);
k0=K0(h);

threva=Tracy_Percentile(n,k0,kmax,alpha,1000);   
[Size_Qn,Qn]= EGR(A, kmax, k0, threva);
sparse_a=[sparse_a;Size_Qn,Qn,threva];
end
sparse_a(1,:)=[];




