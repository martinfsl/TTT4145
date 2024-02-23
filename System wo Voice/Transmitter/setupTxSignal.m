% preamble = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1];
% preamble = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
% preamble = repmat(preamble, 4, 1);
% preamble = repmat(preamble, 40, 1);
% preamble2 = [2; 2; 2; 2; 2; 3; 3; 2; 2; 3; 2; 3; 2];
% preamble = [preamble; preamble2];
% message = [1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
% message = repmat(message, 10, 1);
% message = repmat(3, 20, 1);
% message = [3; 2; 1; 0];
% message = repmat(message, 2000, 1);

% message1 = [3; 2; 1; 0];
% message1 = repmat(message1, 10, 1);
% message2 = [0; 1; 2; 3];
% message2 = repmat(message2, 10, 1);
% message = [message2; message1];

preamble = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
preamble = repmat(preamble, 10, 1);
message = [3; 2; 1; 0];
message = repmat(message, 20, 1);
bitStream = [message; preamble; message];
% bitStream = [message1; preamble; message2];