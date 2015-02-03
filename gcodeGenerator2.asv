function [gcode, ttime, rtime] = gcodeGenerator2(data, part, MT, Amps, Material, ttravel, rtravel, handles)
% This function will generate the gcode for the machine.



% Set the cutting speed
[cSpeed, aVol, pHeight, cHeight, pDelay] = PM45CuttingSpeeds(Amps, MT, Material, handles);



% Creat a file name
% Just for the fun lets also create a file full of gcode. Then we can use
% another gcode sending program if we want to, but give the choice to
% delete the file in the end.

index = find(part == '\');

if ~isempty(index)
    part = part(index(end)+1:end);
end

fileName = [part '.gcode'];


% The plasma cutter manual has certain specs about the how high the torch
% should be when cutting. Here we will include that spec.

CH = 0.2; % The cut height


% Cut Feedrate
ttime = ttravel / cSpeed;


% Rapid Feedrate
rapid = '2500';
rtime = rtravel / str2double(rapid);




% Create a cell array with the gcode in it
gcode = [];
count = 1;
gcode{count} = '%';
count = count + 1;

% First we give some necessary information for the operator
gcode{count} = ['(', fileName,' - ', num2str(MT), ' mm Plate)'];
count = count + 1;
gcode{count} = '(We have the following cut spesifications)';
count = count + 1;
gcode{count} = ['(Cutting Speeds is ',  num2str(cSpeed), 'mm/min)'];
count = count + 1;
gcode{count} = ['(Cutting Current is ', num2str(Amps), 'A)'];
count = count + 1;
gcode{count} = ['(Selected Plate Thickness is', num2str(MT), 'mm)'];
count = count + 1;
gcode{count} = ['(Recommended Arc Voltage is', num2str(aVol), 'V )'];
count = count + 1;
gcode{count} = ['(Recommended Pierce Height is ', num2str(pHeight), 'mm )'];
count = count + 1;
gcode{count} = ['(Recommended Pierce Delay is ', num2str(pDelay), 's )'];
count = count + 1;
gcode{count} = ['(Recommended Cut Height is ', num2str(cHeight), 'mm )'];
count = count + 1;
gcode{count} = '(gcode for cutting)';
count = count + 1;

% Position the cutter (Assuming the homing has already been completed)
gcode{count} = 'G54G90G0X0.0Y0.0Z0.0';
count = count + 1;







% Inside Code
[~, col] = size(data);


for i = 1:col
    [~, cols] = size(data{i});
    
    
    gcode{count} = ['(Block ' num2str(i) ')'];
    count = count + 1;

    
    if strcmp(data{i}{1}{2}, 'LINE')
        %disp(data{i}{1}{3})
        gcode{count} = ['G0', 'X', num2str(data{i}{1}{3}), 'Y', num2str(data{i}{1}{4})];
        count = count + 1;
    end
    
    if strcmp(data{i}{1}{2}, 'ARC')
        gcode{count} = ['G0', 'X', num2str(data{i}{1}{3}), 'Y', num2str(data{i}{1}{4})];
        count = count + 1;
    end

    
    % Set the cutting speed and change back to absolute coordinates.
    gcode{count} = ['G90' 'F' num2str(cSpeed)];
    count = count + 1;
    
    
    % Lets find the plate zero via the THC (Arduino)
    gcode{count} = 'M3';       % Trigger the cutting process
    count = count + 1;

    % The THC now finds the plate zero. Once the zero is found, the THC will
    % send a Cycle Start signal to LinuxCNC

       
    % For loop for the data points
    for j = 2:cols
        if strcmp(data{i}{j}{2}, 'LINE')
            if j > 1
                x_start = data{i}{j}{3};
                y_start = data{i}{j}{4};
                x_end = data{i}{j-1}{5};
                y_end = data{i}{j-1}{6};
                
                if ~(abs(x_start - x_end) < 1e-4 && abs(y_start - y_end) < 1e-4)
                    gcode{count} = ['G1', 'X', num2str(data{i}{j}{3}), 'Y', num2str(data{i}{j}{4})];
                    count = count + 1;
                end
            end
            
            gcode{count} = ['G1', 'X', num2str(data{i}{j}{5}), 'Y', num2str(data{i}{j}{6})];
            count = count + 1;
        elseif strcmp(data{i}{j}{2}, 'ARC')
            %r = data{i}{j}{7};
            dir = data{i}{j}{8};
            
            if strcmp(dir, 'CW')
                arc_d = 'G2';
            elseif strcmp(dir, 'CCW')
                arc_d = 'G3';
            end
            
            icom = data{i}{j}{9} - data{i}{j}{3};
            jcom = data{i}{j}{10} - data{i}{j}{4};
            
            x_start = data{i}{j}{3};
            y_start = data{i}{j}{4}; 
            gcode{count} = ['G1', 'X', num2str(x_start), 'Y', num2str(y_start)];
            count = count + 1;
            gcode{count} = [arc_d, 'X', num2str(data{i}{j}{5}), 'Y', num2str(data{i}{j}{6}), 'I', num2str(icom), 'J', num2str(jcom)];
            count = count + 1;
        elseif strcmp(data{i}{j}{2}, 'CIRCLE')
            r = data{i}{j}{5};
            dir = data{i}{j}{6};
            
            if strcmp(dir, 'CW')
                arc_d = 'G2';
            elseif strcmp(dir, 'CCW')
                arc_d = 'G3';
            end
            
            x_start = data{i}{j}{3} + r;
            y_start = data{i}{j}{4}; 
            gcode{count} = ['G1', 'X', num2str(x_start), 'Y', num2str(y_start)];
            count = count + 1;
            gcode{count} = [arc_d, 'X', num2str(x_start), 'Y', num2str(y_start), 'I', num2str(-r), 'J0'];
            count = count + 1;
        end
    end
    
    gcode{count} = ['G1', 'X', num2str(data{i}{1}{3}), 'Y', num2str(data{i}{1}{4})];
    count = count + 1;
    
    % Lift up the torch again
    gcode{count} = 'M5';
    count = count + 1;
    gcode{count} = 'G91F300';
    count = count + 1;
    gcode{count} = 'G1Z0.5';
    count = count + 1;
    gcode{count} = 'G90';
    count = count + 1; 
end

gcode{count} = 'G0X0Y0';
count = count + 1;
gcode{count} = 'G91F300';
count = count + 1;
gcode{count} = 'G1Z5';
count = count + 1;
gcode{count} = 'G90';
count = count + 1;
gcode{count} = '%';


disp('Count')
disp(count)

 
 
% Now lets creat a file for the fun
% fprintf('\nSaving the file...\n');
% fod = fopen(fileName, 'w')
% [ded, col] = size(gcode);
% 
%  for i = 1:col
%      fprintf(fod, '%s\n', gcode{i});
%  end
%  
%  fclose(fod);


end % End of gcodeGenerator Function