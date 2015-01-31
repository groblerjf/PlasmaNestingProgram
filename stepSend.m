function [done] = stepSend(control, speed)

% This will essentially control CNC machine whether it is the part being
% cut or just some basic movement, this program will do the job.
%
% speed - the lower the value, the slower the the machine.

% This delay is a sort of speed limiter.
s = 15000/speed;


parport = digitalio('parallel',1);
lines = addline(parport,0:7,'out');

putvalue(parport,dec2binvec(0,8))
for n = 1:length(control)
    %control(n, :)
    putvalue(parport,control(n, :));
    for q = 1:s;end
end
putvalue(parport,dec2binvec(0,8))


done = 1;

end % End of the 'stepSend' function