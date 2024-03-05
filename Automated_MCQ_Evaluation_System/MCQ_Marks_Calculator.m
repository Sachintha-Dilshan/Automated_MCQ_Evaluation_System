function varargout = MCQ_Marks_Calculator(varargin)
% MCQ_MARKS_CALCULATOR MATLAB code for MCQ_Marks_Calculator.fig
%      MCQ_MARKS_CALCULATOR, by itself, creates a new MCQ_MARKS_CALCULATOR or raises the existing
%      singleton*.
%
%      H = MCQ_MARKS_CALCULATOR returns the handle to a new MCQ_MARKS_CALCULATOR or the handle to
%      the existing singleton*.
%
%      MCQ_MARKS_CALCULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCQ_MARKS_CALCULATOR.M with the given input arguments.
%
%      MCQ_MARKS_CALCULATOR('Property','Value',...) creates a new MCQ_MARKS_CALCULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MCQ_Marks_Calculator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MCQ_Marks_Calculator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MCQ_Marks_Calculator

% Last Modified by GUIDE v2.5 15-Feb-2023 22:10:37

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MCQ_Marks_Calculator_OpeningFcn, ...
                   'gui_OutputFcn',  @MCQ_Marks_Calculator_OutputFcn, ...
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


% --- Executes just before MCQ_Marks_Calculator is made visible.
function MCQ_Marks_Calculator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MCQ_Marks_Calculator (see VARARGIN)

% Choose default command line output for MCQ_Marks_Calculator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MCQ_Marks_Calculator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MCQ_Marks_Calculator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles) 
    [filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       filename = strcat(pathname, filename);
       A = imread(filename);
       axes(handles.axes1);
       imshow(A);
       handles.A = A;
       guidata(hObject, handles);
    end
 


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

    [filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       filename = strcat(pathname, filename);
       B = imread(filename);
       axes(handles.axes2);
       imshow(B);
       handles.B = B;
       guidata(hObject, handles);
    end
% --- Executes on button press in btnCalculate.
function btnCalculate_Callback(hObject, eventdata, handles)
try
    SE = strel('disk', 5);
    
    markingScheme = handles.A;
    markingScheme = ~im2bw(markingScheme, graythresh(markingScheme));
    markingScheme = imopen(markingScheme, SE);
    [I, questionCount] = bwlabel(markingScheme, 8);

    answers = handles.B;
    answers = ~im2bw(answers, graythresh(answers));
    answers = imopen(answers, SE);
    
    incorrectAnswers = (answers - imresize(markingScheme,size(answers)));
    incorrectAnswers = im2bw(incorrectAnswers,graythresh(incorrectAnswers));
    incorrectAnswers = imopen(incorrectAnswers, SE);
    
    
    [J, incorrectAnswersCount] = bwlabel(incorrectAnswers, 8);
    
    correctAnswersCount = questionCount - incorrectAnswersCount;
    finalMarks = (correctAnswersCount/questionCount)*100;
    set(handles.lblCorrectAnswers, 'string', num2str(correctAnswersCount)); 
    set(handles.lblFinalMarks, 'string', num2str(finalMarks));
catch
    msgbox('Please upload images before calculation','Error','error');
end   


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
