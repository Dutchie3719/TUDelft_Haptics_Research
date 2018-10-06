%% Data Acquisition MATLAB Script
% Pi-Touch Lab TU Delft
% Lead: J. Hartcher - O'Brien
% Staff: D. Shor, B.Zaaijer L. Plaude


%% Clear Windows
close all
clearvars
clc

%% Define Global Variables
%Time
time = 1:50000;
time = time(:);
%% Set Path for Call

% Call the right folder to start
selpath = uigetdir;
oldfolder = cd(selpath);
% separate for material, then direction of weave, then plot tangential

%% Main For Loop that Calls Everything

% Materials
cond2 = ['1';'2';'3';'4';'5';'6';'7';'8';'9';]  %this line on;y breals when greater than like 9?                          %specify condition/material - direction of material stroke
% 1 = 
% 2 = Wool Twill
% 3 = 
% 4 =
% 5 = 
% 6 = 
% 7 = 
% 8 = 
% 9 =
% 10 =
% 11 =
% 12 =

% Directions
cond = ['A0';'B0';'C0';'A5';'B5';'C5'];              %specify condition/material - direction of material stroke
% A = 0 Degree  (waft)
% B = 45 Degree (true bias)
% C = 90 Degree (weft)

% N0 = direction 1
% N5 = direction 2 (inverse)




for h=1:length(cond2)                                   %condition for each material
    for j=1:length(cond)
        d = dir([cond2(h) cond(j) '*.mat']);            %condition for each direction
        Number_mat = length(cond)*length(cond2)
        %Number_mat = length(d);                         %number of .mat-Files
        figure(h)
        
        %Master Matrix Creation
        masterdataX = zeros(50000,Number_mat);         %Creates new master matrix with all data
        roundnumber_mat = round(Number_mat/3,0);
        tangdataX = zeros(50000,roundnumber_mat);      %Creates a master matrix with only tangential
        
        %For Loop Counters
        a = 1;                                          %Used in for loop to ensure which col in new master matrix
        b = 2;
        c = 3;
        t = 1;
        
        for i=1:Number_mat
            %Load Data
            load(d(i).name,'dataX')             %Load the dataX from each .mat
            
            %Create new Master Matricies
            masterdataX(:,a) = dataX(:,1);
            masterdataX(:,b) = dataX(:,2);
            masterdataX(:,c) = dataX(:,3);
            
            tangdataX(:,t) = dataX(:,3);
            
            a = a+3;                            %Increase counters by 3 for master matrix (3 data streams) increase by 1 for tangentaial
            b = b+3;
            c = c+3;
            t = t+1;
            
            %Plot Data
            subplot(4,2,i)                      %
            plot(dataX(:,3))
            displayline = 'Materials Processed:'; h;
            disp(displayline)
        end
    end
end

samplecount = h*j;
%% Change Path Back
cd(oldfolder);

%% Find Delay (to signal fall) from initial 

for dlyct=1:samplecount                                     %runs once for each sample (delay count)
    delay(:,dlyct) = finddelay(0,tangdataX(:,dlyct));     %finds the delay between 0 and the dlyct col of tangdataX (this may need to be changed to 1)
end

mindelay = min(timemat);
maxdelay = max(timemat);
%% Code to be Integrated
% %% Normalize Data
% 
% %% Find Start Point for each data
% 
% %% Plot Data
% 

% 
% %%%%% Data from daq
% A1 = masterdataX(:,1); % 
% A2 = masterdataX(:,2); % 
% A3 = masterdataX(:,3) ; % 
% 
% B1 = masterdataX(:,4); % loadcell 1 (N)  dataX(V) - 0.25
% B2 = masterdataX(:,5); % loadcell 2 - 0.35
% B3 = masterdataX(:,6) ; % tangential
% 
% C1 = masterdataX(:,7); % loadcell 1 (N)  dataX(V) - 0.25
% C2 = masterdataX(:,8); % loadcell 2 - 0.35
% C3 = masterdataX(:,9) ; % tangential
% 
% D1 = masterdataX(:,10); % loadcell 1 (N)  dataX(V) - 0.25
% D2 = masterdataX(:,11); % loadcell 2 - 0.35
% D3 = masterdataX(:,12) ; % tangential
% 
% 
% %% Plots
% 
% Tangential(1) = subplot(4,1,1);
% plot(A3)
% ylabel('Sample 1 Pass 1 (N)')
% 
% Tangential(2) = subplot(4,1,2);
% plot(B3)
% ylabel('Sample 1 Pass 2 (N)')
% 
% Tangential(3) = subplot(4,1,3);
% plot(C3)
% ylabel('Sample 2 Pass 1 (N)')
% 
% Tangential(4) = subplot(4,1,4);
% plot(D3)
% ylabel('Sample 2 Pass 2 (N)')
% 
% xlabel('Time (s)')
% 
% linkaxes(Tangential,'x')
% 
% %% Find Delay Between Figures
% %Find Delay in Section
% t01 = finddelay(1,A3)
% t02 = finddelay(1,B3)
% t03 = finddelay(1,C3)
% t04 = finddelay(1,D3)
%  
% %Compare 1 to N
% t12 = finddelay(A3,B3);
% t13 = finddelay(A3,C3);
% t14 = finddelay(A3,D3);
% 
% %Compare 2 to N
% t23 = finddelay(B3,C3);
% t24 = finddelay(B3,D3);
% 
% %Compare 3 to N
% t34 = finddelay(C3,D3);
% 
% %Find Max and Min Time Delay
% timemat = [t12 t13 t14 t23 t24 t34];
% mindelay = min(timemat);
% maxdelay = max(timemat);
% 
% %% Aligns Signals
% % % Line up the signals by leaving the earlier signal untouched and clipping
% % % the delays out of the other vectors. Uses the tail of the vector to do 
% % alignment. Add 1 to the lag differences to account for the one-based 
% % indexing used by MATLAB(R). This method aligns the signals using as 
% % reference the earliest arrival time, that of |s2|.
% offset = 14000
% axes(Tangential(1))
% plot(A3(t01-offset:30000))
% 
% axes(Tangential(2))
% plot(B3(t02-offset:end))
% 
% axes(Tangential(3))
% plot(C3(t03-offset:end))
% 
% axes(Tangential(4))
% plot(D3(t04-offset:end))