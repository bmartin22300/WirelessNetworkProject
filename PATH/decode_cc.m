function m = decode_cc(r,cc)
    mLong = VAharddecode1(r, cc.StateTable, cc.M, cc.k , cc.n);
    m = mLong(1:cc.nbBits);
end


function [m_est,c_bin_est,CumulatedMetric ]=VAharddecode1(r, StateTable, M, k , n)

% [m_est]=VAharddecode1(c_bin, StateTable, M, k, n, type)
% Hard Decision Viterbi Decoder
%
% Inputs
% ======
% c_bin: binary sequence to be coded
% StateTable: State Table of the Convolutional code
% M: No of memory elements for each of the k input bits
% k: No of input bits per time step
% n: Number of output bits per time step
% type: either 'hard' or 'soft' for hard/soft decision decoding
% Output
% ======
% m_est: Estimated Binary (Input) Sequence
% c_bin_est: Estimated binary coded sequence
% CumulatedMetric: Total MEtric of c_bin_est

% (c)Dr Boris Gremont, 2007

 
    


%===============================================================
% Hard/Soft Decision VA
%===============================================================
[NoOfTransitionsPerTimeStep,B]=size(StateTable);
NoOfStates=2.^(sum(M));
NoOfPathsConvergingToANode=NoOfTransitionsPerTimeStep./NoOfStates;
NoOfTimeSteps=length(r)./n;


StateMetrics=Inf.*ones(NoOfStates,NoOfTimeSteps);
Survivors=Inf.*ones(NoOfStates,NoOfTimeSteps+1);
InitialState=0; % Initial Starting State
t=0;
Survivors(InitialState+1,t+1)=InitialState;


x=[];
for t=1:NoOfTimeSteps, % t=0 for initial start
    OldSurvivors=Survivors;
    for CurrentState=0:NoOfStates-1,
        IdxPreviousStates=find(StateTable(:,3)==CurrentState); % get Row No of possible previous states
        PreviousStates=StateTable(IdxPreviousStates,2);
        for count1=1:length(IdxPreviousStates),
            x=r((t-1).*n+1:(t.*n)); % get received n bits data for previous time step
            y=deci2bin(StateTable(IdxPreviousStates(count1),4),n);% get output bits for the relevant branch
            Distance=sum(rem(x+y,2));  % Compute Hamming distance
            
            if t==1 & PreviousStates(count1)==InitialState
                NewPathMetricValue=0+Distance;
            elseif t==1 & PreviousStates(count1)~=InitialState
                NewPathMetricValue=Inf;
            elseif t>1
                NewPathMetricValue=StateMetrics(PreviousStates(count1)+1,t-1)+Distance;
            end
            if NewPathMetricValue<StateMetrics(CurrentState+1,t);
                StateMetrics(CurrentState+1,t)=NewPathMetricValue;
                if t==1 & PreviousStates(count1)==InitialState,
                    Survivors(CurrentState+1,1:t+1)=[OldSurvivors(PreviousStates(count1)+1,1) CurrentState];
                    %disp(['Previous State=' num2str(PreviousStates(count1)) ' Next State=' num2str(CurrentState)])
                    %Survivors
                    %disp(['t=' num2str(t) '  Press Key'])
                    %pause
                elseif t>1
                    Survivors(CurrentState+1,1:t+1)=[OldSurvivors(PreviousStates(count1)+1,1:t) CurrentState];
                    %disp(['Previous State=' num2str(PreviousStates(count1)) ' Next State=' num2str(CurrentState)])
                    %Survivors
                    %disp(['t=' num2str(t) '  Press Key'])
                    %pause
                end
            end
        end
    end
end
% StateMetrics
% Survivors        
%===============================
% start decoding from Survivors
%===============================
% we know the last valid state must be zero since we have flushed the
% encoder with trailing zeros
Survivor=Survivors(1,:);
CumulatedMetric=StateMetrics(1,end);
c_bin_est=[];
m_est=[];
for t=1:length(Survivor)-1,
    CurrentState=Survivor(t);
    NextState=Survivor(t+1);
    Idx=find(StateTable(:,2)==CurrentState & StateTable(:,3)==NextState);
    
    c_bin_est=[c_bin_est deci2bin(StateTable(Idx,4),n)];
    
    m_est=[m_est deci2bin(StateTable(Idx,1),k)];
end
end


