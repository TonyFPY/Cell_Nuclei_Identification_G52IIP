% ------------- COURSEWORK01 MATLAB code for coursework01.fig -------------
%
% This is a Main MATLAB program file to implement the image processing
% solution. Since it is a GUI program, please do not delete the *.fig file!
% Otherwise, the program will not be executed.
%
% Author: Pinyuan Feng (scypf1)
% Student ID: 20028407

function varargout = coursework01(varargin)
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @coursework01_OpeningFcn, ...
                       'gui_OutputFcn',  @coursework01_OutputFcn, ...
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
end


%  -----------Executes just before coursework01 is made visible -----------
function coursework01_OpeningFcn(hObject,eventdata, handles, varargin)
    % Choose default command line output for coursework01
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
end

% ------ Outputs from this function are returned to the command line ------ 
function varargout = coursework01_OutputFcn(hObject, eventdata, handles,varargin) 
    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% ---------------- Executes on button press in pushbutton1 ----------------
% This button call-back function can be regarded as 'Main' function, 
% which contains a pipeline to process images. If you click the button,
% the processed image will be shown on GUI.
function pushbutton1_Callback(hObject, eventdata, handles)
    % read files
    global fileName;
    img_raw = imread([fileName,'.bmp']);
    axes(handles.axes1);
    imshow(img_raw);

    % color space separation
    R = img_raw(:,:,1);
    G = img_raw(:,:,2);
    B = img_raw(:,:,3);
    
    % greenness extraction because we mainly focus on green psrt
    greenness = G - (R + B)/2;
    
    % add contrast
    greenness = imadjust(greenness,[0.01,1],[]);
    
    % apply noise reduction
    global noiseReduction;
    greenness = NoiseReduction(greenness, noiseReduction);

    axes(handles.axes2);
    imshow(greenness);
    
    % apply thresholding
    global thresholding;
    greenness = Thresholding(greenness, thresholding);

    % apply Morphological Transformations
    se = strel('disk', 3);
    greenness = imopen(greenness, se);

    axes(handles.axes3);
    imshow(greenness);
    
    % label the connected components and count number
    global num;
    cc = bwconncomp(greenness);
    num = cc.NumObjects;
    fprintf('Number of Cell Nuclei in %s is %d.\n',fileName, num);
    set(handles.edit1,'string', ['Num of Cell Nuclei = ',num2str(num)]);
end

% -------------- Executes on selection change in popupmenu 1 -------------- 
% This pop-up menu allows you to choose the image you want to process.
function popupmenu1_Callback(hObject, eventdata, handles)
    global fileName;
    val = get(handles.popupmenu1,'Value');
    switch val
        case 2
            fileName = 'StackNinja1';
        case 3
            fileName = 'StackNinja2';
        case 4
            fileName = 'StackNinja3';
    end
end

% ----- Executes during object creation, after setting all properties ----- 
function popupmenu1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------- Executes on selection change in popupmenu 2 -------------- 
% This pop-up menu allows you to choose the noise reduction approach.
function popupmenu2_Callback(hObject, eventdata, handles)
    global noiseReduction;
    val = get(handles.popupmenu2,'Value');
    switch val
      case 2
          noiseReduction = 'meanFiltering';
      case 3
          noiseReduction = 'gaussianFiltering';
      case 4
          noiseReduction = 'anisotropicDiffusion';
      case 5
          noiseReduction = 'bilateralFiltering';
    end
end

% ----- Executes during object creation, after setting all properties ----- 
function popupmenu2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% -------------- Executes on selection change in popupmenu 3 --------------
% This pop-up menu allows you to choose the thresholding approach.
function popupmenu3_Callback(hObject, eventdata, handles)
    global thresholding;
    val = get(handles.popupmenu3,'Value');
    switch val
      case 2
          thresholding = 'OtsuThresholding';
      case 3
          thresholding = 'IterateThresholding';
      case 4
          thresholding = 'RosinThresholding';
      case 5
          thresholding = 'LocalAdaptiveThresholding';
    end
end

% ----- Executes during object creation, after setting all properties ----- 
function popupmenu3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------ Executes on text change in edit box ------------------
% This part can show you the number of cell nuclei after program execution.
function edit1_Callback(hObject, eventdata, handles)
    set(handles.edit1,'string',num2str(num));
end

% ----- Executes during object creation, after setting all properties ----- 
function edit1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
