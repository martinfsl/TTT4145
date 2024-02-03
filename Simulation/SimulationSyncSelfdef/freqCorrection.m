function corrSignal = freqCorrection(rxSignal)

    phaseErrorDet = sign(real(rxSignal)).*imag(rxSignal) - ...
        sign(imag(rxSignal)).*real(rxSignal);
    
    corrSignal = phaseErrorDet;

end