function check_CRC()
for sizeCRC = [8 16 24 32]
    disp(['CRC check for ' num2str(sizeCRC)]);
    x = [0  1  0  1  1  0  1  1  0  0  1  0  0  1  1  1  1  0  1  1  0  0  0  1  0  0  1  0  1  1  0  0];
    % --- adding CRC
    % To check if polynom is correct, sequence is not generated with
    % function 
    switch sizeCRC 
        case 8
            zz = [0     0     0     1     1     0     1     1];
        case 16
            zz = [0     1     1     0     0     1     1     0     0     1     1     1     0     1     0     0];
        case 24 
            zz = [  0     0     0     0     0     0     1     0     0 0     1     1     0     0     0     0     0     0   1     0     1     1     0     0];
        case 32
            zz = [ 1     1     1     0     1     1     1     1     0   0     0     1     1     0     0     1     1     0  0     1     0     0     1     1     1     0     1   1     0     0     1     1];
    end
    yS  = [x zz];
    yy  = crcEncode(sizeCRC,x);
    if sum(xor(yS,yy)) == 0
        disp(['Test 0 for CRC ' num2str(sizeCRC) ' check mapping is Correct (encoding)']);
    else
        disp(['FAIL test 0 for CRC ' num2str(sizeCRC) ' check (encoding)']);
    end        
    % --- Test 1 --> Direct decoding
    % --- Using our decoder
    [errPerso] = crcDecode(sizeCRC,yy);
    if errPerso == 0
        disp(['Test 1 for CRC ' num2str(sizeCRC) ' check mapping is Correct (decoding w/o errors)']);
    else
        disp(['FAIL test 1 for CRC ' num2str(sizeCRC) ' check (decoding w/o errors)']);
    end
    % --- Test 2 --> adding error
    yy(12) = yy(12) < 0.5;
    [errPerso2] = crcDecode(sizeCRC,yy);
    if errPerso2~= 0
        disp(['Test 2 for CRC ' num2str(sizeCRC) ' check mapping is Correct (decoding with errors)']);
    else
        disp(['FAIL test 2 for CRC ' num2str(sizeCRC) ' check (decoding with errors)']);
    end
end
end