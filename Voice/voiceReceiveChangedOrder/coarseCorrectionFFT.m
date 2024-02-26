function coarseCorrSignal = coarseCorrectionFFT(...
    rxSignal, M, sampleRate)
    
    % rxSignalPow = rxSignal.^M;
    rxSignalPow = rxSignal.^M;

    % Nfft = length(rxSignalPow);
    freqResolution = 1;
    % Nfft = 2^(ceil(log2(length(rxSignal)/freqResolution)));
    Nfft = 2^(ceil(log2(length(rxSignal))));
    f = linspace(-0.5, 0.5, Nfft+1)*sampleRate; f(end) = [];
    rxSpectrum = abs(fft(rxSignalPow, Nfft));

    [~, index] = max(rxSpectrum);

    % if index > Nfft
    %     index = index - Nfft;
    % end

    % freqOffset = f(index);
    freqOffset = (index-1)*(sampleRate/(Nfft*M));
    
    t = [0:length(rxSignal)-1]'/sampleRate;

    % disp(freqOffset);
    coarseCorrSignal = rxSignal .* exp(-1i*2*pi*freqOffset*t);

    % disp(freqOffset);
    % fprintf("%i %i %i", freqOffset, Nfft, sampleRate);

    % % Plotting
    % rxSignalSpectrum = 10*log10(fftshift(fft(rxSignal, Nfft)));
    % rxCoarseSpectrum = 10*log10(fftshift(fft(coarseCorrSignal, Nfft)));
    % 
    % subplot(3, 1, 1);
    % plot(f, rxSignalSpectrum);
    % subplot(3, 1, 2);
    % plot(f, rxCoarseSpectrum);
    % subplot(3, 1, 3);
    % plot(rxSpectrum);
end