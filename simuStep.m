function simuStep(control)

% This function will simulate the steps generated by 'partPath' this is to
% ensure that everything is alright.

[row, col] = size(control);

% Direction Standards
xdir = 1;
ydir = 0;
zdir = 0;

% Ccalibration
step = 0.024997;

xpos = 0;
ypos = 0;
zpos = 0;

figure(1)
hold on
xlabel('X-AXIS')
ylabel('Y-AXIS')
zlabel('Z-AXIS')


% This is a temp value in order to save space
tmp = [0 0 0];

color = 'br';

poson = zeros(row, 3);
posoff = zeros(row, 3);

for i = 1:row
    
    brk1 = 0;
    brk2 = 0;
    brk3 = 0;
    
    vec = control(i, :);
    
    if vec(2)
        xpl = -1;
    else
        xpl = 1;
    end
    
    xpos = xpos + xpl*vec(1)*step;
    
    if vec(4)
        ypl = 1;
    else
        ypl = -1;
    end
    
    ypos = ypos + ypl*vec(3)*step;
    
    if vec(6)
        zpl = 1;
    else
        zpl = -1;
    end
    
    zpos = zpos + zpl*vec(5)*step;
    
%     if xpos-tmp(1)<1e-4 && ypos-tmp(2)<1e-4 && zpos-tmp(3)<1e-4
%         continue;
%     end
    
    if vec(8) 
        poson(i, :) = [xpos ypos zpos]; 
    else
        posoff(i, :) = [xpos ypos zpos]; 
    end
    
    %tmp = [xpos ypos zpos];
    %M(i) = getframe;
    
end % End of for-loop


%movie(M, 2)


plot3(poson(:,1), poson(:,2), poson(:,3), 'r.')
plot3(posoff(:,1), posoff(:,2), posoff(:,3), 'b.')
grid on
axis equal
hold off

end % End of function simuStep