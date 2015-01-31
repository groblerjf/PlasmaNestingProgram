function [areas, points] = calcArea(data)
% This function will calculate the area of the groups in the data variable
% to determine whether that specific group is inside or outside.

% This function will scan through each group and turn all the arcs to an
% array of lines, and calculate the area using the 'polyarea' function.
% Circles will just be calculated using the normal pi*r^2 formula.

% The idea behind this function is that the biggest area correlates to the
% outside block, and the rest of the areas are then assumed to be the
% inside entities.

[~, col] = size(data);

blocks = data{col}{1};
areas = zeros(blocks, 4);
points = cell(1, blocks);
count = 1;

for i = 1:blocks
    x = [];
    y = [];

    if strcmp(data{count}{2}, 'CIRCLE') 
        r1 = data{count}{5};
        area1 = pi()*r1^2;
        x_cen = data{count}{3};
        y_cen = data{count}{4};
        [x1, y1] = circle2line(data{count});
        areas(i, :) = [i, area1, x_cen, y_cen];
        points{i} = {i, x1, y1};
        count = count + 1;
        continue;
    end

    if max(strcmp(data{count}{2}, {'LINE', 'ARC'}))
        x_start = data{count}{3};
        y_start = data{count}{4};
        
        x = x_start;
        y = y_start;
        
        while(i == data{count}{1} && count < col)   
            if strcmp(data{count}{2}, 'LINE')
                x = [x data{count}{5}];
                y = [y data{count}{6}];
            end

            if strcmp(data{count}{2}, 'ARC')
                [x_arc, y_arc] = arc2line(data{count});
                x = [x x_arc(2:end)];
                y = [y y_arc(2:end)];
            end        

            count = count + 1;
        end
        %x = [x x_start];
        %y = [y y_start];
        [area1,cx,cy] = polycenter(x,y);
        areas(i, :) = [i, area1, cx, cy];
        points{i} = {i, x, y};
        continue;
    end
    
end
end

