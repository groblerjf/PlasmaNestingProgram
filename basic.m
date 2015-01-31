% Basic Program to communicate with the UNO
clear all;
close all;
clc;

s1 = serial('COM3');

fopen(s1);

pause(2);

while(1)
    %s1.BytesAvailable
    while(s1.BytesAvailable > 0)
        text = fscanf(s1);
        fprintf('%s\n', text(1:end-2));
    end
    
    task = input('Next Command: ', 's');
    
    if strcmp(task, 'q')
        break;
    end
    
    fprintf(s1, task)
    pause(1);
end



fclose(s1);
delete(s1);