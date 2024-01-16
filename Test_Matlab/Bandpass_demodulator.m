function signalFiltered = Bandpass_demodulator(bandpassSignal, carrierSignal, pbFreq, pbRipple)

    basebandSignal = bandpassSignal.*carrierSignal;

    % Nfft = length(carrierSignal);
    % f = linspace(-0.5, 0.5, Nfft+1); f(end) = [];
    % signal_bb = 10*log10(fftshift(fft(basebandSignal, Nfft)));

    d = designfilt('lowpassiir', 'FilterOrder', 5, 'PassbandFrequency', pbFreq, ...
                    'PassbandRipple', pbRipple, 'SampleRate', 1);
    % fvtool(d); % Plots the response


    signalFiltered = filter(d, basebandSignal);
end