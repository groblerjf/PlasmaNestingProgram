function varargout = GUI_Interface(varargin)
% GUI_INTERFACE MATLAB code for GUI_Interface.fig
%      GUI_INTERFACE, by itself, creates a new GUI_INTERFACE or raises the existing
%      singleton*.
%
%      H = GUI_INTERFACE returns the handle to a new GUI_INTERFACE or the handle to
%      the existing singleton*.
%
%      GUI_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_INTERFACE.M with the given input arguments.
%
%      GUI_INTERFACE('Property','Value',...) creates a new GUI_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Interface

% Last Modified by GUIDE v2.5 31-Jan-2015 21:40:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Interface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_Interface is made visible.
function GUI_Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Interface (see VARARGIN)

% Choose default command line output for GUI_Interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes GUI_Interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% =========================================================================
% MENU ITEMS
% =========================================================================

function FileMenu_Callback(hObject, eventdata, handles)
function AboutMenu_Callback(hObject, eventdata, handles)

function OpenMenuItem_Callback(hObject, eventdata, handles)
    [file, filepath, filter] = uigetfile('*.dxf')
    
    files = [filepath, file];
    
    save filePro.mat files
    
    if ~isequal(file, 0)
        set(handles.filename, 'String', file);
    end
    set(handles.filename, 'String', file);
    %set(handles.filename, 'String', file);
    checkStatus(handles);
    cla(handles.PartDisplay);

    
% =========================================================================
% MATERIAL THICKNESS INPUT CODE
% =========================================================================

function MT_Input_Callback(hObject, eventdata, handles)
    % Hints: get(hObject,'String') returns contents of MT_Input as text
    %        str2double(get(hObject,'String')) returns contents of MT_Input as a double
    MT_Thickness = get(hObject, 'String');
    fprintf('Current Material Thickness: %s\n', MT_Thickness);
    if strcmp(MT_Thickness, '0')
        MT_Thickness = '';
    end
    type1 = get(handles.mtname, 'String');
    
    set(handles.mtname, 'String', MT_Thickness);
    
    type2 = get(handles.mtname, 'String');
    
    if ~strcmp(type1, type2);
        cla(handles.PartDisplay);
    end
    
    checkStatus(handles);

    
function MT_Input_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'String', 0);

    
% =========================================================================
% INTRO LINE CODE
% =========================================================================

function popupmenu1_Callback(hObject, eventdata, handles)
    % Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from popupmenu1

    IntroType = get(hObject, 'Value');
    
    type1 = get(handles.introname, 'String');
        
    switch IntroType
        case 2
            disp('Line Intro Cut');
            set(handles.introname, 'String', 'Line');
        case 3
            disp('Arc Intro Cut');
            set(handles.introname, 'String', 'Arc');
        otherwise
            set(handles.introname, 'String', '');
    end
    
    type2 = get(handles.introname, 'String');
    
    if ~strcmp(type1, type2)
        cla(handles.PartDisplay);
    end
    
    checkStatus(handles);
    % Important -- Make the default cut the Line Intro Cut.
    
function popupmenu1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function Offset_Callback(hObject, eventdata, handles)
    % Hints: get(hObject,'String') returns contents of Offset as text
    %        str2double(get(hObject,'String')) returns contents of Offset as a double
    set(handles.offsetname, 'String', get(hObject, 'String'));
    checkStatus(handles);


function Offset_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject, 'String', 0);
    
    

% --- Executes on selection change in materialSelect.
function materialSelect_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns materialSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from materialSelect
    Material = get(hObject, 'Value');
   
    switch Material 
        case 2
            disp('Mild Steel Selected');
            set(handles.MaterialName, 'String', 'Mild Steel');
        case 3
            disp('Stainless Steel Selected');
            set(handles.MaterialName, 'String', 'Stainless Steel');
        case 4
            disp('Aluminium Selected');
            set(handles.MaterialName, 'String', 'Aluminium');
        otherwise
            disp('Reverted to default State');
            set(handles.MaterialName, 'String', '');
    end
    
    checkStatus(handles);
        
            
% --- Executes during object creation, after setting all properties.
function materialSelect_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end    

    
% --- Executes on selection change in CurrentSelect.
function CurrentSelect_Callback(hObject, eventdata, handles)
    Current  = get(hObject, 'Value');
    
    switch Current
        case 2
            disp('30 Amps Selected');
            set(handles.CurrentName, 'String', '30');
        case 3
            disp('45 Amps Selected');
            set(handles.CurrentName, 'String', '45');
        otherwise
            set(handles.CurrentName, 'String', '');
    end
    
    checkStatus(handles);


% --- Executes during object creation, after setting all properties.
function CurrentSelect_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end    
    
    
    

% =========================================================================
% CODE TO PROCESS THE DXF'S
% =========================================================================

function genCut_Callback(hObject, eventdata, handles)
    genCut_ButtonDownFcn(hObject, eventdata, handles)
    
    
function genCut_ButtonDownFcn(hObject, eventdata, handles)

    disp('Lets do some processing');

    file = get(handles.filename, 'String');
    MT = get(handles.mtname, 'String');
    IntroCut = get(handles.introname, 'String');
    Offset = get(handles.offsetname, 'String');
    Current = get(handles.CurrentName, 'String');
    Material = get(handles.MaterialName, 'String');
    


    % Here follows the Code to decode the DXF file
    % -------------------------------------------------------------------------
    
    % Read the DXF file
    % Here we take the DXF file created by the CAD program and extract the
    % necessary information from it.
    load filePro.mat
    rawdata = readDXF(files, str2double(MT));
    

    
    
    % Sort the data
    % This function will check whether the holes in the part can be cut as well. The
    % rule of thumb states that you cannot cut out a hole smaller than the
    % plate thickness, but with the plasma cutter th Therefore we will check for this condition before
    % continuing.
    sorted = sortData(rawdata);

    
    
    % Check for empty slots
    % For some reason there randomly forms empty cells and we have to take
    % it out to avoid errors
    [~, col] = size(sorted);

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
    % since we cannot be sure as to how the part was drawn in the CAD
    % package, it is necessary to translate the drawing entities to the
    % positive quadrant
    [data, H, W] = translate(data);
    set(handles.pHeight, 'String', H);
    set(handles.pWidth, 'String', W);

    
    
    % Determine the Area of the groups
    % This will help us to determine the inside and outside components.
    [areas, points] = calcArea(data);

    % ** In the areas matrix, the centerpoint of the group is provided, but at
    % the moment it is not used, this is something that needs to be looked at.

    
    % save test.mat points areas
    
    % Determine the sequence of the cuts
    [in_order, punte] = sequence(areas, points);

    % ** The sequence program may be buggy since it was last modified.
   
    
    data = applyOrder(data, in_order);
    
    [~, col] = size(data);
    
     disp('Original data');
     
     for i = 1:col
         if length(data{i}) == 1;
            disp(data{i}{1});
         else
            disp(data{i}{2});
         end
     end

    
    % Apply the Sequence of the cuts
     [~, col] = size(punte);
 
     for i = 1:col
         punte{i}{1} = i;
         in_order(i, 1) = i;
     end

     
     % Just for the fun of it, I am plotting the sequence.
%      xlabel('X-AXIS')
%      ylabel('Y-AXIS')
%      axis([-2 (W+5) -2 (H+5)])
%      hold on
%      cla
%      for i = 1:col
%          pl1 = plot(punte{i}{2}, punte{i}{3}, '-.b');
% %          drawnow();
% %          pause(0.5);
%      end
     
%      [FileName1,PathName1,FilterIndex1] = uiputfile('*.mat', 'Save the.mat file');
%      save([PathName1, FileName1], 'punte');
     axis equal
     legend('Part')
     hold off
     
%      break;
     % Now we need to account for the kerf-width and the additional offset. The
     % data cell array, will remain the base line for our endevours. Yet noting
     % will be modified, I will make a copy of the points cell array and modify
     % it from there onwards.

     % The funny thing now is that to account for kerf width, we need to use
     % the ray casting algorithm to determine the inside and outside of the
     % groups.

     [kerf, kerf_data] = kerfWidth(str2double(MT), punte, data, str2double(Offset));
     %kerf = punte;

%      disp('Kerf Data');
%      
%      [~, col] = size(kerf_data);
%      
%      for i = 1:col
%          [~, cols] = size(kerf_data{i});
%          for j = 1:cols
%              disp(kerf_data{i}{j});
%          end
%      end
     
     
     % Now we need to add the intro cut. Note that we cannot use the data
     % cell array anymore, since just above we have accounted for the kerfwidth
     % and it is just not worth calculating the ajustment for the data cell
     % array as well.

     if strcmp(IntroCut, 'Line')
         [intro_punte, intro] = introLine(kerf, str2double(MT));
     elseif strcmp(IntroCut, 'Arc')
         [intro_punte, intro] = introArc(kerf,str2double(MT));
     end
     
     [~, col] = size(intro_punte);
     intro_data = cell(1, col);
     
     for i = 1:col
         [~, cols] = size(kerf_data{i});
         intro_data{i}{1} = intro{i};
         
         for j = 2:cols+1
             intro_data{i}{j} = kerf_data{i}{j-1};
         end % End of for-loop
     end % End of for-loop
     
     intro_data
        
     % The following function will determine more information about the cut
     % for the user. Things like cutting time rapid time and so forth

     % Set the number of cuts.
     set(handles.text14, 'String', num2str(col));
     
     
     % Shift the points
     Sx = min(intro_punte{col}{2});
     if Sx < 0; Sx = -Sx; else Sx = 0; end
     Sy = min(intro_punte{col}{3});
     if Sy < 0; Sy = -Sy; else Sy = 0; end
     
     % Dtermine the torch active time.
     ttravel = 0;  % Torch Travel distance
     rtravel = 0;  % rapid travel
     for i = 1:col
         Lx = intro_punte{i}{2};
         Ly = intro_punte{i}{3};
         
         dLx = diff(Lx);
         dLy = diff(Ly);
          
         for j = 1:length(dLx)
             ttravel = ttravel + (dLx(j)*dLx(j) + dLy(j)*dLy(j))^0.5;
         end
         
         if i == 1
             start = [0 0];
         else
             start = [intro_punte{i-1}{2}(end), intro_punte{i-1}{2}(end)];
         end
         
         % Here we determine the rapid time
         current = [Lx(1), Ly(1)];
         vec = current - start;
         dis = (dot(vec, vec))^0.5;
         rtravel = rtravel + dis;
     end
     
     
	cla
    % Plot the original part
    hold on
     for i = 1:col
         pl1 = plot(punte{i}{2} + Sx, punte{i}{3}  + Sy, '-.b');
%          drawnow();
%          pause(1);
     end
     hold off
     
     
     % And now we are plotting the sequnce that will be cut.
     %axis([-2 (W+10) -2 (H+10)])
     hold on
     for i = 1:col
         pl2 = plot(intro_punte{i}{2} + Sx, intro_punte{i}{3} + Sy, 'r');
%          drawnow();
%          pause(0.5);
     end
     legend([pl1, pl2],'Part', 'Cut Path')
     axis equal
     hold off

     [~, col] = size(intro_data);
     
     for i = 1:col
         %[~, cols] = size(intro_data{i});
         %for j = 1:cols
             disp(intro_data{i}{1});
         %end
     end
     
     
     info = {file(1:end-4), MT, W, H, Current, Material};

     % Before we can generate the gcode for the cut we need to shift the
     % data to the first quadrant for one last time. The reason for this is
     % that the intro cut may be in one of the other quadrants.
     [intro_data, ~, ~] = translate(intro_data);
     
     
     
     % Now we will generate the G-CODE
     %[gcode, ttime, rtime] = gcodeGenerator(intro_punte, file(1:end-4), str2double(MT), ttravel, rtravel);
     [gcode, ttime, rtime] = gcodeGenerator2(intro_data, file(1:end-4), str2double(MT), ...
            str2double(Current), Material, ttravel, rtravel, handles);
     save partcode.mat gcode intro_punte info
     
     sec = ceil((ttime*60 - floor(ttime)*60));
     tstring = [num2str(floor(ttime)), 'min ', num2str(sec), 's'];
     
     sec = ceil((rtime*60 - floor(rtime)*60));
     rstring = [num2str(floor(rtime)), 'min ', num2str(sec), 's'];
     
     ttotal = ttime + rtime;
     
     sec = round((ttotal - floor(ttotal))*60);
     ttstring = [num2str(floor(ttotal)), 'min ', num2str(sec), 's'];
     
     set(handles.text16, 'String', tstring);
     set(handles.text18, 'String', rstring);
     set(handles.text20, 'String', ttstring);
     set(handles.streamCode, 'enable', 'on')
     
     %control = partPath(intro_punte);

     %simuStep(control);
     
 

     
% =========================================================================
% CHECK STATUS CODE
% =========================================================================

function checkStatus(handles)
    go = 1;
    file = get(handles.filename, 'String');
    if isempty(file)
        go = 0;
    end

    MT = get(handles.mtname, 'String');
    if isempty(MT)
        go = 0;
    end
    
    if str2double(MT) > 12
        go = 0;
        msgbox('Material too thick for piercing. Edge cut is not yet supported');
    end

    IntroCut = get(handles.introname, 'String');
    if isempty(IntroCut)
        go = 0;
    end

    Offset = get(handles.offsetname, 'String');
    if isempty(Offset)
        go = 0;
    end

    if go
        set(handles.genCut, 'enable', 'on')
    else
        set(handles.genCut, 'enable', 'off')
    end



% =========================================================================
% STREAM CODE
% =========================================================================

function streamCode_Callback(hObject, eventdata, handles)
    streamCode_ButtonDownFcn(hObject, eventdata, handles)

function streamCode_ButtonDownFcn(hObject, eventdata, handles)
    saveFile(handles);

    
% =========================================================================
% MENU FUNCTIONS
% =========================================================================
    
function Tools_Menu_Callback(hObject, eventdata, handles)

function gcodeSet_Callback(hObject, eventdata, handles)

function exit_Callback(hObject, eventdata, handles)
fh = ancestor(hObject,'figure'); 
delete(fh)


% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveFile(handles);

function saveFile(handles)
% This function will save the file with the appropiete name given by the
% user.

load partcode.mat

part = info{1};

index = find(part == '\');

if ~isempty(index)
    part = part(index(end)+1:end);
end

fileName = [part '.nc'];

[FileName,PathName,FilterIndex] = uiputfile('*.nc', 'Save the G-Code file' ,fileName);


if ~isempty(FileName)
    fod = fopen([PathName, FileName], 'w');
    [ded, col] = size(gcode);
% 
    for i = 1:col
        fprintf(fod, '%s\n', gcode{i});
    end

    fclose(fod);
    cla(handles.PartDisplay);
    h = msgbox([FileName, ' succesfully saved!!'], 'Success');
end

delete partcode.mat
delete filePro.mat
set(handles.filename, 'String', '')
set(handles.mtname, 'String', '')
set(handles.introname, 'String', '')
checkStatus(handles);
%cla reset



