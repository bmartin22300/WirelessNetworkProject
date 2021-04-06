load('tfMatrix.mat');
tfMatrix_short = tfMatrix([(2:301),(725:end)],(1:14));
qamMatrix = tfMatrix_short(:,3:end);


function bitSeq = BPSK_demod(qamSeq)
    bitSeq = zeros (rows(qamSeq),columns(qamSeq), "uint8")
    for i = 1:rows(qamSeq)
      for j = 1:columns(qamSeq)
        if real(qamSeq(i,j)) < 0  
          bitSeq(i,j) = 0;
        else
          bitSeq(i,j) = 1;
        endif
      endfor
  endfor
endfunction

addpath('UnitaryTests');
#check_BPSK;

bitSeq = BPSK_demod(qamMatrix);
#contourf(abs(bitSeq));
#xlabel('Symbol Index');
#ylabel('Subcarrier(Hz)');
#title('t/f Matrix');

cellusers = bitSeq((1:48),1);

function bitDec = hamming748_decode(cellusers);
  bitDec=[];
  i=8
  g=1  
  e=[0;0;0];
  H =[1,1,1,0,1,0,0 ;1,1,0,1,0,1,0 ;1,0,1,1,0,0,1] ;
  while i<rows(cellusers)+1
    cellcalc = cellusers((g:i),1);
    e=mod(double(H)*double(cellcalc(1:7,1)),2);
    if e == [0;0;1]
      cellcalc(1)= mod(cellcalc(1)+1,2);
    endif
    if e == [0;1;0]
      cellcalc(2)= mod(cellcalc(2)+1,2);      
    endif
    if e == [0;1;1]      
      cellcalc(3)= mod(cellcalc(3)+1,2);
    endif
    if e == [1;0;0]
      cellcalc(4)= mod(cellcalc(4)+1,2);      
    endif
    if e ==[1;0;1]
      sum=0;
      for c=1:rows(cellcalc)-1  
          disp(cellcalc(c));
        sum += mod(cellcalc(c),2);
      endfor
      if sum != cellcalc(8)
        display("Erreur - > Retransmission du message");
      endif
    endif
    if e == [1;1;0]
      sum=0;
      for c=1:rows(cellcalc)-1 
          disp(cellcalc(c));
        sum += mod(cellcalc(c),2);
      endfor
      if sum != cellcalc(8)
        display("Erreur - > Retransmission du message");
      endif
    endif
    if e == [1;1;1]
      sum=0;
      for c=1:rows(cellcalc)-1  
          disp(cellcalc(c));
        sum += mod(cellcalc(c),2);
      endfor
      if sum != cellcalc(8)
        display("Erreur - > Retransmission du message");
      endif
    endif
    disp(cellcalc((1:4),1));
    bitDec = [bitDec;cellcalc((1:4),1)];
    i=i+8;
    g=g+8;
  endwhile
endfunction
bitDec = hamming748_decode(cellusers);
check_Hamming748();