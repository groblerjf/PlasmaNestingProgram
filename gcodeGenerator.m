function [gcode, ttime, rtime] = gcodeGenerator(punte, part, MT, ttravel, rtravel)
% This function will generate the gcode for the machine.


% Creat a file name
% Just for the fun lets also create a file full of gcode. Then we can use
% another gcode sending program if we want to, but give the choice to
% delete the file in the end.

index = find(part == '\');

if ~isempty(index)
    part = part(index(end)+1:end);
end

fileName = [part '.nc'];


% Create a cell array with the gcode in it
gcode = [];

gcode{1} = '%';
gcode{2} = ['(', fileName,' - ', num2str(MT), ' mm Plate)'];
gcode{3} = '(gcode for cutting)';
gcode{4} = 'G54G90G1X0.0Y0.0F1500';

% Lets plunge the cutter
gcode{5} = 'G91F300';
gcode{6} = 'G1Z0.5';
gcode{7} = 'M03 S100';
gcode{8} = 'G1Z-0.5F200';
gcode{9} = 'M05';
gcode{10} = 'G1Z10F300';
gcode{11} = 'G1Z-8';
gcode{12} = 'G90';


% Cut Feedrate
feedrate = (round(347.2*exp(-0.5108*MT)))*10;
ttime = ttravel / feedrate;


% Rapid Feedrate
rapid = '2500';
rtime = rtravel / str2double(rapid);


% Inside Code
[ded, col] = size(punte);
count = 13;

for i = 1:col
    % Store the data points
    Lx = punte{i}{2};
    Ly = punte{i}{3};
    
    
    gcode{count} = ['(Block ' num2str(i) ')'];
    count = count + 1;

    
    % Position the cutter
    gcode{count} = ['G1', 'X', num2str(Lx(1)), 'Y', num2str(Ly(1)) 'F' rapid];
    count = count + 1;
    
    
    % Code to start the cutter
    gcode{count} = 'M03';
    count = count + 1;
    
    
    % Plunge the torch for cutting
    gcode{count} = 'G91F300';
    count = count + 1;
    gcode{count} = 'G1Z-2';
    count = count+1;
    gcode{count} = ['G90' 'F' num2str(feedrate)];
    count = count + 1;
    
   
    
    [ded, col] = size(Lx);
    % For loop for the data points
    for j = 2:col
        gcode{count} = ['G1', 'X', num2str(Lx(j)), 'Y', num2str(Ly(j))];
        count = count + 1;
    end
    
    
    gcode{count} = 'M05';
    count = count + 1;
    gcode{count} = 'G91F300';
    count = count + 1;
    gcode{count} = 'G1Z2';
    count = count + 1;
    gcode{count} = 'G90';
    count = count + 1; 
end

gcode{count} = ['G1X0Y0F', rapid];
count = count + 1;
gcode{count} = 'G91F300';
count = count + 1;
gcode{count} = 'G1Z50';
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