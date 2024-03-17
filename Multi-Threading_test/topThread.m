buffer = [];

c = parcluster();

times = 0;
validBuffer = 0;

while times < 20
    buffer = [buffer, times];
    disp(buffer);

    if (times > 4)
        validBuffer = 1;
        job = batch(c, @sideFunction, 1, {buffer(:)});
        buffer = fetchOutputs(job);
    elseif (times <= 4 && validBuffer)
        cancel(f);
    end

    pause(2);
    times = times + 1;
end