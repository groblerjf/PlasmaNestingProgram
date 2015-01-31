function [punte, line] = introLine(punte, MT)
% This function will add an intro arc to each block.

% In order to complete this operation each group will be put into one
% vector. That vector will then be used to calculate certain unit vectors
% which will then be used to determine the direction of the intro cut.

% Two starting point for the intro arc will then be generated. The Ray
% casting algorithm will then be used to determine which one of those
% points are inside or outside of the polygon. 

% The 'Even-Odd Rule' will then be used. See Wikipedia/Even-odd_rule
clc;
[~, col] = size(punte);
blocks = col;

MT = 3;

% -------------------------------------------------------------------------
% Lets create those polygon vectors for the last two points and calculate
% the intro arc
% -------------------------------------------------------------------------
% The lines will stay the same.

u1 = zeros(blocks, 3); % Unit vector along polygon line
u2 = zeros(blocks, 3); % Unit vector towards inside of polygon
p  = zeros(blocks, 3); % End points
line = cell(1, blocks);

%figure(1)
%hold on

for i = 1:blocks
    
    if i == blocks
        Lx = punte{i}{2};
        Ly = punte{i}{3};
    else
        Lx = fliplr(punte{i}{2});
        Ly = fliplr(punte{i}{3});
    end
      
    
    
    for j = 1:length(Lx)
        fprintf('\nAttempt: %d\n', j);
     
        if j == 1
            x = Lx(j)-Lx(end-1);
            y = Ly(j)-Ly(end-1);
        else
            x = Lx(j)-Lx(j-1);
            y = Ly(j)-Ly(j-1);
        end

        u1(i, :) = [x, y, 0]/sqrt(x^2 + y^2);

        % Create two unit vectors perpendicular to u1
        v1 = cross(u1(i,:), [0 0 1]);
        v2 = cross(u1(i,:), [0 0 -1]);

        % Create the two points to be tested
        p1 = v1 + [Lx(j), Ly(j), 0];
        p2 = v2 + [Lx(j), Ly(j), 0];


        % Test the points with the Ray Casting Algorithm
        status1 = RayCasting(p1(1), p1(2), Lx, Ly);
        status2 = RayCasting(p2(1), p2(2), Lx, Ly);
        
        if status1 == status2
            continue;
        end

        if blocks == 1
            if ~status1 && ~status2
                continue;
            end
        end
        
        if i == blocks
            fprintf('\n --- The end was reached --- \n\n');

            if status1 == 0
                u2(i,:) = v1;
                u3(i,:) = [0 0 -1];
                p(i, :) = MT*v1 + [Lx(j), Ly(j), 0];
                fprintf('Lucky # 1\n\n');
                break;
            elseif status2 == 0
                u2(i,:) = v2;
                u3(i,:) = [0 0 1];
                p(i, :) = MT*v2 + [Lx(j), Ly(j), 0];
                fprintf('Lucky # 1\n\n');
                break;
            else
                fprintf('\nThe Ray Casting did not find an outside point');
            end
        else
            if status1
                u2(i,:) = v1;
                u3(i,:) = [0 0 1];
                p(i, :) = MT*v1 + [Lx(j), Ly(j), 0];
                break;
            elseif status2
                u2(i,:) = v2;
                u3(i,:) = [0 0 -1];
                p(i, :) = MT*v2 + [Lx(j), Ly(j), 0];
                break;
            else
                fprintf('\nThe Ray Casting did not find an inside point');
            end
        end
        
        fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++');
        %error('The Ray Casting really did not find an inside point');
    end % End of RayCasting for-loop
    
    if Lx(end-1) == Lx(1)
        x = Lx(1)-Lx(end-2);
        y = Ly(1)-Ly(end-2);
    else
        x = Lx(1)-Lx(end-1);
        y = Ly(1)-Ly(end-1);
    end
    
    if i == blocks && ~(blocks == 1)
        u3(i, :) = u3(i, :)*-1;
    end
    
    u1(i, :) = [x, y, 0]/sqrt(x^2 + y^2);
    v1 = cross(u1(i,:), u3(i, :));
    u2(i, :) = v1;
    p(i, :) = MT*v1 + [Lx(1), Ly(1), 0];
    
    
    line{i} = {i, 'LINE', p(i, 1), p(i, 2), Lx(1), Ly(1)};
    
    Lx = [p(i, 1) Lx];
    Ly = [p(i, 2) Ly];
    
    punte{i}{2} = Lx;
    punte{i}{3} = Ly;
end
end % End of function 'introArc'


function [status] = RayCasting(x, y, Lx, Ly)
% This function will test whether a point is inside or outside the polygon.


% x, y -- x and y coordinates of point
% a list of multituples [(x, y), (x, y), ...]
num = length(Lx) - 1;
j = num - 1;
status = 0;
for i = 1:num
        if  ((Ly(i) > y) ~= (Ly(j) > y)) && (x < (Lx(j) - Lx(i)) * (y - Ly(i)) / (Ly(j) - Ly(i)) + Lx(i))
            status = ~status;
            %fprintf('\nStatus Changed.\nIndex: %d\n', i);
        end
        j = i;
end

end % End of 'RayCasting' function













