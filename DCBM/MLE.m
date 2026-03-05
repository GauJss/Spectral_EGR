function [B,Q,omega,rho] = MLE(A,k,position,omega0,type)
   
% MLE estimates for entry-wise deviations and model parameters
    %
    % Inputs:
    %   A        - Adjacency matrix
    %   k        - Number of communities
    %   position - Community membership vector (1 x n)
    %   omega0   - Degree parameters (for SBM)
    %   type     - Network type: 'sbm' or 'dcbm'
    %
    % Outputs:
    %   B     - Estimated community connectivity matrix (k x k)
    %   Q     - Estimated edge probability matrix (n x n)
    %   omega - Estimated node degree parameters (1 x n)
    %   rho   - Estimated entry-wise deviations(n x k)

n=size(A,1);

% Estimate community connectivity matrix
B=zeros(k,k);
for i=1:k
pos=find(position==i);
B(i,i)=sum(sum(A(pos,pos)))/(length(pos)*(length(pos)-1));
end
for i=2:k
    for j=1:i-1
        pos1=find(position==i); pos2=find(position==j);
        B(i,j)=sum(sum(A(pos1,pos2)))/(length(pos1)*length(pos2));
    end
end
diag_B=diag(diag(B));
B=B+B';
B=B-diag_B;

% Estimate degree parameters
omega=zeros(1,n);
if strcmpi(type , 'sbm')
    omega=omega0;
elseif strcmpi(type , 'dcbm')
   for i=1:n
      di=sum(A(i,:)); 
      i1=position(i);
      pos=setdiff(find(position==i1),i);
      dj=sum(A(pos,:),2);
      omega(:,i)=di*length(pos)/sum(dj);
   end
else
    error('The case does not exit!'); 
end

% Estimate edge probability matrix
Q=zeros(n,n);
for i=1:n
   for j=1:i
        i1=position(i);
        j1=position(j);
        Q(i,j)=omega(:,i)*B(i1,j1)*omega(:,j);
   end
end

for i=1:n
    for j=1:i-1
        Q(j,i)=Q(i,j);
    end
end
Q=Q-diag(diag(Q));


% Estimate entry-wise deviations
rho=zeros(n,k);
for i=1:n
    for v=1:k
        i1=position(i);
        pos=setdiff(find(position==v),i);  
        wB=omega(:,i).*omega(:,pos).*B(i1,v);    
        rho(i,v)=sum((A(i,pos)-wB)./sqrt(wB.*(1-wB)))/sqrt(length(pos)); 
    end
end
end

