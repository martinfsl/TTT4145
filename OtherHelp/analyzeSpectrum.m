signalToAnalyze = dataModulated;

Nfft = length(signalToAnalyze);
f = linspace(-0.5, 0.5, Nfft+1); f(end) = [];
f = sampleRate.*f;
spectrum = 10*log10(fftshift(fft(signalToAnalyze, Nfft)));

plot(f, spectrum);