function bandpassSignalChannel = Bandpass_modulator(signal, carrierSignal, SNR)
    bandpassSignal = signal.*carrierSignal;

    bandpassSignalChannel = awgn(bandpassSignal, SNR, 'measured');
end