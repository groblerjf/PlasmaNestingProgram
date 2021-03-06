function [kerf_added, tmp_data] = kerfWidth(MT, punte, data, Offset)
% This function will accout for the kerf width as well as for the
% additional offset that the user wants to add to the cuts.

% And just because we can, we will take care of the direction of cut as
% well. This is to ensure the square is on the part and that the not so
% square edge is on the scrap.

% -------------- Determining the kerf width --------------------
% I am using a very bad method to determing the kerf width at the moment. I
% tried to use the tow kerf widths that I measured during the test, and
% tried to fit a exponential curve to them, but it was not entirely right,
% so I took a geuse of some kerf width for an 8 mm plate and used that
% thrid point to determine a new formula for the kerf width.

width = 1; % This is the with for the Hypertherm Powermax 45

t_offset = Offset + 0.5*width;

% The first step is to find the inside and outside of the group. From there
% onwards we can add the kerf width and the extra offset.

[~, col] = size(punte);
blocks = col;

kerf = cell(1, blocks);
tmp_data = cell(1, blocks);
[~, colm] = size(data);

% The following for will store the group of cells into one cell
block = 1;
posi = 1;

%disp('Now the data is rewritten');
for i = 1:colm-1
    if data{i}{1} == block
        tmp_data{block}{posi} = data{i};
        %disp(tmp_data{block}{posi});
        posi = posi + 1;
    else
        posi = 1;
        block = block + 1;
        tmp_data{block}{posi} = data{i};
        %disp(tmp_data{block}{posi});
        posi = 2;
    end
end % End of for-loop
%disp('Data write process complete');


u1 = zeros(blocks, 3); % Unit vector along polygon line
u2 = zeros(blocks, 3); % Unit vector towards inside of polygon/ and outside
u3 = zeros(blocks, 3); % Will save the vector used to determine direction
p  = zeros(blocks, 3); % End points


fprintf('This is the number of blocks %d\n', blocks);


for i = 1:blocks
    Lx = punte{i}{2};
    Ly = punte{i}{3};
        
    %fprintf('This is the length of Lx %d\n', length(Lx));
    
    for j = 2:length(Lx)
        %fprintf('\nAttempt: %d\n', j);
        x = Lx(j-1)-Lx(j);
        y = Ly(j-1)-Ly(j);
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
   
        if blocks == 1
            if ~status1 && ~status2
                continue;
            end
        end
   
        if i == blocks
            if ~status1
                u2(i,:) = v1;
                u3(i,:) = [0 0 1];
                p(i, :) = 2*v1 + [Lx(j), Ly(j), 0];
                break;
            elseif ~status2
                u2(i,:) = v2;
                u3(i,:) = [0 0 -1];
                p(i, :) = 2*v2 + [Lx(j), Ly(j), 0];
                break;
            else
                fprintf('\nThe Ray Casting did not find an outside point');
            end
        else
            if status1
                u2(i,:) = v1;
                u3(i,:) = [0 0 1];
                p(i, :) = 2*v1 + [Lx(j), Ly(j), 0];
                break;
            elseif status2
                u2(i,:) = v2;
                u3(i,:) = [0 0 -1];
                p(i, :) = 2*v2 + [Lx(j), Ly(j), 0];
                break;
            else
                fprintf('\nThe Ray Casting did not find an inside point');
            end
        end
        
        fprintf('\n++++++++++++++++++++++++++++++++++++++++++++++++++++');
        %error('The Ray Casting really did not find an inside point');
    end % End of RayCasting for-loop
    
    % Determine the direction of the cut
    % For a group that is on the inside, the third component in the cross
    % product should be negative. This results in a CCW cut which is
    % preferable.
    % For a group that is on the outside, the thirch component should be
    % negative as well.
    % Confusing... I know, but this is how the apple falls.
    
    di = cross(u1(i,:), u2(i,:));
    
    if di(3) > 0
        kerf{i}{1} = i;
        kerf{i}{2} = fliplr(Lx);
        kerf{i}{3} = fliplr(Ly);
        kerf{i}{4} = -u3(i, :);
        kerf{i}{5} = 'FLIP';
    elseif di(3) < 0
        kerf{i}{1} = i;
        kerf{i}{2} = Lx;
        kerf{i}{3} = Ly;
        kerf{i}{4} = u3(i, :);
        kerf{i}{5} = 'KEEP';
    end
end

% Now we will deal with the kerf width... Finally.
% ------------------------------------------------

% This code is for the kerf width of the data array
% ---------

% Probably the first thing we should do is apply the direction changes
% calculated in the previous for-loop

for i = 1:col
    [~, cols] = size(tmp_data{i});
    
    if strcmp(kerf{i}{5}, 'FLIP')
        tmp_data{i} = fliplr(tmp_data{i});
        
        if cols > 1
            for j = 1:cols
                if strcmp(tmp_data{i}{j}{2}, 'LINE')
                    vec1 = [tmp_data{i}{j}{3} tmp_data{i}{j}{4}];
                    vec2 = [tmp_data{i}{j}{5} tmp_data{i}{j}{6}];
                    tmp_data{i}{j}{3} = vec2(1);
                    tmp_data{i}{j}{4} = vec2(2);
                    tmp_data{i}{j}{5} = vec1(1);
                    tmp_data{i}{j}{6} = vec1(2);
                elseif strcmp(tmp_data{i}{j}{2}, 'ARC')
                    vec1 = [tmp_data{i}{j}{3} tmp_data{i}{j}{4}];
                    vec2 = [tmp_data{i}{j}{5} tmp_data{i}{j}{6}];
                    tmp_data{i}{j}{3} = vec2(1);
                    tmp_data{i}{j}{4} = vec2(2);
                    tmp_data{i}{j}{5} = vec1(1);
                    tmp_data{i}{j}{6} = vec1(2);

                    if strcmp(tmp_data{i}{j}{8}, 'CW')
                        tmp_data{i}{j}{8} = 'CCW';
                    elseif strcmp(tmp_data{i}{j}{8}, 'CCW')
                        tmp_data{i}{j}{8} = 'CW';
                    end
                end
            end
        end
    end
    
    if strcmp(tmp_data{i}{1}{2}, 'CIRCLE')
        if i == col
            tmp_data{i}{1}{6} = 'CW';
        else
            tmp_data{i}{1}{6} = 'CCW';
        end
    end
end % End of for-loop

% Now we can apply the offset to the data cell array

%fprintf('This is the number of coloms %d', col);
%pause

for i = 1:col
    [~, cols] = size(tmp_data{i});

    for j = 1:cols
        if strcmp(tmp_data{i}{j}{2}, 'LINE')
            vec1 = [tmp_data{i}{j}{3} tmp_data{i}{j}{4} 0];
            vec2 = [tmp_data{i}{j}{5} tmp_data{i}{j}{6} 0];
            dif = vec1 - vec2;
            dif = dif/(dot(dif, dif))^0.5;
            v = t_offset*cross(dif, kerf{i}{4});
            tmp_data{i}{j}{3} = vec1(1) + v(1);
            tmp_data{i}{j}{4} = vec1(2) + v(2);
            tmp_data{i}{j}{5} = vec2(1) + v(1);
            tmp_data{i}{j}{6} = vec2(2) + v(2);
        elseif strcmp(tmp_data{i}{j}{2}, 'ARC')
            vec1 = [tmp_data{i}{j}{3} tmp_data{i}{j}{4} 0];
            vec2 = [tmp_data{i}{j}{5} tmp_data{i}{j}{6} 0];
            vec3 = [tmp_data{i}{j}{9} tmp_data{i}{j}{10} 0];
            dif1 = vec3 - vec1;
            dif2 = vec3 - vec2;
            dif1 = dif1/(dot(dif1, dif1))^0.5;
            dif2 = dif2/(dot(dif2, dif2))^0.5;
            if strcmp(tmp_data{i}{j}{8}, 'CCW')
                multi = 1;
            else
                multi = -1;
            end
            v1 = dif1*t_offset*multi;
            v2 = dif2*t_offset*multi;
            tmp_data{i}{j}{3} = vec1(1) + v1(1);
            tmp_data{i}{j}{4} = vec1(2) + v1(2);
            tmp_data{i}{j}{5} = vec2(1) + v2(1);
            tmp_data{i}{j}{6} = vec2(2) + v2(2);
            tmp_data{i}{j}{7} = tmp_data{i}{j}{7} - t_offset * multi;
        elseif strcmp(tmp_data{i}{j}{2}, 'CIRCLE')
            if strcmp(tmp_data{i}{j}{6}, 'CCW')
                multi = 1;
            else
                multi = -1;
            end
            tmp_data{i}{j}{5} = tmp_data{i}{j}{5} - t_offset * multi;
        end
    end % End of for-loop
end % End of for-loop




% This code is for kerf width of the points array
% ---------
kerf_added = cell(1, blocks); 
% This will a biit inefficient, but what can you do...

for i = 1:blocks
    % First save the data into new variables
    Lx = kerf{i}{2};
    Ly = kerf{i}{3};
    
    % Now we can determine the size of the vector
    [~, col] = size(Lx);
    
    % Create the new variables
    Lx_new = [];
    Ly_new = [];
    
    % Now for the for-loop within a for-loop 
    for u = 1:col 
        % Lets first define the points in the vector from which we will
        % create the unit vetors from.
        if u == 1
            uvi1 = col - 1;   % This is for the first vector to the left
        else
            uvi1 = u - 1;
        end
        
        if u == col
            uvi2 = 2;         % this is for the second vector tot the right
        else
            uvi2 = u + 1;
        end    
        
        % Now we can start creating the unit vectors
        x1 = Lx(uvi1) - Lx(u);
        y1 = Ly(uvi1) - Ly(u);
        
        x2 = Lx(uvi2) - Lx(u);
        y2 = Ly(uvi2) - Ly(u);      
        
        L1 = sqrt(x1^2 + y1^2);
        L2 = sqrt(x2^2 + y2^2);
        
        uv1 = [x1 y1 0] / L1;
        uv2 = [x2 y2 0] / L2;
        
        % Now we calculate the angle between the two vectors
        angle = acosd(dot(uv1, uv2));
        
        vec = cross(uv1, uv2);
        x_temp = [];
        y_temp = [];
        
        if vec(3) > 0
            if angle < 120
                % Now I am creating the vectors perpendicular to uv1
                % and uv2
                vec1 = cross(uv1, kerf{i}{4});
                vec2 = cross(uv2, -kerf{i}{4});

                % Now I am making unit vectors of them and inserting
                % the kerf width all at once, yay!!
                vec3 = (vec1/dot(vec1, vec1)) * t_offset;
                vec4 = (vec2/dot(vec2, vec2)) * t_offset;

                % Now lets generate the actual points
                p1 = [Lx(u) + vec3(1), Ly(u) + vec3(2)];
                p2 = [Lx(u) + vec4(1), Ly(u) + vec4(2)];

                % Now I am saving the values
                x_temp = [x_temp p1(1) p2(1)];
                y_temp = [y_temp p1(2) p2(2)];
            else
                % Add the two vectors, then flip them in the other
                % direction
                vec1 = -1 * (uv1 + uv2);
                s = t_offset / sind(angle / 2);
                vec2 = (vec1 / sqrt(dot(vec1, vec1))) * s; 
                p1 = vec2(1:2) + [Lx(u) Ly(u)];
                x_temp = [x_temp p1(1)];
                y_temp = [y_temp p1(2)];
            end
        elseif vec(3) < 0
            % We do not need to check for the angle here due to the
            % shape of the lines
            vec1 = uv1 + uv2; 
            s = t_offset / sind(angle / 2);
            vec2 = (vec1 / sqrt(dot(vec1, vec1))) * s;
            p1 = vec2(1:2) + [Lx(u) Ly(u)];
            x_temp = [x_temp p1(1)];
            y_temp = [y_temp p1(2)];
        elseif vec(3) == 0
            continue;
        else
            error('Something is wrong with adding the kerf width!!')
        end

        
        Lx_new = [Lx_new x_temp];
        Ly_new = [Ly_new y_temp];
    end % End of inner for-loop for the kerf width
    
    kerf_added{i}{1} = kerf{i}{1};
    kerf_added{i}{2} = Lx_new;
    kerf_added{i}{3} = Ly_new;
end % End of for loop for the kerf width
end



function [status] = RayCasting(x, y, Lx, Ly)
% This function will test whether a point is inside or outside the polygon.


% x, y -- x and y coordinates of point
% a list of tuples [(x, y), (x, y), ...]
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