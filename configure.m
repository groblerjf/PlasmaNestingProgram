function configure(si)
% Function to configure GRBL

% As an added feature, lets check whether the guy can fill the GRBL buffer

%% The first consideration is the variables
bytesInBuffer = 0; % Keeps track of the bytes in the buffer
Buffer_Size = 128; % Defines the maximum size of the buffer
space_left = 0;    % Variable to account for the space left in buffer.
bytes_done = 0;    % Bytes that needs to be removed from bytesInBuffer
ok_counter = 1;    % This variable keeps track of the total number of 'ok'
                   % that GRBL sends back. In the end ok_counter should be
                   % equal to the lenth of gcode.
counter = 1;       % Counter for the gcode cell array.

string = '';       % This string is the same as bytes in buffer
commands = [];     % This cell array stores the commands sent

%% Help the user to exit

fprintf('Type ''q'' any time when you are done configuring');

%% Lets start configuring
% Since the user expect direct response from GRBL, we need to display the
% results as the user sends commands to GRBL. Therefor, the user cannot
% enter another command until GRBL has responded.

command_c = 0;  % Number of commands sent
ok_c = 0;       % Number of commands executed

while 1
    while si.BytesAvailable > 0
        text = fscanf(si);
        disp(text(1:end-2));
         
%         if strcmp(text, 'ok\n')
%             ok_c = ok_c + 1;
%             bytes_done = lentgh(command{ok_c}{1});
%             string(1:bytes_done) = '';
%             command{ok_c}{2} = 1;
%         else
%             disp(text(1:end-2));
%         end
    end
    
    
    
    %space_left = Buffer_Size - length(string);
    
    task = input('\n\nNext Command:  ', 's');
    
    if strcmp(task, 'q')
        break;
    else
        fprintf(si, task);
        pause(1);
    end
    
    %if length(task) <= space_left
%     fprintf(si, task);
%     string = [string task];
%     command_c = command_c + 1;
%     command{command_c}{1} = task;
%     command{command_c}{2} = 0;
    %end
end % End while loop

%fprintf('\nNumber of commands sent: %d', command_c);
%fprintf('\nNumber of comformations received: %d\n', ok_c);

end % End of 'configure' function