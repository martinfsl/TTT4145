fRef1 = 20e3;
s1 = exp(1j*2*pi*fRef1*[0:10000-1]'/sampleRate);  % 20 kHz

fRef2 = 40e3;
s2 = exp(1j*2*pi*fRef2*[0:10000-1]'/sampleRate);  % 40 kHz

fRef3 = 90e3;
s3 = exp(1j*2*pi*fRef*[0:10000-1]'/sampleRate);  % 80 kHz

s = s1 + s2 + s3;
s = 0.6*s/max(abs(s)); % Scale signal to avoid clipping in the time domain

transmitRepeat(tx, s);