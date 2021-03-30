function z=bin2deci(x)
% z=bin2deci(x)
% e.g. x=[ 1     1     0     1     0     0     1     0     0     0
%          1     1     0     1     1     0     0     0     1     0]'
% z = 
[A,B]=size(x);
z=zeros(A,1);
for i=1:A,
    l=length(x(i,:));
    y=(l-1:-1:0);
    y=2.^y;
    y=x(i,:)*y';
    z(i,:)=y;
end
z=z';    
end 