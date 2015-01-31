function [sorted] = runAll()

clear
clc
%% Choose the DXF file
dxf = 'ARM';
fileName = [dxf '.dxf'];
% Read the DXF file
readDXF(fileName);

%% Read the data from the temp.gcode file
data = readData();
% fprintf('\nHere follows the Data that was read from the DXF file.\n------------------------------\n');
 %[~, col] = size(data);
 
 %for i = 1:col
 %    disp(data{i});
 %end

delete('temp.gcode');

%pause;
%% Sort the Data
sorted = sortData(data);

% fprintf('\nHere follows the Data that was sorted from the DXF file.\n');
[~, col] = size(sorted);
% 
% for i = 1:col
%     disp(sorted{i});
% end

% it would appear that I need to filter out the empty cells so that my
% other function can work

data = [];
count = 1;

for i = 1:col
    if isempty(sorted{i})
        continue;
    else
        data{count} = sorted{i};
        count = count + 1;
    end
end

%[~, col] = size(data);
%for i = 1:col
%    disp(data{i});
%end


%% -------------------------------------------------------------------------
% This function calculates the smallest points in both the x and y
% directions, then translates the drawing to the first quadrant. Another
% function that can be implemented in the function is to calculate the
% largest points. Knowing these extra points we can determine the size of
% the part being cut, and therfore determine whether the part can fit on
% the cutting area.

[data, L, W] = translate(data);
% -------------------------------------------------------------------------


%for i = 1:col
%    disp(data{i});
%end

%% -------------------------------------------------------------------------
% This function calculates the area 

[areas, points] = calcArea(data);
% -------------------------------------------------------------------------

%%
% For the most part, all the data have been sorted and translated. The
% areas as well as the center points of the blocks have been calculated.
% The remaining functions is to re-order the blocks so that the block with
% the largest area is cut last, and the inside blocks are cut first. Also,
% the cutting order can also be defined to minimize machine time. Another
% and maby one of the most important actions is to add the intro cut to
% each block. This may prove to be somewhat challaging as the program has
% to account for complex shapes, the orientation of the intro cut, as well
% as proportion of the cut relative to the block.
%
% ***
% Another check that can be done is the direction of cut with circles,
% whether thay are CWW or CW depends on whether the circles are outside or
% inside. 
%
% Note: The cutting direction for the outer block can also be determined,
% but are more complex in the sense that thay can have both CW and CWW arcs
% in the same block.
% ***



%% -------------------------------------------------------------------------
% This function will calculate the inside and outside blocks of the drawing
% as well as try to sequence the inside blocks so as to minimize the travel
% time of the plasma torch from one block to the next. The only input
% variable is the 'areas' matrix previously calculated. The sequence will
% only later be applied to the data set.

[in_order, punte] = sequence(areas, points);
% -------------------------------------------------------------------------


% Apply some order to the 'punte' cell array

 fprintf('\nPoints without added intro arcs\n\n');
 [~, col] = size(punte);
 
 for i = 1:col
     punte{i}{1} = i;
     %disp(punte{i});
 end



%% -------------------------------------------------------------------------
% Now once we have determine the outside and inside blocks, we need to
% apply that changes to the original 'data' variable which contains the
% drawings components and blocks.

data = applyOrder(data, in_order);


% fprintf('\n\nData entities without intro arcs\n\n');
% [~, col] = size(data);
% 
% for i = 1:col
%     disp(data{i});
% end
% -------------------------------------------------------------------------



%% -------------------------------------------------------------------------
% The next step is to add the intro arc to the entities

[data_arc, punte] = introArc(data, punte);


%  fprintf('\n\nData entities with added intro arc!!\n\n')
%  
%  [~, col] = size(data_arc);
%  
%  for i = 1:col
%      disp(data_arc{i});
%  end


fprintf('\n\nPoints with intro arc''s\n\n');
[~, col] = size(punte);

for i = 1:col
    disp(punte{i});
end



%% -------------------------------------------------------------------------
% Finally we will generate the gcode
% -------------------------------------------------------------------------

[gcode] = gcodeGenerator(punte, dxf);

% 
[~, col] = size(gcode);
 
for i = 1:col
    disp(gcode{i});
end


% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
% Lets send some gcode to the Arduino if you want to
clc
response = input('Do you wish to send the gcode to the Arduino? (y/n):\n', 's');
success = 0;

if strcmp(response, 'y')
    success = gcodeSender(gcode);
end
disp(success);



end