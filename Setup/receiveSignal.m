disp(['Capture signal and observe the frequency offset' newline])
receivedSig = rx();

% Find the tone that corresponds to the 80 kHz transmitted tone
y = fftshift(abs(fft(receivedSig)));
[~, idx] = findpeaks(y,'MinPeakProminence',max(0.5*y));
fReceived = (max(idx)-numSamples/2-1)/numSamples*sampleRate;

% Plot the spectrum
sa = dsp.SpectrumAnalyzer('SampleRate', sampleRate);
sa.Title = sprintf('Tone Expected at 80 kHz, Actually Received at %.3f kHz', ...
                   fReceived/1000);
receivedSig = reshape(receivedSig, [], 16); % Reshape into 16 columns
for i = 1:size(receivedSig, 2)
    sa(receivedSig(:,i));
end