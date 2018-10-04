disp('daq init...')
s = daq.createSession('ni');     % creates session 's'
s.Rate = 10000;                   % sampling rate/sec
s.DurationInSeconds = 5;         % sampling duration

% constants
numSamples = s.Rate * s.DurationInSeconds;
sampleRate = s.Rate;
duration   = s.DurationInSeconds;

disp('done')

%% add input and output channels
disp('add inputs and outputs...')

% tangential force sensor input channel (Ft)
tangential = s.addAnalogInputChannel('DEV1',2,'Voltage');

% loadcell input channel (Fn1 and Fn2)
loadcell = s.addAnalogInputChannel('DEV1',0:1,'Voltage');

disp('done')

%% set channel type
for i=1:3
    s.Channels(i).InputType ='Differential';
end

%% Start record
display('Start!');

[dataX, time] = s.startForeground();
% s.startBackground();

%% Plot data


%%%%% calibration
sensor1_sens = 5 ;   %28.3257 N/V or 5 or 23.6773
sensor2_sens = 5 ;   %28.7649 N/V or 5 or 23.6773

%sensor3_sens = 0.500;    %0.500 N/V for lateral range of 5N
sensor3_sens = 5.00;     %5.000 N/V for lateral range of 50N

%%%%% Data from daq
F1 = dataX(:,1); % loadcell 1 (N)  dataX(V) - 0.25
F2 = dataX(:,2); % loadcell 2 - 0.35
F3 = dataX(:,3) ; % tangential

%%%%% Plots
figure(1);
clf()
hold on
xlabel('Time (s)');
ylabel('Force (N)')
plot(time,F1,'-b',time,F2,'-g',time,F3,'k','linewidth',1)
legend('loadcell 1','loadcell 2','tangential');
hold off

%% Release data acquisition

display('Done!');
s.release();
