%load all material interaction files
%separate for material, then direction of weave, then plot tangemtial
close all
clear all
clc
cond = ['A';'B';'C']; %specify condition/material - whatever yr a,b and c means
for j=1:length(cond)
    d = dir(['1' cond(j) '*.mat']); %load all mat files, separately for condition
    Number_mat = length(d);    % number of .mat-Files
    figure(j)
    for i=1:Number_mat
        load(d(i).name,'dataX')
        subplot(4,2,i)
        plot(dataX(:,3))
    end
end

%Differentiation (Bryan)

Fs = 1000;                      % Sample rate in Hz
N = 5000;                       % Number of signal samples
rng default;                    % Control Random Number Generator
signal=dataX(:,3);              % noisy waveform
t = (0:N-1)/Fs;                 % time vector

plot(signal);                   % Plot original waveform
legend('Lateral force','Location','NorthWest')
xlabel('Time (seconds)'), ylabel('Force (Newton)')
title('Lateral force')

Nf = 50;                        % FIR differentiator of order 50
Fpass = 100;                    % Set filter passband frequency
Fstop = 120;                    % Set filter stopband frequency

d = designfilt('differentiatorfir','FilterOrder',Nf, ...
    'PassbandFrequency',Fpass,'StopbandFrequency',Fstop, ...
    'SampleRate',Fs);

fvtool(d,'MagnitudeDisplay','zero-phase','Fs',Fs)
dt = t(2)-t(1);

vsignal = filter(d,signal)/dt;  % Apply differentiationfilter to signal
plot(vsignal)                   % Plot 

%delay = mean(grpdelay(d))
%tt = t(1:end-delay);
%vs = vsignal;
%vs(1:delay) = [];
%tt = t(1:end-delay);
%vs = vsignal;
%vs(1:delay) = [];

%[pkp,lcp] = findpeaks(signal);
%zcp = zeros(size(lcp));

%[pkm,lcm] = findpeaks(-signal);
%zcm = zeros(size(lcm));

%plot(t,signal,t([lcp lcm]),[pkp -pkm],'or')
%xlabel('Time (s)')
%ylabel('Force (N)')
%grid


%plot(tt,vs,t([lcp lcm]),[zcp zcm],'or')
%xlabel('Time (s)')
%ylabel('Velocity (cm/s)')
%grid

%window (dan)

%signal processing recipe

% Differentiate a signal without increasing the noise power
% Function diff amplifies the noise, and the resulting inaccuracy worsens for higher
% derivatives. To fix this problem, a differentiator filter is used instead. 
