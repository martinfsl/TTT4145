receivedSig = rx();

% Matched filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
rxFiltered = rxFiltered(span+1:end-span); % Removing offset from matched filter

% Coarse frequency offset correction
[rxCoarseComp, ~] = coarseCompensator(rxFiltered);

% Fine frequency offset correction
rxFineSync = fineSynchronizer(rxCoarseComp);

% Phase offset correction
% Can potentially be solved better with a preamble
rxPhaseSync = phaseSync(rxCoarseComp);

% In case order is changed
rxFinal = rxFineSync;

demodulatedBits = qamdemod(rxFinal, M, "gray");

% y = fftshift(abs(fft(receivedSig)));
% [~, idx] = findpeaks(y,'MinPeakProminence',max(0.5*y));
% fReceived = (max(idx)-numSamples/2-1)/numSamples*sampleRate;
% 
% % Plot the spectrum
% sa = dsp.SpectrumAnalyzer('SampleRate', sampleRate);
% sa.Title = sprintf('Tone Expected at 80 kHz, Actually Received at %.3f kHz', ...
%                    fReceived/1000);
% receivedSig = reshape(receivedSig, [], 16); % Reshape into 16 columns
% for i = 1:size(receivedSig, 2)
%     sa(receivedSig(:,i));
% end