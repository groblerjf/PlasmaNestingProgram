function varargout = AxisControl(varargin)
% AXISCONTROL MATLAB code for AxisControl.fig
%      AXISCONTROL, by itself, creates a new AXISCONTROL or raises the existing
%      singleton*.
%
%      H = AXISCONTROL returns the handle to a new AXISCONTROL or the handle to
%      the existing singleton*.
%
%      AXISCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AXISCONTROL.M with the given input arguments.
%
%      AXISCONTROL('Property','Value',...) creates a new AXISCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AxisControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AxisControl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AxisControl

% Last Modified by GUIDE v2.5 24-Jan-2014 00:07:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AxisControl_OpeningFcn, ...
                   'gui_OutputFcn',  @AxisControl_OutputFcn, ...
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


% --- Executes just before AxisControl is made visible.
function AxisControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AxisControl (see VARARGIN)

% Choose default command line output for AxisControl
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AxisControl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AxisControl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% =========================================================================
% AXIS INCREMENT SELECTION CODE
% =========================================================================

function xpopmenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns xpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xpopmenu

function xpopmenu_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function ypopmenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns ypopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ypopmenu

function ypopmenu_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    
function zpopmenu_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns zpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zpopmenu

function zpopmenu_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



% =========================================================================
% AXIS NAVIGATION BUTTONS
% =========================================================================

function xpos_Callback(hObject, eventdata, handles)
    xpos_ButtonDownFcn(hObject, eventdata, handles)

function xpos_ButtonDownFcn(hObject, eventdata, handles)
    incre = [1 5 10 20 50 100];
    index = get(handles.xpopmenu, 'Value');
    vec = [incre(index) 0 0];
    moveAxes(handles, vec);


function xneg_Callback(hObject, eventdata, handles)
    xneg_ButtonDownFcn(hObject, eventdata, handles)

function xneg_ButtonDownFcn(hObject, eventdata, handles)
    incre = [1 5 10 20 50 100];
    index = get(handles.xpopmenu, 'Value');
    vec = [-incre(index) 0 0];
    moveAxes(handles, vec);


function ypos_Callback(hObject, eventdata, handles)
    ypos_ButtonDownFcn(hObject, eventdata, handles)

function ypos_ButtonDownFcn(hObject, eventdata, handles)
    incre = [1 5 10 20 50 100];
    index = get(handles.ypopmenu, 'Value');
    vec = [0 incre(index) 0];
    moveAxes(handles, vec);


function yneg_Callback(hObject, eventdata, handles)
    yneg_ButtonDownFcn(hObject, eventdata, handles)

function yneg_ButtonDownFcn(hObject, eventdata, handles)
    incre = [1 5 10 20 50 100];
    index = get(handles.ypopmenu, 'Value');
    vec = [0 -incre(index) 0];
    moveAxes(handles, vec);


function zpos_Callback(hObject, eventdata, handles)
    zpos_ButtonDownFcn(hObject, eventdata, handles)

function zpos_ButtonDownFcn(hObject, eventdata, handles)
    incre = [1 5 10 20 50 100];
    index = get(handles.zpopmenu, 'Value');
    vec = [0 0 incre(index)];
    moveAxes(handles, vec);


function zneg_Callback(hObject, eventdata, handles)
    zneg_ButtonDownFcn(hObject, eventdata, handles)

function zneg_ButtonDownFcn(hObject, eventdata, handles)
    incre = [1 5 10 20 50 100];
    index = get(handles.zpopmenu, 'Value');
    vec = [0 0 -incre(index)];
    moveAxes(handles, vec);



% =========================================================================
% CYCLE START CODE
% =========================================================================

function cyclestart_Callback(hObject, eventdata, handles)
    cyclestart_ButtonDownFcn(hObject, eventdata, handles)

function cyclestart_ButtonDownFcn(hObject, eventdata, handles)
    status = get(handles.plasmatext, 'enable');
    
    if status
        set(handles.loadpart, 'enable', 'off')
        set(handles.startcut, 'enable', 'off')
    end



% =========================================================================
% CYCLE STOP CODE
% =========================================================================

function cyclestop_Callback(hObject, eventdata, handles)
    cyclestop_ButtonDownFcn(hObject, eventdata, handles)

function cyclestop_ButtonDownFcn(hObject, eventdata, handles)
    status = get(handles.plasmatext, 'enable');
    
    if status
        set(handles.loadpart, 'enable', 'on')
        set(handles.startcut, 'enable', 'on')
    end



% =========================================================================
% EMERGENCY STOP CODE
% =========================================================================

function reset_Callback(hObject, eventdata, handles)
    % Hint: get(hObject,'Value') returns toggle state of reset
    reset_ButtonDownFcn(hObject, eventdata, handles)

function reset_ButtonDownFcn(hObject, eventdata, handles)
    disp('Action Stoped');
    pressed = get(hObject, 'Value')
    if pressed
        set(handles.xpos, 'enable', 'off')
        set(handles.xneg, 'enable', 'off')
        set(handles.ypos, 'enable', 'off')
        set(handles.yneg, 'enable', 'off')
        set(handles.zpos, 'enable', 'off')
        set(handles.zneg, 'enable', 'off')
        set(handles.cyclestart, 'enable', 'off')
        set(handles.cyclestop, 'enable', 'off')
        set(handles.emergencytext, 'enable', 'on')
        pause;
    elseif ~pressed
        set(handles.xpos, 'enable', 'on')
        set(handles.xneg, 'enable', 'on')
        set(handles.ypos, 'enable', 'on')
        set(handles.yneg, 'enable', 'on')
        set(handles.zpos, 'enable', 'on')
        set(handles.zneg, 'enable', 'on')
        set(handles.cyclestart, 'enable', 'on')
        set(handles.cyclestop, 'enable', 'on')
        set(handles.emergencytext, 'enable', 'off')
    end


% =========================================================================
% SLIDER CODE
% =========================================================================

function axisspeed_Callback(hObject, eventdata, handles)
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    set(handles.slidervalue, 'String', [num2str(get(hObject, 'Value')) '%']);


function axisspeed_CreateFcn(hObject, eventdata, handles)
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


% =========================================================================
% MOVEMENT CODE
% =========================================================================

function moveAxes(handles, vec)
    disp(vec);
    
    speed = get(handles.axisspeed, 'Value');
    disp('Percentage speed');
    disp(speed);
    s = 30000*(1 - speed/100);
    
    [control, error] = stepGen(vec, 0);
    length(control)
    
    disp('Error present');
    disp(error)
    
    % Lets send the code
    
    %parport = digitalio('parallel',1);
    %lines = addline(parport,0:7,'out');
    %putvalue(parport,dec2binvec(0,8))
    for n = 1:length(control)
        control(n, :);
        %putvalue(parport,control(n, :));
        for q = 1:s;end
    end
    %putvalue(parport,dec2binvec(0,8))
    %delete(parport);
    %clear parport;
    
    
    
% =========================================================================
% CODE FOR THE CUT
% =========================================================================

function loadpart_Callback(hObject, eventdata, handles)
    loadpart_ButtonDownFcn(hObject, eventdata, handles)

function loadpart_ButtonDownFcn(hObject, eventdata, handles)
    load partcode.mat
    
    file = info{1};
    MT   = info{2};
    W    = info{3};
    H    = info{4};
    
    ind = find(file == '\');
    file = file(ind(end)+1:end);
    
    set(handles.part, 'String', file)
    set(handles.mthick, 'String', MT)
    set(handles.width, 'String', num2str(W))
    set(handles.height, 'String', num2str(H))
    
    
    [~, col] = size(intro_punte);
    axis([-2 (W+10) -2 (H+10)])
    hold on
    for i = 1:col
        plot(intro_punte{i}{2}, intro_punte{i}{3}, 'b')
    end
    legend('Part', 'Cut Path')
    axis equal
    hold off


function startcut_Callback(hObject, eventdata, handles)
    startcut_ButtonDownFcn(hObject, eventdata, handles)

function startcut_ButtonDownFcn(hObject, eventdata, handles)
    set(handles.plasmatext, 'enable', 'on')


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exit_item_Callback(hObject, eventdata, handles)
% hObject    handle to exit_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fh = ancestor(hObject,'figure'); 
delete(fh)
