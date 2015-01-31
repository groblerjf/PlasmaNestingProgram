%% This script is a shorcut to bypass the GUI

disp('Lets do some processing');

    file = 'C:\Documents and Settings\Theunis\Desktop\Plasma Cutting\Disk Brake.DXF';
    MT = 1.6;
    IntroCut = 'Arc';
    Offset = '0';


    % Here follows the Code to decode the DXF file
    % -------------------------------------------------------------------------
    % Read the DXF file
    rawdata = readDXF(file, MT);

    %col = length(rawdata);
    
    %for i = 1:col
    %    disp(rawdata{i});
    %end
  
    
    % Sort the data
    % This function will check whether the holes in the part can be cut as well. The
    % rule of thumb states that you cannot cut out a hole smaller than the
    % plate thickness. Therefore we will check for this condition before
    % continuing.
    sorted = sortData(rawdata);

    % Check for empty slots
    [ded, col] = size(sorted);

    data = [];
    count = 1;

    for i = 1:col
        if isempty(sorted{i})
            continue;
        else
            data{count} = sorted{i};
            count = count + 1;
        end
    end

    % Translate the drawing entities to the first quadrant
    [data, H, W] = translate(data);
    
    fprintf('\n\nPart Height: %d', H);
    fprintf('\nPart Width: %d', W);
    
    % Determine the Area of the groups
    [areas, points] = calcArea(data);

    % ** In the areas matrix, the centerpoint of the group is provided, but at
    % the moment it is not used, this is something that needs to be looked at.

    % Determine the sequence of the cuts
    [in_order, punte] = sequence(areas, points);

    % ** The sequence program may be buggy since it was last modified.

    data = applyOrder(data, in_order);

    % Apply the Sequence of the cuts
    [ded, col] = size(punte);

     for i = 1:col
         punte{i}{1} = i;
         in_order(i, 1) = i;
     end

     xlabel('X-AXIS')
     ylabel('Y-AXIS')
     axis([-2 (W+5) -2 (H+5)])
     hold on
     cla
     for i = 1:col
         pl1 = plot(punte{i}{2}, punte{i}{3}, '-.b');
     end
     axis equal
     legend('Part')
     hold off
     % Now we need to account for the kerf-width and the additional offset. The
     % data cell array, will remain the base line for our endevours. Yet noting
     % will be modified, I will make a copy of the points cell array and modify
     % it from there onwards.

     % The funny thing now is that to account for kerf width, we need to use
     % the ray casting algorithm to determine the inside and outside of the
     % groups.

     kerf = kerfWidth(MT, punte, str2double(Offset));
     %kerf = punte;

     % Now we need to add the intro cut. Note that we cannot use the data
     % cell array anymore, since just above we have accounted for the kerfwidth
     % and it is just not worth calculating the ajustment for the data cell
     % array as well.

     if strcmp(IntroCut, 'Line')
         [intro_punte] = introLine(kerf, MT);
     elseif strcmp(IntroCut, 'Arc')
         [intro_punte] = introArc(kerf, MT);
     end

     [ded, col] = size(intro_punte);

     axis([-2 (W+10) -2 (H+10)])
     hold on
     for i = 1:col
         pl2 = plot(intro_punte{i}{2}, intro_punte{i}{3}, 'r');
     end
     legend([pl1, pl2],'Part', 'Cut Path')
     axis equal
     hold off
     
     figure(2)
     comet(intro_punte{5}{2}, intro_punte{5}{3})

     info = {file, MT, W, H};

     % Now we will generate the G-CODE
     [gcode] = gcodeGenerator(intro_punte, file(1:end-4), str2double(MT));
     save partcode.mat gcode intro_punte info
     
     % And we are done, lets hope this works.
     
     
     