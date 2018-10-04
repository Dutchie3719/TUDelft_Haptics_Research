%% Data Acquisition MATLAB Script
% Pi-Touch Lab TU Delft
% Lead: J. Hartcher - O'Brien
% Staff: D. Shor, B.Zaaijer

%% Scrape data from multiple .txt files into a single data table (For Loop Method)

% numMaterial = 12;
% mtrlno = 1
% 
% for mtrlno = 1:12
%     numFiles = 12;
%     startRow = 2;
%     endRow = inf;
%     myData = cell(1,numFiles);
%     for fileNum = 1:numFiles
%         A = 'mtrl':mtrlno:'.txt';
%         str = string(A)
%         fileName = sprintf(str,fileNum);
%         myData{fileNum} = importfile(mtrlno)(fileName,startRow,endRow);
%     end
%     mtrlno = mtrlno + 1;
%     display('Material No:mtrlno');
% end

%% Scrape data from multiple .txt files into a single data table (long method)

% numFiles = 12;
% startRow = 2;
% endRow = inf;
% 
% 
% myData1 = cell(1,numFiles);
% myData2 = cell(1,numFiles);
% myData3 = cell(1,numFiles);
% myData4 = cell(1,numFiles);
% myData5 = cell(1,numFiles);
% myData6 = cell(1,numFiles);
% myData7 = cell(1,numFiles);
% myData8 = cell(1,numFiles);
% myData9 = cell(1,numFiles);
% myData10 = cell(1,numFiles);
% myData11 = cell(1,numFiles);
% myData12 = cell(1,numFiles);
% 
% %Material 1
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl1%02d.txt',fileNum);
%     myData1{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 2
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl2%02d.txt',fileNum);
%      myData2{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 3
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl3%02d.txt',fileNum);
%     myData3{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 4
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl4%02d.txt',fileNum);
%     myData4{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 5
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl5%02d.txt',fileNum);
%     myData5{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 6
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl6%02d.txt',fileNum);
%     myData6{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 7
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl7%02d.txt',fileNum);
%     myData7{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 8
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl8%02d.txt',fileNum);
%     myData8{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 9
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl9%02d.txt',fileNum);
%     myData9{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 10
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl10%02d.txt',fileNum);
%     myData10{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 11
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl11%02d.txt',fileNum);
%     myData11{fileNum} = importfile(fileName,startRow,endRow);
% end
% 
% %Material 12
% for fileNum = 1:numFiles
%     fileName = sprintf('mtrl12%02d.txt',fileNum);
%     myData12{fileNum} = importfile(fileName,startRow,endRow);
% end
% 

%% Normalize Data

%% Find Start Point for each data

%% Plot Data

time = 1:50000;
time = time(:);

%%%%% Data from daq
A1 = Material01A(:,1); % loadcell 1 (N)  dataX(V) - 0.25
A2 = Material01A(:,2); % loadcell 2 - 0.35
A3 = Material01A(:,3) ; % tangential

B1 = Material01A(:,4); % loadcell 1 (N)  dataX(V) - 0.25
B2 = Material01A(:,5); % loadcell 2 - 0.35
B3 = Material01A(:,6) ; % tangential

C1 = Material01A(:,7); % loadcell 1 (N)  dataX(V) - 0.25
C2 = Material01A(:,8); % loadcell 2 - 0.35
C3 = Material01A(:,9) ; % tangential

D1 = Material01A(:,10); % loadcell 1 (N)  dataX(V) - 0.25
D2 = Material01A(:,11); % loadcell 2 - 0.35
D3 = Material01A(:,12) ; % tangential


%% Plots

Tangential(1) = subplot(4,1,1);
plot(A3)
ylabel('Sample 1 Pass 1 (N)')

Tangential(2) = subplot(4,1,2);
plot(B3)
ylabel('Sample 1 Pass 2 (N)')

Tangential(3) = subplot(4,1,3);
plot(C3)
ylabel('Sample 2 Pass 1 (N)')

Tangential(4) = subplot(4,1,4);
plot(D3)
ylabel('Sample 2 Pass 2 (N)')

xlabel('Time (s)')

linkaxes(Tangential,'x')

%% Find Delay Between Figures
%Find Delay in Section
t01 = finddelay(1,A3)
t02 = finddelay(1,B3)
t03 = finddelay(1,C3)
t04 = finddelay(1,D3)
 
%Compare 1 to N
t12 = finddelay(A3,B3);
t13 = finddelay(A3,C3);
t14 = finddelay(A3,D3);

%Compare 2 to N
t23 = finddelay(B3,C3);
t24 = finddelay(B3,D3);

%Compare 3 to N
t34 = finddelay(C3,D3);

%Find Max and Min Time Delay
timemat = [t12 t13 t14 t23 t24 t34];
mindelay = min(timemat);
maxdelay = max(timemat);

%% Aligns Signals
% % Line up the signals by leaving the earlier signal untouched and clipping
% % the delays out of the other vectors. Uses the tail of the vector to do 
% alignment. Add 1 to the lag differences to account for the one-based 
% indexing used by MATLAB(R). This method aligns the signals using as 
% reference the earliest arrival time, that of |s2|.
offset = 14000
axes(Tangential(1))
plot(A3(t01-offset:30000))

axes(Tangential(2))
plot(B3(t02-offset:end))

axes(Tangential(3))
plot(C3(t03-offset:end))

axes(Tangential(4))
plot(D3(t04-offset:end))