function [x, y] = circle2line(data)
% This function converts a circle to a bunch of lines

r = data{5};
x_cen = data{3};
y_cen = data{4};

% Using aproximately 1.5 mm segments for the x y coordinates of the arc
alpha = 1 / r;
alpha = 180 * (alpha) / pi;

divisions = 360/alpha;
v1 = linspace(0, 360, divisions);

col = length(v1);

x = zeros(1, col);
y = zeros(1, col);

for i = 1:col
    x(i) = x_cen + r*cosd(v1(i));
    y(i) = y_cen + r*sind(v1(i));
end
end