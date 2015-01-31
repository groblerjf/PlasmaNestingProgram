function [areas, points] = sequence(areas, points)
% This function will determine the shortest sequence time for the internal
% blocks as well as determine the block that is on the outside.

% To determine the sequence of the internal blocks, the function will
% determine the block with the closest distance to the origen. After that
% first point is determined, the function will then work on the same
% principle as a car GPS. is will determine the shortest route possible
% with a bunch of stops. Also, it is not necessary to use the center point
% of the groups since it is the starting point that the torch will travel
% too.

% -------------------------------------------------------------------------
% The first step is to determine the outside block and put it last.
% -------------------------------------------------------------------------
[row, ded] = size(areas);

area = 0;
index = 1;

for i = 1:row
    if areas(i, 2) > area
        area = areas(i,2);
        index = i;
    end
end

for p = 1:row
    disp(points{p}{2}(1));
end

%index = find(areas(:, 2) == max(areas(:,2)));

tmp = areas(row, :);
areas(row, :) = areas(index, :);
areas(index, :) = tmp;

tmp1 = points{row}{2};
tmp2 = points{row}{3};
points{row}{2} = points{index}{2};
points{row}{3} = points{index}{3};
points{index}{2} = tmp1;
points{index}{3} = tmp2;
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% The second step is to sequence the included blocks. There are a few ways
% to execute this phase but the best will only become visible once actual
% testing begins.
%
% *** The solution presented below is just a crude solutin until I can
% implement the algorithm derived from the traveling salesman problem.

% The implementation will be a crude path. I will start at the origen, and
% then determine the nearest next point. Another approach together with
% this one is to determine the distance between the end point of the last
% group with those of the other inside groups.

% Another solution of coarse is to shift the starting points of the groups
% to the optimal position and so forth.1                                                                                                                                                                        

% Until this point the starting point of each vector in the points cell is
% equal to the end point because there is no intro cut yet.

% I will now determine the distance between each point and the origen,
% between each point and the end point, as well as the distance between
% each of the points.

% To make things easier I will save each point in a matrix first, the first
% point in the matrix will be the origen.
% 
% [row, col] = size(points);
% punte = zeros(col + 1,3);
% 
% for i = 1:col
%     punte(i + 1, 2:3) = [points{i}{2}(1), points{i}{3}(1)];
%     punte(i + 1, 1) = i;
% end
% 
% %distances = zeros(col+2);
% 
% disp(punte);
% 
% % -------------------------------------------------------------------------
% % The following code will determine closet point.
% 
% index = 0;   % The default index
% point = [];
% 
% for i = 1:col-1
%     ddis = 4000;
%     % Calculate the length
%     ref = punte(i, 2:3);
%     
%     for j = (i+1):col
%         diff = ref - punte(j, 2:3);
%         dis = sqrt(dot(diff, diff));
%         
%         if dis < ddis
%             ddis = dis;
%             index = j;
%             point = punte(j, :);
%         end
%     end
%     
%     tmp = punte(i+1, :);
%     punte(i+1, :) = point;
%     punte(index, :) = tmp;
% end
% 
% disp(punte);
% 
% % Now that this is done we can apply the changes to the points cell-array
% % We also need to modify the areas array
% 
% pointer = cell(1, col);
% arr = zeros(col, 3);
% punte(1, :) = [];
% disp(punte);
% 
% for i = 1:col
%     index = round(punte(i, 1));
%     tmp = {i, points{index}{2}, points{index}{3}};
%     atmp = areas(index, :);
%     pointer{i} = tmp;
%     arr(i, 1:3) = atmp(1:3);
% end
% 
% points = pointer;
% 
% for i = 1:col
%     disp(pointer{i});
% end

% -------------------------------------------------------------------------


% It is expected that the diagonal be zero, since the distance between a
% point and itself is zero.

% [row, coll] = size(distances);
% 
% distances(end, 1:(coll - 1)) = 0:1:col;
% distances(1:row-1, coll) = 0:1:col;
% 
% for i = 1:row-1
%     for u = 1:(coll - 1)
%         vec = [(punte(i, 1) - punte(u, 1)), (punte(i, 2) - punte(u, 2))];
%         distances(i, u) = (dot(vec, vec))^0.5;
%     end
% end
% 
% %distances = triu(distances);
% 
% disp(round(distances));

% The ultimate will be to add some sort of weighting factor, but that is
% for later iterations.

% Ok so after looking at the matrix I will use the following approach. I
% will determine the closest point to the origen, that is a given, it
% should be first.

% Next I will take that point as te reference point and select the three
% closet points, it there is three, and so on with those points. I will
% then select the shortest path, and move to the following point, but I
% only advance one point. Then the whole process is repeated.

% Awe well that is the intended plan.


% The number sequece to be saved
% seq = zeros(1, col);
% seq(end) = col;

%distances(:, end-1)= [];
%distances(end, :) = [];


% 
% index2 = find(distances(1,:) > 0);
% index3 = find(distances(1, index2) == min(distances(1, index2)));
% seq(1) = distances(1, index3(1));
% distances(:, 1) = [];
% distances(1, :) = [];
% disp(round(distances));
% 
% [row, col] = size(distances);
% count = 2;
%  
%  while(col > 1)
%      index1 = find(distances(row, :) == distances(end, index3(1)));
%      index2 = find(distances(:, index1(1) > 0));
%      index3 = find(distances(index2, index1(1)) == min(distances(index2, index1(1))));
%      seq(count) = distances(index3(1), end);
%      count = count + 1;
%      distances(index1(1), :) = [];
%      distances(:, index1(1)) = [];
%      disp(round(distances));
%      [row, col] = size(distances);
%  end
% 
% disp('The sequence');
% disp(seq);



% 
% sizes = abs(areas(1:row-1, 3) + i*areas(1:row-1, 4));
% 
% low_high = sort(sizes);
% lh_index = zeros(1, row-1);
% for i = 1:row-1
%     lh_index(i) = find(sizes == low_high(i));
% end
% 
% areas(1:row-1, :) = areas(lh_index, :);
% points(1:row-1) = points(lh_index);
% 

% Now the inside groups should be sorted, although this is a very crude
% sequence it is the one that we will use.




end % End of the function