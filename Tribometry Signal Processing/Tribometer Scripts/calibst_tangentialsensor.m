function [C,offset,Ft,calib] = calibst_tangentialsensor(m)
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

%%%%% tangential force sensor input channel (Ft)
tangential = s.addAnalogInputChannel('DEV1',2,'Voltage');

disp('done')

% set channel type
disp('set channels type...')
s.Channels(1).InputType ='Differential';

disp('done')

% Iterative calibration and offsets

if nargin == 0 
    m = [0 5.24 10.26 20.21 50.2 100.24]; % grammes
elseif isempty(m)
    m = [0 5.24 10.26 20.21 50.2 100.24]; % grammes
end

for k = 1:length(m)
    if m(k) == 0
        disp('***************************************')
        disp('Offsets trial : don''t touch anything''')
    else
        disp('***************************************')
        disp(strcat('Calibration trial for m=',num2str(m(k)),'g : before starting put the weight in place'))
    end
    
    flg = 0;
    while flg == 0
        
        % Start record
        display('Recording, put the mass if needed');
        input('Press any key to start...','s');
        
        pause(2);
        
        display('Start!');
        
        [dataX, time] = s.startForeground();
        
        % Plot data
        
        %%%%% Data from daq
        V = dataX(:,1); % tangential force sensor
        
        %%%%% Plots
        figure(1);
        clf()
        hold on
        xlabel('Time (s)');
        ylabel('Voltage')
        plot(time,V,'--b','linewidth',2)
        legend('Tangential voltage');
        hold off
        
        % Release data acquisition
        
        display('Done!');
        s.release();
        
        flg = input('Ok press 1 - Redo press 0');
        
        % store result
        if flg == 1
            Vcalib(1,k) = mean(V);
            close
        end       
    end     
end

%%%%% from mass to force
Fref = m*10^(-3)*9.81;
%%%%% retrieve offsets from calibration
calib(1,:) = polyfit(Vcalib,Fref,1);

%%%%%% plot
figure
hold on
plot(Vcalib,Fref,'b.')
plot(Vcalib,polyval(calib,Vcalib),'b')
hold off

% excld = input('Exclude points for linear fit? (yes = 1 ; no = 0)');
% 
% if excld == 1
%     inds = input('select points for the linear fit : ');
%     C = polyfit(V(inds)/2,calib(inds),1);
% elseif excld == 0
%     C = polyfit(V/2,calib(:),1);
% end

%%%%% store in mat file
m = matfile('offset&calibration','Writable',true);

tangentialsensor.Fref = Fref;
tangentialsensor.calibration = calib;
tangentialsensor.Vcalib = Vcalib;

m.tangentialsensor = tangentialsensor;

end