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
        sum += mod(cellcalc(c),2);
      endfor
      if sum != cellcalc(8)
        display("Erreur - > Retransmission du message");
      endif
    endif
    if e == [1;1;0]
      sum=0;
      for c=1:rows(cellcalc)-1 
        sum += mod(cellcalc(c),2);
      endfor
      if sum != cellcalc(8)
        display("Erreur - > Retransmission du message");
      endif
    endif
    if e == [1;1;1]
      sum=0;
      for c=1:rows(cellcalc)-1  
        sum += mod(cellcalc(c),2);
      endfor
      if sum != cellcalc(8)
        display("Erreur - > Retransmission du message");
      endif
    endif
    bitDec = [bitDec;cellcalc((1:4),1)];
    i=i+8;
    g=g+8;
  endwhile
endfunction
bitDec = hamming748_decode(cellusers);

usersTab= bitSeq((49:end),1);

function info = chercheUser(usersTab);
  info=-1;
  i=0;
  k=1;
  l=48;
  while i < 11
    decoupeUser = usersTab((k:l),1);
    user=hamming748_decode(decoupeUser);
    userIdent = user(1:8,1);
    sum = 0;
    j=0;
    while j<8
      disp("j : ");
      disp(j);
      disp("user(j) ");
      disp(user(j+1));
      if user(j+1) == 1 
        sum += 2^(7-j);
      endif
      j=j+1;
    endwhile
    disp(sum);
    if sum == 3
      info = user;
    endif
    k=k+48;
    l=l+48;
    i=i+1;
  endwhile  
endfunction
disp("Appel cherche user");
user = chercheUser(usersTab);
userPBCHU = user(9:end,1);

function bitDec = QPSK_demod(qamSeq);
  for i = 1:length(qamSeq)
    reel = real(qamSeq(i))
    img = imag(qamSeq(i))
    if reel > 0 
      bitDec(2*(i-1) + 1) = 1
    else 
      bitDec(2*(i-1) + 1) = 0
    endif
    
    if img > 0
      bitDec(2*(i-1) + 2) = 1
    else 
      bitDec(2*(i-1) + 2) = 0
    endif
      
      
  endfor
endfunction

qpsk_matrix = QPSK_demod(qamMatrix);
check_QPSK();

function decodedMatrix = Demod_byMCS(qamSeq);

    decodedMatrix = [];
   
    if qamSeq(9) == 0 && qamSeq(10) == 0 
      disp("!!!!!!!!! decod bpsk ");
      decodedMatrix = BPSK_demod_vecteur(qamSeq);
    endif
    if qamSeq(9) == 1 && qamSeq(10) == 0 
      disp("!!!!!!!! decod qpsk ");
      decodedMatrix = QPSK_demod(qamSeq);
    endif
  
  #endfor
endfunction

decodedMatrix = Demod_byMCS(user);

function qamConstellation = Qam_Constellation(user);
 
 qamConstellationStr = ""
  for i = 9:14
    disp(" i :");
    disp(i);
    qamConstellationStr = strcat(qamConstellationStr ,  int2str(user(i)));
    disp("user i :");
    disp(user(i));
    disp("int2str user i :");
    
    disp(int2str(user(i)));
    disp("qamConstellationStr :");
    disp(qamConstellationStr);
   endfor
   disp(bin2dec (qamConstellationStr));
   qamConstellation = bin2dec (qamConstellationStr);
  
endfunction
 qamConstellation = Qam_Constellation(user)
 
 # matlab Structure 


sequence.RB = user(18 : 23 ) 
sequence.MCS_PDSCH = user(9 : 14) 
sequence.Constellation = Qam_Constellation(user)
