function [done] = pCon(vec, z, arc)
% The lower z is the slower the machine becomes.
% This function will allow the control of the machine without a GUI
    [control, error] = stepGen(vec, arc);
    length(control)
    
    disp('Error present');
    disp(error)

    % Lets send the code
    s = 10000/z;
    parport = digitalio('parallel',1);
    lines = addline(parport,0:7,'out');
    putvalue(parport,dec2binvec(0,8))
    
    for n = 1:length(control)
        %control(n, :);
        putvalue(parport,control(n, :));
        for q = 1:s;end
    end
    putvalue(parport,dec2binvec(0,8))
    delete(parport);
    clear parport;
    
    done = 1;

end % End of function pCon