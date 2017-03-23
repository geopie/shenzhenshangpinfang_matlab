function varargout = shangpinfangshuju(varargin)
% SHANGPINFANGSHUJU MATLAB code for shangpinfangshuju.fig
%      SHANGPINFANGSHUJU, by itself, creates a new SHANGPINFANGSHUJU or raises the existing
%      singleton*.
%
%      H = SHANGPINFANGSHUJU returns the handle to a new SHANGPINFANGSHUJU or the handle to
%      the existing singleton*.
%
%      SHANGPINFANGSHUJU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHANGPINFANGSHUJU.M with the given input arguments.
%
%      SHANGPINFANGSHUJU('Property','Value',...) creates a new SHANGPINFANGSHUJU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shangpinfangshuju_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shangpinfangshuju_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shangpinfangshuju

% Last Modified by GUIDE v2.5 20-Mar-2017 08:36:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shangpinfangshuju_OpeningFcn, ...
                   'gui_OutputFcn',  @shangpinfangshuju_OutputFcn, ...
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


% --- Executes just before shangpinfangshuju is made visible.
function shangpinfangshuju_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shangpinfangshuju (see VARARGIN)

% Choose default command line output for shangpinfangshuju
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes shangpinfangshuju wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = shangpinfangshuju_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 本程序用于获取网站中的数据 by geopie
clc;
warning off;

%数据抓取
[sourcefile, status] = urlread('http://ris.szpl.gov.cn/credit/showcjgs/ysfcjgs.aspx?cjType=0'); %输入网址

if ~status
error('读取出错！\n')
end

%数据提取，可以通过补充代码提取更多信息。
expr1 = '\S*\d\d\d\d年\d\d月\d\d日\S*'; %获取日期           
datefile= regexp(sourcefile, expr1, 'match');
datefile=datefile{1,1};
date = datefile(end-10:end);
year=str2num(datefile(end-10:end-7));
month=str2num(datefile(end-5:end-4));
day=str2num(datefile(end-2:end-1));

 expr2 = '<td width="14%"><b>小计</b></td><td width="14%"><b>\d*</b>'; %获取成交套数
chengjiaoxiaoji = regexp(sourcefile, expr2, 'match');
chengjiaoxiaoji=chengjiaoxiaoji{1,1};
chengjiaoxiaoji=regexp(chengjiaoxiaoji,'>(\d*)</b>','tokens');


expr3='align="right"><b>\d*';
junjia = regexp(sourcefile, expr3, 'match');%获取成交均价
junjia=junjia{1,2};
[junjia1,junjia]=regexp(junjia,'<b>(\d*)','match','tokens');

expr4='<td width="14%">\d*';%获取可售套数
keshou=regexp(sourcefile, expr4, 'match');
keshou=keshou{1,45};
keshou=regexp(keshou,'">(\d*)','tokens');

%保存数据到Excel
filename = sprintf('%d年深圳商品房信息.xls',year);
pathname = [pwd '\data'];

if ~exist(pathname,'dir')  
mkdir(pathname);
end

filepath = [pwd '\data\' filename];
sheet = sprintf('%d年深圳商品房信息', year);

if ~exist(filepath,'file')%判断路径下是否存在文件，如果不存在创建新文件
    head={'日期','成交套数','成交均价(元)','可售套数'};
    xlswrite(filepath,head,sheet);
end

[a,b,i]=xlsread(filepath,sheet);%filepath为x.xls文件路径
range = sprintf('A%d',size(i,1)+1);%判断路径下已存在文件的行数，在下一行追加新数据。
shuju= {date,cell2mat(chengjiaoxiaoji{1,1}),cell2mat(junjia{1,1}),cell2mat(keshou{1,1})};%将cell格式数据提取出来，转化为mat格式，构建新cell写入excel文件。
xlswrite(filepath, shuju,sheet,range);
helpdlg('数据获取成功!')
edittext=sprintf('新增信息：%d年%d月%d日,均价%d元/平方米',year,month,day,str2double(junjia{1,1}));
set(handles.edit2,'string',edittext)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
