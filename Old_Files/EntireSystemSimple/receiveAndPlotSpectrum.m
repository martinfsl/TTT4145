% Create a Spectrum Analyzer System object
spectrumAnalyzer = dsp.SpectrumAnalyzer(...
    'SampleRate', rx.BasebandSampleRate, ...
    'CenterFrequency', centerFreq, ...
    'SpectralAverages', 10, ...
    'YLimits', [-130, -30], ...
    'Title', 'Real-Time Spectrum of Received Signal', ...
    'FrequencySpan', 'Span and center frequency');

% Stream processing loop
for frame = 1:numSamples
    % Receive signal from Pluto SDR
    rxSig = rx();
    
    % Plot spectrum
    spectrumAnalyzer(rxSig);
end

% Release the System objects
release(rx);
release(spectrumAnalyzer);
