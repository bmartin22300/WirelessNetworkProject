% --- bitMapping.m
% ---
% Description
%   Convert binary sequence into xQAM symbols
%	Gray code is applied
% ---
% Syntax
%			  (qamSeq)	= bitMapping(bitSeq,bPS);
%						% --- Input parameters
%							  bitSeq	: binary Sequence of size (1,bPs x N)
%							  bPS		: Bit per symbols
%						% --- Output parameters
%							  qamSeq	: Mapped QAM sequence (1,N)
% ---
% v 1.0 - Robin Gerzaguet.

function qamMat = bitMapping(bitSeq,M)
scalingFactor	= sqrt(2/3*(M-1));
switch M
    case 1
        % --- BPSK
        qamMat =  (bitSeq*2-1);
    case 2
        % --- QPSK
        qamMat = zeros(1,length(bitSeq)/2);
        alphabet  = [-1 1];
        for i = 1 : 1 : length(bitSeq)/2
            %% Binary to Symbol conversion
            % Conversion from 2 bit to one symbol (I path):
            classI	  = bitSeq(2*(i-1)+1);
            % Conversion from 2 bit to one symbol (Q path)
            classQ	  = bitSeq(2*(i-1)+2);
            %% Gray encoding
            outI  = alphabet(1+classI);
            outQ  = alphabet(1+classQ);
            % Setting output
            qamMat(i) = (outI + 1i*outQ)/scalingFactor;
        end
    case 4
        % --- 16-QAM
        % 16-QAM mapping
        % Odd bit are in I; Even bits are in Q = (I1 Q1 I2 Q2 ...)
        % I1 :> MSB || I2:> LSB
        % -------------------------%
        %   |      |     |     |
        %  10     11    01    00
        %  -3     -1     1     3
        % 0 -> 3
        % 1 -> 1
        % 2 -> -3
        % 3 -> -1
        nbSymb	  = (length(bitSeq)/4);
        qamMat = zeros(1,length(bitSeq)/4);
        alphabet  = [3 1 -3 -1];
        for i = 1 : 1 : nbSymb
            %% Binary to Symbol conversion
            % Conversion from 2 bit to one symbol (I path): {0,1,2,3}
            classI	  = 2*bitSeq(4*(i-1)+1) + bitSeq(4*(i-1)+3);
            % Conversion from 2 bit to one symbol (Q path)
            classQ	  = 2*bitSeq(4*(i-1)+2) + bitSeq(4*(i-1)+4);
            %% Gray encoding
            outI  = alphabet(1+classI);
            outQ  = alphabet(1+classQ);
            % Setting output
            qamMat(i) = (outI + 1i*outQ)/scalingFactor;
        end
    case 6
        % 64-QAM mapping
        % Odd bit are in I; Even bits are in Q = (I1 Q1 I2 Q2  I3 Q3 ...)
        % I1 :> MSB || I4:> LSB
        % ------------------------------------------------%
        %   |      |     |     |     |     |      |      |
        %  100    101   111   110   010   011    001    000
        %   -7     -5    -3    -1    +1    +3     +5     +7
        % 0 -> 000 -> +7
        % 1 -> 001 -> +5
        % 2 -> 010 -> +1
        % 3 -> 011 -> +3
        % 4 -> 100 -> -7
        % 5 -> 101 -> -5
        % 6 -> 110 -> -1
        % 7 -> 111 -> -3
        %nbSymb	  = (length(bitSeq)/6);
        %qamMat	  = zeros(Complex{Float64},nbSymb);
        nbSymb	  = (length(bitSeq)/6);
        qamMat = zeros(1,length(bitSeq)/6);
        alphabet  = [7 5 1 3 -7 -5 -1 -3];
        for i = 1 : 1 : nbSymb
            %% Binary to Symbol conversion
            % Conversion from 2 bit to one symbol (I path): {0,1,2,3}
            classI	  = 4*bitSeq(6*(i-1)+1) + 2*bitSeq(6*(i-1)+3) + bitSeq(6*(i-1)+5);
            % Conversion from 2 bit to one symbol (Q path)
            classQ	  = 4*bitSeq(6*(i-1)+2) + 2*bitSeq(6*(i-1)+4) + bitSeq(6*(i-1)+6);
            %% Gray encoding
            outI  = alphabet(1+classI);
            outQ  = alphabet(1+classQ);
            % Setting output
            qamMat(i) = (outI + 1i*outQ)/scalingFactor;
        end
    case 8
        % 256-QAM mapping
        % Inherited from 64-QAM with classic tree genereation
        % -> (0 Sequence(1:end)) (1 Sequence(end:-1:1))
        % Odd bit are in I; Even bits are in Q = (I1 Q1 I2 Q2  I3 Q3 I4 Q4...)
        % I1 :> MSB || I4:> LSB
        % ------------------------------------------------%
        %	   |       |         |        |        |        |        |        |
        %	0100    0101 .    0111 .   0110 .   0010 .   0011 .   0001 .   0000
        %	 -15     -13 .     -11 .     -9 .     -7 .     -5 .     -3 .     -1
        %	   |       |         |        |        |        |        |        |
        %   1000 .   1001 .   1011 .   1010 .   1110 .   1111 .   1101 .   1100
        %     +1 .     +3 .     +5 .     +7 .     +9 .    +11 .    +13      +15.
        % 0 ->  0000 -> -1
        % 1 ->  0001 -> -3
        % 2 ->  0010 -> -7
        % 3 ->  0011 -> -5
        % 4 ->  0100 -> -15
        % 5 ->  0101 -> -13
        % 6 ->  0110 -> -9
        % 7 ->  0111 -> -11
        % 8 ->  1000 -> +1
        % 9 ->  1001 -> +3
        % 10 -> 1010 -> +7
        % 11 -> 1011 -> +5
        % 12 -> 1100 -> +15
        % 13 -> 1101 -> +13
        % 14 -> 1110 -> +9
        % 15 -> 1111 -> +11
        %nbSymb	  = (length(bitSeq)/8);	%
        %qamMat	  = zeros(Complex{Float64},nbSymb);
        nbSymb	  = (length(bitSeq)/8);
        qamMat = zeros(1,length(bitSeq)/8);
        alphabet  = [-1 -3 -7 -5 -15 -13 -9 -11 +1 +3 +7 +5 +15 +13 +9 +11];
        for i = 1 : 1 : nbSymb
            %% Binary to Symbol conversion
            % Conversion from 2 bit to one symbol (I path): {0,1,2,3}
            classI	  = 8*bitSeq(8*(i-1)+1) + 4*bitSeq(8*(i-1)+3) + 2*bitSeq(8*(i-1)+5) + bitSeq(8*(i-1)+7);
            % Conversion from 2 bit to one symbol (Q path)
            classQ	  = 8*bitSeq(8*(i-1)+2) + 4*bitSeq(8*(i-1)+4) + 2*bitSeq(8*(i-1)+6) + bitSeq(8*(i-1)+8);
            %% Gray encoding
            outI  = alphabet(1+classI);
            outQ  = alphabet(1+classQ);
            % Setting output
            qamMat(i) = (outI + 1i*outQ)/scalingFactor;
        end
end
