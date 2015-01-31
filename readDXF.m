function [data] = readDXF(filename, MT)
% This function will read the DXF file and extrat the necessary data from
% the ENTITIES section

fid = fopen(filename, 'r');

start = 0;

data = [];
count = 1;

while(~feof(fid))
    
    line1 = textscan(fid, '%s', 1, 'delimiter', '\n');
    comp = line1{1}{1};
    
    if strcmp(comp, 'ENTITIES')&&~feof(fid)
        start = 1;
    end

    
    if start
        if strcmp(comp, 'CIRCLE')
            [circled, fid, save] = readCircle(fid, MT);
            %fprintf('\nCIRCLE');
            if save
                data{count} = circled;
                count = count + 1;
            end
            continue;
        end

        if strcmp(comp, 'LINE')
            [lined, fid] = readLine(fid);
            %fprintf('\nLINE');
            data{count} = lined;
            count = count + 1;
            continue;
        end

        if strcmp(comp, 'ARC')
            %fprintf('\nARC');
            [arcd, fid] = readArc(fid);
            data{count} = arcd;
            count = count + 1;
            continue;
        end
        
        if strcmp(comp, 'SPLINE')
            [splined, fid] = readSpline(fid);
            %fprintf('\nSPLINE');
 
            for i = 1:length(splined)
                data{count} = splined{i};
                count = count + 1;
            end
            continue;
        end
    end

    
    if strcmp(comp, 'ENDSEC')&&start&&~feof(fid)
        break;
    end
end    
fclose('all');
clear fid;
end



function [result, fid] = readLine(fid)

result = [];
ent = 0;
cont = 0;
brk = 0;

while(~feof(fid))
    
    line = textscan(fid, '%s', 1, 'delimiter', '\n');
    
    if strcmp(line{1}{1}, 'AcDbEntity')
        ent = 1;
    end
    
    if strcmp(line{1}{1}, 'Continuous') && ent
        cont = 1;
    end
    
    if strcmp(line{1}{1}, 'AcDbLine') && ~cont
        break;
    end
    
    if strcmp(line{1}{1}, 'AcDbLine') && cont
        Ct = textscan(fid, '%f', 12, 'delimiter', '\n');
        C = {'LINE', Ct{1}(2), Ct{1}(4), Ct{1}(8), Ct{1}(10)};
        result = C;
        brk = 1;
    end
    
    if brk
        break;
    end
    
end    

end

% Here follows the readCircle function

function [result, fid, save] = readCircle(fid, MT)

ent = 0;
cont = 0;
brk = 0;

while(~feof(fid))
    
    line = textscan(fid, '%s', 1, 'delimiter', '\n');
    
    if strcmp(line{1}{1}, 'AcDbEntity')
        ent = 1;
    end
    
    if strcmp(line{1}{1}, 'Continuous') && ent
        cont = 1;
    end
    
    if strcmp(line{1}{1}, 'AcDbCircle') && ~cont
        break;
    end
    
    if strcmp(line{1}{1}, 'AcDbCircle') && cont
        Ct = textscan(fid, '%f', 8, 'delimiter', '\n');
        C = {'CIRCLE', Ct{1}(2), Ct{1}(4), Ct{1}(8)};
        result = C;
        brk = 1;
        
        if Ct{1}(8) < 0.6*MT
            save = 0;
        else
            save = 1;
        end
    end
    
    if brk
        break;
    end
    
end    

end

% Here follows the readArc function

function [result, fid] = readArc(fid)

ent = 0;  % go for AcDbEntity
cont = 0; % go for continouos line
arc = 0;  % go for arc
brk = 0;  % break loop

position = [];

while(~feof(fid))
    
    line1 = textscan(fid, '%s', 1, 'delimiter', '\n');
    comp = '';
    
    try       
    comp = line1{1}{1};
    catch err
        if (strcmp(err.identifier, 'MATLAB:badsubscript'))
            break;
        end           
    end
    
    if strcmp(comp, 'AcDbEntity')
        ent = 1;
    end
    
    if strcmp(comp, 'Continuous') && (ent)
        cont = 1;
    end
    
    if strcmp(comp, 'AcDbCircle') && ~cont
        break;
    end
    
    if strcmp(comp, 'AcDbCircle') && cont
        Ct = textscan(fid, '%f', 8, 'delimiter', '\n');
        cont = 0;
        arc = 1;
        position = {'ARC', Ct{1}(2), Ct{1}(4), Ct{1}(8)};
    end
    
    if strcmp(comp, 'AcDbArc') && arc
        Ct = textscan(fid, '%f', 4, 'delimiter', '\n');
        position = [position, {Ct{1}(2)}, {Ct{1}(4)}];
        brk = 1;
    end
    
    if brk
        break;
    end
end
disp(position);
x_start = position{2} + position{4}*cosd(position{5});
y_start = position{3} + position{4}*sind(position{5});
x_end = position{2} + position{4}*cosd(position{6});
y_end = position{3} + position{4}*sind(position{6});

result = {'ARC', x_start, y_start, x_end, y_end, position{4}, 'CCW', position{2}, position{3}, position{5}, position{6}};
end


function [result, fid] = readSpline(fid)


result = [];
ent = 0;
cont = 0;
brk = 0;

while(~feof(fid))
    
    line = textscan(fid, '%s', 1, 'delimiter', '\n');
    
    if strcmp(line{1}{1}, 'AcDbEntity')
        ent = 1;
    end
    
    if strcmp(line{1}{1}, 'Continuous') && ent
        cont = 1;
    end
    
    if strcmp(line{1}{1}, 'AcDbSpline') && ~cont
        break;
    end
    
    if strcmp(line{1}{1}, 'AcDbSpline') && cont
        fprintf('\nEntered the layer');
        C1 = textscan(fid, '%s', 1, 'delimiter', '\n'); % X Normal Vector
        C2 = textscan(fid, '%s', 1, 'delimiter', '\n');
        C3 = textscan(fid, '%s', 1, 'delimiter', '\n'); % Y Normal Vector
        C4 = textscan(fid, '%s', 1, 'delimiter', '\n');
        C5 = textscan(fid, '%s', 1, 'delimiter', '\n'); % Z Normal Vector
        C6 = textscan(fid, '%s', 1, 'delimiter', '\n');
        C7 = textscan(fid, '%s', 14, 'delimiter', '\n');
       
        if ~strcmp(C6{1}, '1.0')
            break;
        end
        
        fprintf('\nI see the dragon\n');
        
        D = {};
        counter = 1;
        while(~feof(fid))
            tmp = textscan(fid, '%s', 1, 'delimiter', '\n');
            D{counter} = tmp{1};
           
            if strcmp('0', D{counter}{1})
                break;
            end
           
            counter = counter + 1;
        end
        
        % Location of x/y-values
        [ded, col] = size(D);
             
        xstring = zeros(1, col);
        ystring = zeros(1, col);
        
        for i = 1:col
            xstring(i) = strcmp('10', D{i});
            ystring(i) = strcmp('20', D{i});
        end
        
        xid = find(xstring == 1) + 1;
        yid = find(ystring == 1) + 1;
        
        col = length(xid);
        xval = zeros(1, col);
        yval = zeros(1, col);
        
        for i = 1:col
            xval(i) = str2double(D{xid(i)});
            yval(i) = str2double(D{yid(i)});
        end

        
        C = cell(col-1);
        
        for i = 1:(col - 1)
            C{i} = {'LINE', xval(i), yval(i), xval(i + 1), yval(i + 1)};
        end
        
        result = C;
        brk = 1;
    end
    
    if brk
        break;
    end
    
end 

end % End of function readSpline