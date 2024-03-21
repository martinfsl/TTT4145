function decoded = pskdemodSelf(rxSignal)
    decoded = zeros(length(rxSignal), 1);
    for i = 1:length(rxSignal)
        if (real(rxSignal(i)) >= 0) && (imag(rxSignal(i)) >= 0)
            decoded(i) = 0;
        elseif (real(rxSignal(i)) < 0) && (imag(rxSignal(i)) > 0)
            decoded(i) = 1;
        elseif (real(rxSignal(i)) > 0) && (imag(rxSignal(i)) < 0)
            decoded(i) = 2;
        elseif (real(rxSignal(i)) < 0) && (imag(rxSignal(i)) < 0)
            decoded(i) = 3;
        end
    end
end