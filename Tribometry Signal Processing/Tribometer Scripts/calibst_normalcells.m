function [C,offsets,Fref,Vcalib] = calibst_normalcells(m)
% initialize DAQ
disp('daq init...')
s = daq.createSession('ni');     % creates session 's'
s.Rate = 10000;                   % sampling rate/sec
s.DurationInSeconds = 5;         % sampling duration

%%%%% constants
numSamples = s.Rate * s.DurationInSeconds;
sampleRate = s.Rate;
duration   = s.DurationInSeconds;

disp('done')

% add input and output channels
disp('add inputs and outputs...')

%%%%%% loadcell input channel (Fn1 and Fn2)
loadcell = s.addAnalogInputChannel('DEV1',0:1,'Voltage');

disp('done')

% set channel type
disp('set channels type...')
for i=1:2
    s.Channels(i).InputType ='Differential';
end
disp('done')

% Iterative calibration and offsets

if nargin == 0 
    m = [0 5.24 10.26 20.21 50.2 100.24 200.45]; % grammes
elseif isempty(m)
    m = [0 5.24 10.26 20.21 50.2 100.24 200.45]; % grammes
end

for k = 1:length(m)
    if m(k) == 0
        disp('***************************************')
        disp('Zeroing trial : don''t touch anything''')
    else
        disp('***************************************')
        disp(strcat('Calibration trial for m=',num2str(m(k)),'g : before starting put the weight in place'))
    end
    
    flg = 0;
    while flg == 0
        
        % Start record
        display('Recording, put the mass if needed');
        input('Press any key to start...','s');
        
        display('Start!');
        
        [dataX, time] = s.startForeground();
        
        % Plot data
        
        %%%%% Data from daq
        V1 = dataX(:,1); % loadcell 1
        V2 = dataX(:,2); % loadcell 2
        
        %%%%% Plots
        figure(1);
        clf()
        hold on
        xlabel('Time (s)');
        ylabel('Voltage')
        plot(time,V1,'--b',time,V2,'--g','linewidth',2)
        legend('loadcell 1','loadcell 2')
        hold off
        
        % Release data acquisition
        
        display('Done!');
        s.release();
        
        flg = input('Ok press 1 - Redo press 0');
        
        % store result
        if flg == 1
            Vcalib(1,k) = mean(V1);
            Vcalib(2,k) = mean(V2);
            close
        end
    end
end

%%%%% from mass to force
Fref = m*10^(-3)*9.81;
%%%%% retrieve offsets from calibration
calib(1,:) = polyfit(Fref/2,Vcalib(1,:),1);
calib(2,:) = polyfit(Fref/2,Vcalib(2,:),1);

%%%%%% plot
figure
hold on
plot(Fref/2,Vcalib(1,:),'b.')
plot(Fref/2,polyval(calib(1,:),Fref/2),'b','LineWidth',1.5)
plot(Fref/2,Vcalib(2,:),'r.')
plot(Fref/2,polyval(calib(2,:),Fref/2),'r','LineWidth',1.5)
hold off
xlabel('Weight (N)')
ylabel('Voltage')

% excld = input('Exclude points for linear fit? (yes = 1 ; no = 0)');
% 
% if excld == 1
%     inds = input('select points for the linear fit : ');
%     C(1,:) = polyfit(Fref(inds)/2,Vcalib(1,inds),1);
%     C(2,:) = polyfit(Fref(inds)/2,Vcalib(2,inds),1);
% elseif excld == 0
%     C(1,:) = polyfit(Fref/2,Vcalib(1,:),1);
%     C(2,:) = polyfit(Fref/2,Vcalib(2,:),1);
% end

%%%%% store in mat file
% if exist('offset&calibration.mat')
%     delete offset&calibration.mat
% end
m = matfile('offset&calibration','Writable',true);

normalcells.Fref = Fref;
normalcells.Vcalib = Vcalib;
normalcells.calibration = calib;

m.normalcells = normalcells;

end