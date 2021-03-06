function [cSpeed, aVol, pHeight, cHeight, pDelay] = PM45CuttingSpeeds(Amps, Thickness, Material, handles)
% This function will determine the corrent cutting speed for the machine as
% well as the correctarc voltage as well as the correct cutting hight and
% piercing distance.

if Amps == 30 || Amps == 45
    
else
    uiwait(msgbox('The Current selected is not valid', 'Warning', 'warn'));
end


S = load('PM45_Cut_Stats.mat');

if strcmp(Material, 'Mild Steel')
    stats = S.Mild;
elseif strcmp(Material, 'Stainless Steel')
    stats = S.Stainless;
elseif strcmp(Material, 'Aluminium')
    stats = S.Aluminium;
elseif strcmp(Material, 'Copper')
    stats = S.Copper;
end

if Thickness > 1.6 && Amps == 30
    Amps = 45;
    uiwait(msgbox('The amperage selected is too low for the plate thickness, selecting a higher current of 45 A', 'Caution', 'warn'));
    set(handles.CurrentName, 'String', '45');
end

if Amps == 30
    stats = stats(stats(:, 1) == 30, :);
elseif Amps == 45
    stats = stats(stats(:, 1) == 45, :);
end

pH = stats(:, 4);

cSpeed  = spline(stats(pH < 999999, 2), stats(pH < 999999, 6), Thickness);
aVol    = spline(stats(pH < 999999, 2), stats(pH < 999999, 7), Thickness);
pHeight = spline(stats(pH < 999999, 2), stats(pH < 999999, 4), Thickness);
cHeight = spline(stats(pH < 999999, 2), stats(pH < 999999, 3), Thickness);
pDelay  = spline(stats(pH < 999999, 2), stats(pH < 999999, 5), Thickness);


end % End of function