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

%Sample Info
fs = 10000;  
%% Set Path for Call

% Call the right folder to start
selpath = uigetdir;
oldfolder = cd(selpath);

%% Import For Loop

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
cond1 = ['A0';'B0';'C0';'A5';'B5';'C5'];              %specify condition/material - direction of material stroke
% A = 0 Degree  (waft)
% B = 45 Degree (true bias)
% C = 90 Degree (weft)

% N0 = direction 1
% N5 = direction 2 (inverse)




for h=1:length(cond2)                                   %condition for each material
    for j=1:length(cond1)
        d = dir([cond2(h) cond1(j) '*.mat']);            %condition for each direction
        Number_mat = length(cond1)*length(cond2)
        %Number_mat = length(d);                         %number of .mat-Files
        figure(h)
        
        %Master Matrix Creation
        masterdataX = zeros(50000,Number_mat*3);         %Creates new master matrix with all data
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
%             subplot((Number_mat/2),2,i)                      %
%             plot(dataX(:,3))
            displayline = ['Materials Processed:', t];
            disp(displayline)
        end
    end
end

samplecount = h*j;
%% Change Path Back

cd(oldfolder);
%% Plot Initial Data

for q = 1:Width(tangdataX)
    figure('Name','Raw/Initial Data Plot'
        subplot((Number_mat/4),4,Number_mat)
        plot(tangdataX(:,q))
end
%% Find Delay (to signal fall) from initial for x normalization

for dlyct=1:samplecount                                   %runs once for each sample (delay count)
    delay(:,dlyct) = finddelay(0,tangdataX(:,dlyct));     %finds the delay between 0 and the dlyct col of tangdataX (this may need to be changed to 1)
end

mindelay = min(timemat);
maxdelay = max(timemat);
%% Find Offset for y normalization

avgydataX = zeros(50000;width(tangdataX)

for g = 1:width(tangdataX)
    avgydataX = mean(tangdataX, %how do I get this to do the first 5000 samples?
end

%% Transform into frequency domain

%Fast Forier Transform
%If the input X is a matrix, Y = fft(X) returns the Fourier transform of each column of the matrix.
%https://nl.mathworks.com/matlabcentral/answers/336010-how-do-i-convert-time-domain-data-into-frequency-domain

for g = 1:width(tangdataX)
    ffttangdataX(:,g) = fft(tangdataX(:,g));
end
%% Filtering

%bandpass filter 55hz - 1khz
%https://nl.mathworks.com/help/signal/ref/bandpass.html
filtertangdataX = bandpass(tangdataX,55,1000,fs);       %bandpass from 55hz to 1khz at sampling rate Fs.
filterffttangdataX = bandpass(fftangdataX,55,1000,fs);  %bandpass from 55hz to 1khz for the FFT

%% Integrate 

