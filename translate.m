function [data, H, W] = translate(data)

% This function will determine the most negative point in both the negative
% x and y direction. All the entities will then be shifted to the first
% quadrant with a 2 mm gap beteen both the poistive x and y axis.
%
% The reason for the 2 mm gap is precisely for the plasma cutter, so that
% the arc will not drift in search of material to cut at the edge of the
% plate.
%
% The second feature of this function is to calculate the part width and
% hight.

x_neg = 0;
y_neg = 0;
x_pos = 0;
y_pos = 0;

[ded, col] = size(data);

for i = 1:col-1
    
    if isempty(data{i})
        continue;
    end
    
    if strcmp(data{i}{2}, 'CIRCLE')
        x_n = data{i}{3} - data{i}{5};
        y_n = data{i}{4} - data{i}{5};
        x_p = data{i}{3} + data{i}{5};
        y_p = data{i}{4} + data{i}{5};
        
        if x_n < x_neg; x_neg = x_n; end
        if x_p > x_pos; x_pos = x_p; end
        if y_n < y_neg; y_neg = y_n; end
        if y_p > y_pos; y_pos = y_p; end
        continue;
    end

    if strcmp(data{i}{2}, 'LINE')
        x = data{i}{3};
        y = data{i}{4};
        
        if x < x_neg; x_neg = x; end
        if x > x_pos; x_pos = x; end
        if y < y_neg; y_neg = y; end
        if y > y_pos; y_pos = y; end
        
        x = data{i}{5}; 
        y = data{i}{6};
        
        if x < x_neg; x_neg = x; end
        if x > x_pos; x_pos = x; end
        if y < y_neg; y_neg = y; end
        if y > y_pos; y_pos = y; end
        continue;
    end

    if strcmp(data{i}{2}, 'ARC')
        a_sta = data{i}{11};
        a_end = data{i}{12};
        r = data{i}{7};
        x_cen = data{i}{9};
        y_cen = data{i}{10};
        dir = data{i}{8};
        
        
        if strcmp(dir, 'CW')
            a_tmp = a_sta;
            a_sta = a_end;
            a_end = a_tmp;
        end
        
        if a_end == 0
            a_end = 360;
        end
        
        if a_sta > a_end
            if a_sta < 360
                a_sta = a_sta - 360;         
            end

            if a_end > 0
                a_end = a_end + 360;
            end
        end
            
        % Determine the min value for the x and y coordinates.
        theta = a_sta:1:a_end;
        
        x = min(r*cosd(theta)) + x_cen;
        y = min(r*sind(theta)) + y_cen;
        
        if x < x_neg; x_neg = x; end       
        if y < y_neg; y_neg = y; end
        
        x = max(r*cosd(theta)) + x_cen;
        y = max(r*sind(theta)) + y_cen;
        
        if x > x_pos; x_pos = x; end
        if y > y_pos; y_pos = y; end
        continue;
    end
end

% Now to determine the size of the object
H = y_pos - y_neg;
W = x_pos - x_neg;

% Now that most negative points are determined, we can translate the entire
% drawing so that the origen (0;0) is the smallest point.

% To account for the chance that the drawing is already in the first
% quandrant, and to move it closer to the origen if necessary.
if x_neg > 0
    x_neg = x_neg * (-1);
else
    x_neg = abs(x_neg);
end

if y_neg > 0
    y_neg = y_neg * (-1);
else
    y_neg = abs(y_neg);
end

% Now we add 2 mm to account for the edges.
x_tr = x_neg + 2; % distance to translate in x-direction
y_tr = y_neg + 2; % distance to translate in y-direction

for i = 1:col-1
    
    if isempty(data{i})
        continue;
    end
    
    if strcmp(data{i}{2}, 'CIRCLE')
        data{i}{3} = data{i}{3} + x_tr;
        data{i}{4} = data{i}{4} + y_tr;
    end
    
    if strcmp(data{i}{2}, 'LINE')
        data{i}{3} = data{i}{3} + x_tr;
        data{i}{4} = data{i}{4} + y_tr;
        data{i}{5} = data{i}{5} + x_tr;
        data{i}{6} = data{i}{6} + y_tr;
    end
    
    if strcmp(data{i}{2}, 'ARC')
        data{i}{3} = data{i}{3} + x_tr;
        data{i}{4} = data{i}{4} + y_tr;
        data{i}{5} = data{i}{5} + x_tr;
        data{i}{6} = data{i}{6} + y_tr;
        data{i}{9} = data{i}{9} + x_tr;
        data{i}{10} = data{i}{10} + y_tr;
    end
end
end