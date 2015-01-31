function [data1] = sortData(data)
% This function will take the random entity data that were extracted from
% the .DXF file and sort them into a logical sequence. The function will
% also the group the entities into the different shapes of the drawing.

% Along with the sorting, the program will assign a group number. 

[ded, col] = size(data);

group = 1;
new_group = 1;
end_loop = 0;
value_reset = 1;
x_end  = 0.0;
y_end = 0.0;
trouble_shoot = 0;

for i = 1:col

    % full circle is already a group, it does not need coordinate
    % sequencing
    if isempty(data{i})
        continue;
    end
  
    if strcmp(data{i}{1}, 'CIRCLE') && new_group
        data{i} = [group, data{i}];
        group  = group + 1;
        new_group = 1;
        continue;
    end
    
    % only one needs to be true for us to cont.
    if max(strcmp(data{i}{1}, {'LINE', 'ARC'}))
            
        % Save the current position
        if end_loop
            data{i} = [group, data{i}];
            group  = group + 1;
            end_loop = 0;
            new_group = 1;
            continue;
        else
            data{i} = [group, data{i}];
            new_group = 0;
        end
        
        % Test for new_block condition
        if value_reset
            x_end = data{i}{3};
            y_end = data{i}{4};
            value_reset = 0;
        end
        
        if trouble_shoot
            disp('Line for reference');
            disp(data{i});
        end
        
        % We need to create a reference point in order organize the data.
        % We are working with a swap environment and this is to prevent
        % data loss
        ref = data{i+1};
        
        for u = i+1:col
            if trouble_shoot
                disp('Current');
                disp(data{u});
            end
            
            err = 1e-4; % The allowable error between points
                               
            % Only LINE and ARC can pass here
            if max(strcmp(data{u}{1}, {'LINE', 'ARC'}))
                % First check whether we can add to the block
                % ---------------------------------------------------------
                if abs(data{u}{2} - data{i}{5}) < err && abs(data{u}{3} - data{i}{6}) < err
                    if trouble_shoot
                        disp('In Order');
                    end
                    % swap the data lines
                    if u ~= i+1
                        data{i+1} = data{u};
                        data{u} = ref;
                    end
                    
                    if abs(x_end - data{i+1}{4}) < err && abs(y_end - data{i+1}{5}) < err
                        end_loop = 1;
                        value_reset = 1;
                        new_group = 1;
                        break; %There should only be one possible match
                    end
                   break; %There should only be one possible match
                end
                
                if trouble_shoot
                    disp('Skipped in order if');
                end
                % Here we need to swap the data points
                if abs(data{u}{4} - data{i}{5}) < err && abs(data{u}{5} - data{i}{6}) < err
                    if trouble_shoot
                        disp('Out of Order');
                    end
                    % swap the data points
                    x_temp1 = data{u}{2};
                    y_temp1 = data{u}{3};
                    x_temp2 = data{u}{4};
                    y_temp2 = data{u}{5};
                    data{u}{2} = x_temp2;
                    data{u}{3} = y_temp2;
                    data{u}{4} = x_temp1;
                    data{u}{5} = y_temp1;
                    
                    % change the arc rotation direction
                    if strcmp(data{u}{1}, 'ARC')
                        data{u}{7} = 'CW';
                        tmpArc = data{u}{10};
                        data{u}{10} = data{u}{11};
                        data{u}{11} = tmpArc;
                    end
                    
                    % swap the data lines
                    if u ~= i+1
                        data{i+1} = data{u};
                        data{u} = ref;
                    end

                    if abs(x_end - data{i+1}{4}) < err && abs(y_end - data{i+1}{5}) < err
                        end_loop = 1;
                        value_reset = 1;
                        new_group = 1;
                        break; %There should only be one possible match
                    end
                   break; %There should only be one possible match
                end
                if trouble_shoot
                    disp('Skipped both ifs');
                end
                % ---------------------------------------------------------
                              
            end
            
        end
    end
    
end
% Save the information about the groups
groupcount = {group - 1};
data1 = [data {groupcount}];
end