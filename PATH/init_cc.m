function cc = init_cc(r,nbBits)
    Gpoly = [133 171];
% --- Call the stack parameters 
[K, M, nu, n, k, coderate, StateTable]=getcodeparameters(Gpoly);

% --- Create structure 
cc.K = K;
cc.M = M;
cc.nu = nu;
cc.n = n;
cc.k = k;
cc.codeRate = coderate;
cc.StateTable = StateTable;
nbBitsCoded = 2*nbBits + 2*(nu + 2); 
cc.nbBits = nbBits;
cc.nbBitsCoded = nbBitsCoded;
end

% ----
function [K, M, nu, n, k, coderate, StateTableDecimal]=getcodeparameters(Gpoly)
% [K, M, nu, n, k, coderate, StateTable]=getcodeparameters(Gpoly,)
%    for hard decision decoding
%
% Gpoly : matrix containing code generator polynomials in octal format
%
% K constraint length of the code
% M maximum No of shift register (per input bits)
% k number of bits in into encoder
% n number of bits out of encoder
% coderate=k/n
% StateTable  State Table of code (decimal format)
% State is composed of the following
% 1st columm: input bits
% 2nd column: current state
% 3rd column: next state
% 4th column: output bits

% (c) Dr Boris Gremont,2007


%===============================================================
% Find code rate and constraint length K of code
% constraint length refers to the maximum number of input bits
% that can affect the output of the encoder
%===============================================================
[k,n]=size(Gpoly);  % k No of bits in
% n No of bits out
coderate=k./n;
Gmax=Gpoly(Gpoly==max(max(Gpoly)));
NoBits=length(oct2poly(Gmax(1)));
K=zeros(k,1);
for i=1:k, % for each row of Gpoly
    firstbit=999;
    lastbit=0;
    for j=1:n %for each colum of Gpoly
        if Gpoly(i,j)~=0,
            binval=oct2poly(Gpoly(i,j));
        else
            binval=zeros(1,NoBits);
        end
        I=find(binval==1);
        if isempty(I)==0, % if non-zero
            bitstart=I(1);
            if bitstart<firstbit,
                firstbit=bitstart;
            end
            bitstop=I(end);
            if bitstop>lastbit,
                lastbit=bitstop;
            end
        end
    end
    K(i)=lastbit-firstbit+1;
end
% Max No of input shift registers needed for each input bit
M=K-1;

%===============================================================
% Build the trellis for this code
%===============================================================
NoOfStates=2.^(sum(M));
NoOfBitsPerState=log2(NoOfStates);
NoInputSymbols=2.^k;
NoOfOutputSymbols=2.^n;
nu=max(M);

% Note:
% first k bits are input bits
% next NoOfBitsPerState are state bits
% StateTable has NoOfStates.*NoInputSymbols entries
NoOfEntriesInStateTable=NoOfStates.*NoInputSymbols;

StateTable=[];
BitInputs=[];


startcols=cumsum(M)-M+1;
endcols=cumsum(M);
% endcolumns-startcolumns+1 %must be equal to M

for i=0:NoOfEntriesInStateTable-1,
    InputBits=deci2bin(i,log2(NoOfEntriesInStateTable));
    CurrentStates=InputBits(k+1:end);
    NextStates=zeros(1,sum(M));
    for j=1:length(M),
        StateSize=M(j);
        NextStates(startcols(j):endcols(j))=[InputBits(j) CurrentStates(startcols(j):endcols(j)-1)];
    end
    StateTable=[StateTable; InputBits NextStates];
end
% StateTable % uncomment to see state table in binary format

% Transform State Table into decimal format
[A,B]=size(StateTable);
StateTableDecimal=zeros(A,1+(B-k)./NoOfBitsPerState);
for i=1:A,
    StateTableDecimal(i,1)=bin2deci(StateTable(i,1:k));
end
for i=1:A,
    for j=1:(B-k)./NoOfBitsPerState,
        StateTableDecimal(i,j+1)= bin2deci(StateTable(i,k+1+(j-1).*sum(M):k+j.*sum(M)));
    end
end
names=['bits CurrentState NextState'];
%StateTableDecimal;

% Get the outputs codebits in binary format
% The following is for hard decision
c=zeros(A,n); % codebits
for i=1:A, % for each row in state table
    for i1=1:n,
        y=0;
        for j=1:k, % for eachinput bit
            x=[StateTable(i,j) StateTable(i,(startcols(j):endcols(j))+k)]; % get input bits
            %get polynomial
            g=oct2poly(Gpoly(j,i1)); % to to be replaced by n in a for 1:n inner loop
            g=g(1:1+M(j));
            y=rem(y+rem(sum(x.*g),2),2);
        end
        c(i,i1)=y;
    end
end

%outputs codebits in decimal format
c_deci=zeros(A,1);
for i=1:A,
    c_deci(i)=bin2deci(c(i,:));
end
StateTableDecimal=[StateTableDecimal c_deci];

% display code information
%clc
% disp('Information for this code')
% disp('==========================')
% disp([ 'k = ' num2str(k) ' input bits'])
% disp(['n = ' num2str(n) ' output bits'])
% disp(['code rate = ' num2str(coderate)])
% disp(['Total Number of Memory Elements M = ' num2str(sum(M))]);
% disp(['Total Number of States : ' num2str(2.^(sum(M)))]);
% disp(['Constraint Length nu : ' num2str(nu)]);
% disp('==========================')
end

