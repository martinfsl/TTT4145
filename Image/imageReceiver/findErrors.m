% Finding the true message
Current_Dir = pwd;
TransmitPath = '../imageTransmitter';

cd(TransmitPath);
trueMessages = getSymbolsImage(25, 5);
cd(Current_Dir);

errors = [];

for i = 1:size(messagesSorted, 2)
    errors = [errors, symerr(messagesSorted(:, i), trueMessages(:, i))];
end