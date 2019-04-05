% test_solafs_tsm
% SOLAFS TIME SCALE MODIFICATION

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters carefully tuned to synchronize TSM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0 < alpha <= 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f0 = 20 Hz
% sr = 16000 samples/s
% T0 = 800 samples
% Wov = T0;
% synth_hopsize = 2*Wov;
% win_size = 3*T0 = 24000 samples
% Kmax = fix(1.2*T0);
% alpha = 0.2, 0.5, 0.7, 1, 1.25, 1.5, 1.75, 2.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE INPUT SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sampling rate
sr = 16000;
% Fundamental frequency in Hz
f0 = 120;
% Period of the fundamental
T0 = fix(sr/f0);
% Signal length N
N = 16000;
% Time in signal reference
time = (0:N-1)'/sr;
% Phase shift
phi = [0 3*pi/5 7*pi/2 -pi/7 11*pi/2 -5*pi/11 2*pi/5 -pi/3];
% Input signal
sig = 0.8*sin(2*pi*f0.*time+phi(1)) + 0.75*sin(2*pi*2*f0.*time+phi(2)) + 0.55*sin(2*pi*3*f0.*time+phi(3)) + 0.45*sin(2*pi*4*f0.*time+phi(4)) + 0.25*sin(2*pi*5*f0.*time+phi(5)) + 0.18*sin(2*pi*6*f0.*time+phi(6)) + 0.08*sin(2*pi*7*f0.*time+phi(7));
% sig = sin(2*pi*f0.*time+phi(1));
% Normalize input signal
sig = sig/max(abs(sig));
% Normalize window during analysis (sum(window)==1) to preserve energy upon resynthesis
normwin = 1;
% Position of the center of the first analysis window
center = {'half'};
cp = 1;
% Flag to play result = 1
splay = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOLAFS INPUT PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of samples in overlap region
% Wov = T0;
Wov = 60;
% Synthesis hop size >= Wov (smallest == Wov)
synth_hopsize = 2*Wov;
% Window (frame) size (smallest 2*Wov)
winl = 3*Wov;
% Kmax >= T0
% Kmax = fix(1.1*T0);
Kmax = 200; % 12.5 ms
% Time scale factor
alpha = 1.5;

tsm = solafs(sig,synth_hopsize,winl,center{cp},Kmax,alpha);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % SPLIT SIG INTO OVERLAPPING FRAMES OF WINSIZE SEPARATED BY ANALYSIS HOPSIZE
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [wsig,frame_pos,dur] = soffs(sig,synth_hopsize,winl,center{cp},Kmax,alpha);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % OVERLAP-ADD RESULT WITH SYNTHESIS HOPSIZE
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% olasig = olafs(wsig,fix(alpha*dur),winl,synth_hopsize,center{cp});

tsm_time = (0:fix(alpha*N)-1)'/sr;

% figure(1)
% plot(time,sig,'k')
% hold on
% plot(tsm_time,olasig,'r')
% hold off
% title('Waveform')
% xlabel('Time (s)')
% ylabel('Amplitude')
% legend('Original','Time Scale')

figure(2)
plot(sig,'k')
hold on
plot(tsm,'r')
hold off
title('Waveform')
xlabel('Time (s)')
ylabel('Amplitude')
legend('Original','Time Scale')

if splay
    sound(sig,sr)
    pause(2)
    sound(tsm,sr)
end