function [correctedSignal, frequencyOffset] = coarseCorrectionV2(rxSignal, sampleRate, M)
    % Perform FFT on the received signal
    Y = fftshift(fft(rxSignal));
    L = length(rxSignal);
    
    % Frequency axis
    f = (-L/2:L/2-1)*(sampleRate/L);
    
    % Find the peak in the FFT which corresponds to the frequency offset
    [~, peakIndex] = max(abs(Y).^M);
    frequencyOffset = f(peakIndex)*(sampleRate/(L*M));
    
    % Correct for the case where the peak is due to noise or harmonics
    % by ensuring the peak is significantly higher than the mean level
    if abs(Y(peakIndex)) < (mean(abs(Y)) * 10) % Threshold factor is arbitrary
        frequencyOffset = 0; % No significant peak found, assume no offset
    end
    
    % Generate correction signal
    t = (0:L-1)'/sampleRate;
    correctionSignal = exp(-1j*2*pi*frequencyOffset*t);
    
    % Apply the correction
    correctedSignal = rxSignal .* correctionSignal;

    rxSignalSpectrum = 10*log10(fftshift(fft(rxSignal)));
    rxCoarseSpectrum = 10*log10(fftshift(fft(correctedSignal)));

    subplot(3, 1, 1);
    plot(f, rxSignalSpectrum);
    subplot(3, 1, 2);
    plot(f, rxCoarseSpectrum);
end
