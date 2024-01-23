fRef1 = 1e6;
s1 = exp(1j*2*pi*fRef1*t);  % 20 kHz

% fRef2 = 2e6;
% s2 = exp(1j*2*pi*fRef2*t);  % 40 kHz
% 
% fRef3 = 3e6;
% s3 = exp(1j*2*pi*fRef3*t);  % 80 kHz

% s = s1 + s2 + s3;
s = s1;
s = 0.6*s/max(abs(s)); % Scale signal to avoid clipping in the time domain

transmitRepeat(tx, s');