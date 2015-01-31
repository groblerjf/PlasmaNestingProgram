function [control, error] = stepGen(path, arc, z, acc)
% [control, error] = stepGen(path, arc, z)
%
% This function will generate the necessary step and direction pulses from
% a vector that is supplied. This vector is not in absolute coordinates but
% in relative coordinates. It is the distance from the previous point to
% the current point.
%
% control - step vector
% error - the inherent error present due to hardware limits
% path - the vector for which the steps must be generated
% arc  - this gives the command to start the plasma cutter or not
% z    - With the current CNC machine, zaxis speed is slower than the other
% axes
% acc  - This tells the function that a new group is starting and some
% acceleration is needed.
%
% The z-axis has a max speed of 400 mm/min


% -------------------------------------------------------------------------
% Calibration Variables

step = 0.0249985686; % This includes the microstepping of the driver
%step = 0.025;
xdir = 1; 
ydir = 0; % This value can be changed when the direction is wrong.
zdir = 0;

% -------------------------------------------------------------------------

% Direction Calculation
if path(1) > 0; xdir = ~xdir; end
if path(2) > 0; ydir = ~ydir; end
if path(3) > 0; zdir = ~zdir; end

%disp(path);

%steps = [0 0 0];
% Step calculation
stappe = round(path./step); % Amount of steps needed
%steps(3)   = round(path(3)/0.002);  % Amoutn of steps for the z-axis

steps = abs(stappe);

% Calculate the path details
len = sqrt(dot(path, path));
base = 80; % This is the steps/mm with zeros
multiplier = 1;
base_mul = base * multiplier;
veclen = round(len * base_mul); % The length of the step vector

% Algorithm
% Determine the component with the most steps
index = find(steps == max(steps));

if steps == 0
    index(1) = 0;
end

control = zeros(veclen, 8);


% Here we fill the control vector with steps
switch index(1)
    case 0
        control = zeros(1, 8);
    case 1
        xspacing = veclen / steps(1);
        %steps(1)
        %steps(2)
        %steps(3)
        %xspacing
        %veclen
        control(round(1:xspacing:veclen), 1) = 1;
        control(:, 2) = xdir;
        
        if steps(2) > 0
            ratio1 = steps(1)/steps(2);
            yspacing = xspacing * ratio1;
            control(round(yspacing:yspacing:veclen), 3) = 1;
            control(:, 4) = ydir;
        end
        
        if steps(3) > 0
            ratio2 = steps(1)/steps(3);
            zspacing = xspacing * ratio2;
            control(round(zspacing:zspacing:veclen), 5) = 1;
            control(:, 6) = zdir;
        end
    case 2
        yspacing = veclen / steps(2);
        control(round(1:yspacing:veclen), 3) = 1;
        control(:, 4) = ydir;
        
        if steps(1) > 0
            ratio1 = steps(2)/steps(1);
            xspacing = yspacing * ratio1;
            control(round(xspacing:xspacing:veclen), 1) = 1;
            control(:, 2) = xdir;
        end
        
        if steps(3) > 0
            ratio2 = steps(2)/steps(3);
            zspacing = yspacing * ratio2;
            control(round(zspacing:zspacing:veclen), 5) = 1;
            control(:, 6) = zdir;
        end
    case 3
        zspacing = veclen / steps(3);
        control(round(1:zspacing:veclen), 5) = 1;
        control(:, 6) = zdir;
        
        if steps(1) > 0
            ratio1 = steps(3)/steps(1);
            xspacing = zspacing * ratio1;
            control(round(xspacing:xspacing:veclen), 1) = 1;
            control(:, 2) = xdir;
        end
        
        if steps(2) > 0
            ratio2 = steps(3)/steps(2);
            yspacing = zspacing * ratio2;
            control(round(yspacing:yspacing:veclen), 3) = 1;
            control(:, 4) = ydir;
        end
end

% Lets add the plasma torch activation
control(:, 8) = arc;

% Now we check that the appropiate number steps is in the control matrix,
% actually we are just gonne adjust the error.

xsum = sum(control(:, 1)) * sign(path(1));
ysum = sum(control(:, 3)) * sign(path(2));
zsum = sum(control(:, 5)) * sign(path(3));

% Error calculation
error = [xsum ysum zsum] * step - path;

% This should be the end of it
% Last edit is 23/1/2014 @ 15:36

end %End of function stepGen




% =================== Thoughts ====================
%
% Acceleration
% To add acceleration to the system, the origenal idea of changing the
% delay in the control program will not work as desired. Rather incorparate
% the acceleration by adding more 'zeros' (logic) between the steps during
% the step generation. The problem with ths is that you need to determine
% the change in direction to properly add the acceleration. Maybe we could
% just add this for starting points and then require that there be no sharp
% corners, i.o.w. FILLETS.


% Direction
% Since the program only works with vector, it is possible to determine the
% direction from those vectors


% Keeping Constant speed
% With the vector provided, we have x, y & z so we can determing the steps
% necessary for each component, the only concern is the timing.
% |
% Essentially, the actual length of the vector containing the steps should
% remain constant if only unit lengths are concerned. For better control,
% that vector can be made a few times larger than the bare minimum. This
% will results in more accurate timing of the steps.
% |
% We will start with 10x the required vector size and space the values in
% there, from there on we will see which spacing is the best fit.
% |
% After the standard steps have been generated, only then can the
% acceleration be added to the data.


% Timing
% This is the  only real concern when it comes to proper control. Therfore,
% the program that controls the LPT port should have a delay, but the steps
% that are generated here should be general, most likely the steps at
% almost maximum speed.


% Error
% It is a certainty that there will be errors in the position, it is
% therfore important not to let the errors accumulate. Since the step size
% is a known, and you cannot further microstep the driver, the error left
% behind after the appropiete number of full steps have been generated
% needs to sent back so that the next vector can bbe ajusted for the
% error. Hopefully this will minimize the final error in the end.
