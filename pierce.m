function [Pierce_Feed, travel ] = pierce(thickness)
% In order to avoid other complex hardware in the final system, as well as
% to protect the nozzles of the cutter, I will use a piercing method of
% decreasing height.
% In other words, the machine will position the nozzle a certain a height
% above the plate, start piercing, and gradually move the nozzle closer to
% the plate until the final height is reached.
%
% I will test this, but I suspect that there is a correlation between the
% cutting speed and the piercing speed.
%
%% (ART CNC MACHINES Youtube Channel)
% ----------------- Piercing Hight ---------------
% After some recearch, I found a youtube video explaining some of the basic
% pierce methods out there. The person gave a general piercing time of
% about 0.4 - 0.7 for thinner materials, and higher for thicker materials.
% He also gave a general pierce hight estimation of at least 3 mm up to 8
% mm. He stated a rule of thumb that he uses to make the pierce hight the
% thickness of the material.
% |
% Ref: http://www.youtube.com/watch?v=XKRi7jPLD2I
%
% ----------------- Leadin --------------------
% The same guy had another theory about about leadins, stating that the arc
% leadin, with regards to plasma, would generally give you a notch in the
% final parts whereas the strain line lead in has a less visible effect.
% |
% Ref: http://www.youtube.com/watch?v=adhASbhDn3k
%
% ------------------ Cut Height --------------------
% Cut height about 1.5 - 3 mm depending on material. Make 2 mmm. Same
% Youtube guy. 
%
% Ref: http://www.youtube.com/watch?v=jcwekawVWKc
%
% ****************** Note: Data is for Hypertherm Cutter ******************


%% Pierce Algorithm

% The cut hight is 2 mm. This is the value that the Ultrasonic Sensor will
% stop at during the initial plunge.
%
% Since the z-axis position is not precise, incremental G91 commands will
% be used.

Cut_Height = 2;

% Piercing Heght

Pierce_Height = 2 * thickness;

if Pierce_Height > 9
    Pierce_Height = 9;
end

% z-axis travel distance
travel = Pierce_Height - Cut_Height;

if travel < 0
    travel = 0;
end

% Pierce Feed rate
% Using the same formula for piercing as cutting speed, let see if there is
% in fact a correlation.

% Cutting Speed Formula
feedrate = 11080 * exp(-0.3665 * thickness);

% Piercing Furmula
%travel = (11080/(60*a)) * exp(-0.3665*b*t) * time

z = [1 2 4 6];
y = [0.4 0.5 0.6 0.7];
x = [1.5 2 3 4];


% After doing some emperical calculations to see what the value a should be
% I came to the following formula.

% a = 312.5*exp(-1.222*thickness)

%% emperical results
% Ex 1
% feedrate = 11080 * exp(-0.3665 * 1.5)
% 
% feedrate = 6.3942e+03
% 
% feedrate/60 = 106.5700 (Feed per seconde
% 
% 106.57/50 = 2.1314 (Feed after applied factor)
% 
% 2.1314*0.4 = 0.8526 (Calculated travle of z-axis
% 
% Ex 2
% feedrate = 11080 * exp(-0.3665 * 3)
% 
% feedrate = 3.6901e+03
% 
% feedrate/60 = 61.5009
% 
% ans/8 = 7.6876
% 
% ans*0.5 = 3.8438

%% feed formula for piercing

% Pierce_Feed = (35.456/exp(-1.222*thickness))*exp(-0.3665*thickness)
% Pierce_Feed = 

%%  -----------------------------------------------------------------------
%% Different Approach using same data table as for the feed rate formula

% Using data from thermal dynamics
delay = [0 0 0 0.5 0.5 1 1.5];
thick = [0.9 1.5 3.4 4.6 6.4 9.5 12.7];


% We get the following formula
delay_C = 0.1217 * exp(0.2017 * thickness);

% Now that we can calculate the delay requied as well as the pirce
% height(travel acutally)

% Pierce_Feed [mm/min] = travel [mm] / delay_C [s] * 60

% ============================ Final Formula ==============================

Pierce_Feed = (travel / delay_C) * 60;

Pierce_Feed = round(Pierce_Feed);




















end

