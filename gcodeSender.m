function [success] = gcodeSender(g_code, si)
%% 23/09/2013 -- Coding Date
% This function will send the gcode via serial the Arduino UNO with the
% GRBL firmware. After contacting Will Winder, coder of Universal g-code
% Sender (see Github), he indicated that the GRBL firmware has a 128 byte
% buffer for commands. He also indicated that a better implementation is
% have your own program account for this and always keep the buffers full.
% This way you lesson your change of losing commands and avoid errors in
% the middle of a program.

% ** GRBL only sends the 'ok\n' string once it has completed a block of
%    gcode in the buffer.

% -------------
% Since this function will only send the g-code for cutting and no other
% commands for settings and so on, we will only keep track of the commands
% within the 'gcode' cell array.
% -------------

%% The first consideration is the variables
bytesInBuffer = 0; % Keeps track of the bytes in the buffer
Buffer_Size = 128; % Defines the maximum size of the buffer
space_left = 0;    % Variable to account for the space left in buffer.
bytes_done = 0;    % Bytes that needs to be removed from bytesInBuffer
ok_counter = 1;    % This variable keeps track of the total number of 'ok'
                   % that GRBL sends back. In the end ok_counter should be
                   % equal to the lenth of gcode.
counter = 1;       % Counter for the gcode cell array.
value = '';

%% Calculate the Bytes in each block of g-code

[~, col] = size(g_code);

gcode = cell(1, col);

for i = 1:col
    gcode{i} = {g_code{i}, length(g_code{i}), 0};
end % End for-loop

%% Establish the Serial connection

% Lets do some clean up first
answer = instrfind;
if ~isempty(answer)
    delete(answer);
end

% Yes this is hard coding it, but this is part of the finer details that
% will be taken care of once everything works
si = serial('COM5');

fopen(si);

fprintf('\nConnecting ...\n');
pause(2);
string = '';

while si.BytesAvailable > 0
    string = fscanf(si);
    disp(string);
end

response = input('Do you wish to configure GRBL before sending the gcode? (y/n):\n', 's');

if strcmp(response, 'y')
    clc;
    configure(si); % Calls the function that configures GRBL
else
    % Check whether the GRBL is locked or Not
    if strcmp(string(1:end-2), '[''$H''|''$X'' to unlock]')
        fprintf(si, '$X');
    end
end

%% Send the g-code to GRBL
% ** Possibly we can plot each block as we receive the 'ok', but we need to
%    decode the g-code for that at the moment, maby later...

while counter < col % The loop only ends when GRBL is finished
    
    % First check if we can read anything from the serial
    % The very first time we enter the while-loop, there should be nothing
    if si.BytesAvailable > 0
        value = fscanf(si);
        %disp(value);
        
        if strcmp(value(1:2), 'ok')
            bytesInBuffer = bytesInBuffer - gcode{ok_counter}{2};
            gcode{ok_counter}{3} = 1;
            fprintf('--  %s\n', gcode{ok_counter}{1});
            ok_counter = ok_counter + 1;
            %disp('Entered OK');
            if ok_counter == col
                break;
            end
        end
        
        %disp('Bytes Available');
    end
    
    space_left = Buffer_Size - bytesInBuffer;
    
    % Now lets send a command
    if gcode{counter}{2} <= space_left
        fprintf(si, gcode{counter}{1});
        %fprintf('%s\n', gcode{counter}{1});
        bytesInBuffer = bytesInBuffer + gcode{counter}{2};
        counter = counter + 1;
    end
    
    
    %disp('in loop');
end % End while-loop


%% End the program
% Hopefully all is well and the part were cut successfully.
%clc;
fprintf('\n\n ----------- END GCODE SENDER -------------- \n\n');
fprintf('Ok, so now we are done with this part. Whats next??\n');

fclose(si);
delete(si)
clear si

success = 1;

end % End of function 'gcodeSender'






