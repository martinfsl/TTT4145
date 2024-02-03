function coarseCorrSignal = coarseCorrectionFFT(...
    rxSignal, M, sampleRate)
    
    rxSignalPow = rxSignal.^M;

    % Nfft = length(rxSignalPow);
    Nfft = 2^(ceil(log2(length(rxSignal))));
    f = linspace(-0.5, 0.5, Nfft+1)*sampleRate; f(end) = [];
    rxSpectrum = 10*log10(abs(fftshift(fft(rxSignalPow, Nfft))));

    [~, index] = max(rxSpectrum);
    freqOffset = f(index);

    if abs(freqOffset) > 1e3
        if freqOffset > 0
            pfo = comm.PhaseFrequencyOffset("PhaseOffset", 0, "FrequencyOffset", -freqOffset, ...
            "SampleRate", sampleRate);
        else
            pfo = comm.PhaseFrequencyOffset("PhaseOffset", 0, "FrequencyOffset", freqOffset, ...
            "SampleRate", sampleRate);
        end

        coarseCorrSignal = step(pfo, rxSignal);
    else
        coarseCorrSignal = rxSignal;
    end

    % disp(freqOffset);

    disp(freqOffset);

    % Plotting
    rxSignalSpectrum = 10*log10(fftshift(fft(rxSignal, Nfft)));
    rxCoarseSpectrum = 10*log10(fftshift(fft(coarseCorrSignal, Nfft)));

    subplot(2, 1, 1);
    plot(f, rxSignalSpectrum);
    subplot(2, 1, 2);
    plot(f, rxCoarseSpectrum);
end