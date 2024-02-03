signalToView = rxSignal;

Nfft = 2*length(signalToView);
f = linspace(-0.5, 0.5, Nfft+1)*sampleRate; f(end) = [];

spectrum = 10*log10(abs(fftshift(fft(signalToView, Nfft))));

plot(f, spectrum);