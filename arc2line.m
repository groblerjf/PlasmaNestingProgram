function [x, y] = arc2line(data, seg)

if nargin == 1
    seg = 1.5;
end

r = data{7};
x_cen = data{9};
y_cen = data{10};
dir = data{8};

if strcmp(dir, 'CW')
    a_start = data{12};
    a_end = data{11};
else
    a_start = data{11};
    a_end = data{12};
end

% Using aproximately 0.5 mm segments for the x y coordinates of the arc
alpha = seg / r;
alpha = 180 * (alpha) / pi;

if a_start == 0 && a_end > 180
    a_start = 360;
elseif a_end == 0 && a_start > 180
    a_end = 360;
end

if strcmp(dir, 'CW')
    tmp = a_start;
    a_start = a_end;
    a_end = tmp;
    
    if a_end > a_start
        a_end = a_end - 360;
    end
end

if strcmp(dir, 'CCW')
    if a_start > a_end
        a_end = a_end + 360;
    end
end

div = ceil(abs((a_end - a_start)/alpha));
if div == 1; div = 2; end
v1 = linspace(a_start, a_end, div);

col = length(v1);

x = zeros(1, col);
y = zeros(1, col);

for i = 1:col
    x(i) = x_cen + r*cosd(v1(i));
    y(i) = y_cen + r*sind(v1(i));
end

end