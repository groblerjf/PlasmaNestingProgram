function [control] = stepControl(punte)
% This function will surve the same purpose as the gcodeGenerator function,
% only this will be for the paralle port. Another feature of this function
% is the ability to send the steps to the parallel port.
%
% The more important feature of this function is the ablity to add some
% form of acceleration to the code. Even a small form of acceleration will
% help smooth the movement of the CNC machine.
%
% The input for this function is the 'punte' variable, which is a cell
% array with the coordinates for all the different groups in the cut.
%
% ** This is an experimental function, and it not garanteed that this will
% work. Thank you! :)

clc;
count = 1;
pos(count, :) = [0 0 0 0];
count  = count + 1;
% =========================================================================
% Initialize the Plasma (Start the air)
% =========================================================================

vec = [0 0 2 0];
pos(count, 1:3) = pos(count-1, 1:3) + vec(1:3);
pos(count, 4) = vec(4);
count =  count + 1;


vec = [0 0 -2 1];
pos(count, 1:3) = pos(count-1, 1:3) + vec(1:3);
pos(count, 4) = vec(4);
count =  count + 1;


vec = [0 0 40 0];
pos(count, 1:3) = pos(count-1, 1:3) + vec(1:3);
pos(count, 4) = vec(4);
count =  count + 1;


vec = [0 0 -30 0];
pos(count, 1:3) = pos(count-1, 1:3) + vec(1:3);
pos(count, 4) = vec(4);
count =  count + 1;

start = 1;

[ded, col] = size(punte);


for i = 1:col
    % Store the data points
    Lx = punte{i}{2};
    Ly = punte{i}{3};
    
    % Go to the starting position of the group
    if start
        vec = [Lx(1) Ly(1) 0 0];
        pos(count, 1:3) = pos(count-1, 1:3) + vec(1:3);
        pos(count, 4) = vec(4);
        count =  count + 1;
        start = 0;
    else
        vec = [Lx(1) Ly(1) 10 0];
        pos(count, :) = vec;
        count =  count + 1;
    end
    
    
    % While we are plunging, lets put on the plasma cutter
    vec = [0 0 -10 1];
    pos(count, 1:3) = pos(count-1, 1:3) + vec(1:3);
    pos(count, 4) = vec(4);
    count =  count + 1;
    
    
    [ded, col] = size(Lx);
    % For-loop for the data points
    for j = 2:col
        vec = [Lx(j) Ly(j) 0 1];
        pos(count, :) = vec;
        count =  count + 1;
    end
    
    vec = [Lx(j) Ly(j) 10 0];
    pos(count, :) = vec;
    count =  count + 1;

end

% Absolute
vec = [0 0 10 0 ];
pos(count, :) = vec;
count =  count + 1;
    
% Absolute
vec = [0 0 50 0 ];
pos(count, :) = vec;

control = [];
err = [0 0 0];

for i = 2:count
    pos(i-1, 1:3) = pos(i-1, 1:3) + err;
    xdif = pos(i, 1) - pos(i-1, 1);
    ydif = pos(i, 2) - pos(i-1, 2);
    zdif = pos(i, 3) - pos(i-1, 3);
    
    [d, err] = stepGen([xdif, ydif, zdif], pos(i,4));
    control = [control; d];
end

disp(err);

end % End of function partPath


% Thoughts

% Inorder to add to appropiate acceleration, we need to know the cutting
% speed for this particular part, because this will determine how many zero
% vectors we add to the final vector.

% The acceleration remains constant. The only thing that changes is the
% time is takes to get to full speed. For the sake of simplicity, we will
% use a linear acceleration curve, or at least try to be linear.

% Adding acceleration throughout the movement is not considered at this
% moment. We will first consider adding acceleration and deacceleration to
% the start and end of a group movement.
% It is actually possible to add acceleration to the whole movement. We
% just have to calculate the change in direction at each point and if the
% change is to severe we add a small deacceleration and acceleration.

% We need to consider the time is takes to accelerate as well. If the time
% is to large the plasma torch will start to burn an unnecessary large hole
% in the plate which is not desired.


