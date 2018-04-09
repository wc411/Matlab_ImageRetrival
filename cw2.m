function varargout = cw2(varargin)

% CW2 MATLAB code for cw2.fig
%      CW2, by itself, creates a new CW2 or raises the existing
%      singleton*.
%
%      H = CW2 returns the handle to a new CW2 or the handle to
%      the existing singleton*.
%
%      CW2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CW2.M with the given input arguments.
%
%      CW2('Property','Value',...) creates a new CW2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cw2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cw2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cw2

% Last Modified by GUIDE v2.5 02-Apr-2018 03:50:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cw2_OpeningFcn, ...
                   'gui_OutputFcn',  @cw2_OutputFcn, ...
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

% --- Executes just before cw2 is made visible.
function cw2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cw2 (see VARARGIN)

% Choose default command line output for cw2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%
% Turns off the axes off when GUI is loaded
set(handles.axes1,'visible','off');

% --- Outputs from this function are returned to the command line.
function varargout = cw2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btnSIF.
% --- Selects an image folder so that the database can be created
function btnSIF_Callback(hObject, eventdata, handles)
%% Returns the path that the user selects from the dialog box.
iPath = uigetdir();

% If image folder has not been selected, do nothing
% else execute code below
if isequal(iPath,0)
else
    % List the folder content, from the path 'iPath'
    % and only list matching files with '.jpg' extensions
    imgList = dir(fullfile(iPath, '*.jpg'));
    
    % Get the size of the image list in one dimension
    % and save it into the variable 'imgCount'
    imgCount = size(imgList,1);
    
    % Save the variables 'imgCount' and 'imgList' into appdata
    % and give them the names 'imgCount' and 'imgList'
    setappdata(0,'imgCount',imgCount);
    setappdata(0,'imgList',imgList); 
end

% --- Executes on button press in btnCND.
% --- Creates a new text file called 'imgDB.txt'
% --- and stores all data in there
function btnCND_Callback(hObject, eventdata, handles)
% Load the variables 'imgCount' and 'imgList' from appdata
% into the local variables 'imgCount' and 'imgList'
imgCount = getappdata(0, 'imgCount');
imgList = getappdata(0, 'imgList');

% An if-statement that checks if the folder is not empty, or if an image
% folder has been selected, else display error message
if (isequal(imgCount,0))
    errorMessage = 'Folder is empty'
elseif (isequal(imgCount,[]))
    errorMessage = 'Please select an image folder'
else
    % Open the file name 'imgDB.txt' for writing
    % and save the ID to the variable 'fileID'
    fileID = fopen('imgDB.txt','w');

    %% A forloop that stores all element in the 'imgList' variable
    for i = 1:imgCount
        % Save the current element name 'i' into the variable 'tempIMGName'
        % including the element extension
        tempIMGName = imgList(i).name;
        
        % Display the image that has been saved
        savedIMG = tempIMGName
        
        % Reads the image from the file 
        % and stores it into the variable 'tempIMG'
        tempIMG = imread(tempIMGName);

        % Stores the red colour channel from the image into 'tempRed'
        tempRed = tempIMG(:,:,1);

        % Stores the red colour channel from the image into 'tempGreen'
        tempGreen = tempIMG(:,:,2);

        % Stores the red colour channel from the image into 'tempBlue'
        tempBlue = tempIMG(:,:,3);
        
        % Get the histogram of the red channel 'tempRed'
        % and save the histogram bin as 'x' and count as 'yRed'
        [yIMG,x] = imhist(tempIMG);

        % Get the histogram of the red channel 'tempRed'
        % and save the histogram bin as 'x' and count as 'yRed'
        [yRed,x] = imhist(tempRed);

        % Get the histogram of the green channel 'tempGreen'
        % and save the histogram bin as 'x' and count as 'yGreen'
        [yGreen,x] = imhist(tempGreen);

        % Get the histogram of the red channel 'tempBlue'
        % and save the histogram bin as 'x' and count as 'yBlue'
        [yBlue,x] = imhist(tempBlue);

        % Write the current value of 'tempIMGName' into
        % the text file 'imgDB.txt'
        fprintf(fileID,'%s ',tempIMGName);
        % Followed by the current value of 'x','yRed','yGreen','yBlue' into
        % the text file 'imgDB.txt'
        fprintf(fileID,'%d ', x);
        fprintf(fileID,'%d ', yIMG);
        fprintf(fileID,'%d ', yRed);
        fprintf(fileID,'%d ', yGreen);
        fprintf(fileID,'%d ', yBlue);
        % Separates the values with ' ' space, and when the it's done,
        % create a new line
        fprintf(fileID,'\n');
    end
    % Close the 'imgDB.txt' file that has been worked on. 
    fclose(fileID);
    
    % Display a confirmation message saying the database has been created
    Message = 'Successfully created the image database'
end

% --- Executes on button press in btnLDS.
% --- Loads image data from text file
% --- and stores it into appdata for it to be operated on later
function btnLDS_Callback(hObject, eventdata, handles)
% Open the file 'imgDB.txt', gets the file ID with the read 'r' permission
fileID = fopen('imgDB.txt','r');

% Check that the file exists, else display error message
if(isequal(fileID, -1))
    errorMessage = 'File does not exists'
else
    % Reads the text file into a cell array
    tempArray = textscan(fileID,'%s','Delimiter', '\n');

    % Closes the file
    fclose(fileID);
    
    % Checks that the text file is not empty, else display error message
    if(isempty(tempArray{1}) == 1)
        errorMessage = 'File is empty'
    else
        % Match the regular expression and split the string by space
        % into several substrings, where each substring is delimited by a ' ' character
        % In this case split the large single cell array into several sub cell arrays
        result = regexp(tempArray{1},' ','split');

        % Get the size of the cell array, since it's only one dimension we
        % specified it by 1. 
        listSize = size(result, 1);

        % Initializing an empty cell array to keep all the images data
        tempHolder = {};

        % A for-loop to iterate through the array
        for i = 1:listSize

            % Created our own function to extract 
            % the different values from the array
            % such as the bin 'x', IMG histogram 'yIMG', 
            % red, green, blue colour channel histogram 'yRed', 'yGreen', 'yBlue'
            [x,yIMG,yRed,yGreen,yBlue] = cellExtractor(result{i});

            % Stores the variables 'x', 'yIMG', 'yRed', 'yGreen', 'yBlue' into one array
            % so that it's easier to manipulate after
            tmpArrNr = [x yIMG yRed yGreen yBlue];
            
            % Display the image that has been loaded
            loadedIMG = result{i}{1}
            
            % Afterwards save the array including the image name 
            % into one single cell array 
            tmpCellArr = {loadedIMG tmpArrNr};

            % Combine the single cell array that contains both the name and the
            % different image values into one cell array
            tempHolder = [tempHolder {tmpCellArr}];
        end

        % Save the populated 'tempHolder' cell array into appdata
        setappdata(0,'imagesData',tempHolder);
        
        % Display a confirmation message saying the image has been loaded
        Message = 'Image database successfully loaded'
    end
end

% --- Executes on button press in btnSI.
% --- Selects an image to compare with the database
function btnSI_Callback(hObject, eventdata, handles)
%% Returns an image file that the user selects from the dialog box.
[fileName,path] = uigetfile({'*.jpg;*.png'}, 'Select an image');

% If an image has not been selected, do nothing
% else execute code below
if isequal(fileName,0)
else
    % Save the image name 'fileName' as a value in appdata
    % with the name 'imgName'
    setappdata(0,'imgName',fileName);

    % Displays the image/file in the axes
    axes(handles.axes1)
    imshow(fileName);
    
    % Display a confirmation message
    Message = ['Image ''' fileName ''' has been selected']
end

% --- Executes on button press in btnQI.
function btnQI_Callback(hObject, eventdata, handles)
% Gets the path of the image and stores it into a variable 
imgPath = getappdata(0, 'imgName');

% Gets the database stored in appdata and saves it into a variable
imgDB = getappdata(0,'imagesData');

% Checks that an image has been selected
% and that the database has been loaded
if (isequal(imgPath, []))
    errorMessage = 'No image has been selected'
elseif(isequal(imgDB, []))
    errorMessage = 'Database has not be loaded'
else
    % Read the image to a variable
    img1 = imread(imgPath);
    
    %Split into RGB Channels
    Red1 = img1(:,:,1);
    Green1 = img1(:,:,2);
    Blue1 = img1(:,:,3);
    
    % Get histValues for each channel
    [count1, bin1] = imhist(img1);
    [yRed1,x1] = imhist(Red1);
    [yGreen1,x1] = imhist(Green1);
    [yBlue1,x1] = imhist(Blue1);
    
    % Count the total images
    imgCount = size(imgDB, 2);
    
    % A temporary holding place for the images
    % This will contain a cell array with the image name and compared value
    tmpImgNameScore = {};
    % This will contain the compared value
    tmpImgScore = [];
    
    for ii = 1:imgCount
        % Get the image name
        imgName = imgDB{ii}{1};

        %x2 = imgDB{ii}{2}(:,1);
        
        % Get the histogram of the the whole image
        % from the cell array
        imgHist2 = imgDB{ii}{2}(:,2);
        
        yRed2 = imgDB{ii}{2}(:,3);
        yGreen2 = imgDB{ii}{2}(:);
        yBlue2 = imgDB{ii}{2}(:,5);
        
        % Compare the two histograms, and get a value between 0 - 1
        % 1 equals to the same object/flower, while 0 is not equal
        finalScore = hist_sect(imhist(img1), imgHist2);
        
        % Save the final score in an array
        tmpImgScore = [tmpImgScore finalScore];
        tmpImgNameScore = [tmpImgNameScore {{imgName finalScore}}];
        
        %{
        testR = hist_sect(yRed1, yRed2);
        testG = hist_sect(yGreen1, yGreen2);
        testB = hist_sect(yBlue1, yBlue2);
        
        totalSum  = (sum([testR, testG, testB]) / 3);
        tmpImgScore = [tmpImgScore totalSum];
        tmpImgNameScore = [tmpImgNameScore {{imgName totalSum}}];
        %}
    end
    
    % Sort the array with all the compared flowers values LOW-HIGH
    sortedRank = sort(tmpImgScore);
    
    % Get the last ten index of the array list
    top10 = find(sortedRank,10,'last');
    
    % Reverse the top10 list, HIGH-LOW
    top10 = fliplr(top10);
    
    % Use the top10 index to get the values from the sortedRank array
    final10 = sortedRank(top10);

    % A cell array that will contain the top ten flower names/path
    finalRankList = {};
    
    % A for-loop to find which flower have similar score
    % as the 10 top flowers in the list, and extract them
    for ii = 1:size(top10,2) % Get the amount of element in the array
        for jj = 1:imgCount % Get the amount of flowers
            if(isequal(final10(ii), tmpImgNameScore{jj}{2})) % Compare if they are equal
                % If match, put their name in the list
                finalRankList = [finalRankList tmpImgNameScore{jj}{1}];
            end
        end
    end
    
    uip = uipanel(handles.panUI);
    myaxes = axes('parent', uip);
    
    for ii = 1:size(finalRankList, 2)
        subplot(5,2,ii);
        % [left(x) bottom(y) width height]
        imshow(finalRankList{ii});
    end
end

% --- Executes on button press in btnExit.
% --- Close all application, clear all variables including appdata, cle
function btnExit_Callback(hObject, eventdata, handles)
appdata = get(0,'ApplicationData')
fieldNames = fieldnames(appdata);
for i = 1:numel(fieldNames)
  rmappdata(0,fieldNames{i});
end

clear;
clc;
close all;

% Display an message saying the application has been closed
Message = 'Closed application'

% --- Executes on button press in btnHist.
% --- Display the histogram of the image
function btnHist_Callback(hObject, eventdata, handles)
% Gets the path of the image and stores it into a variable 
imgPath = getappdata(0, 'imgName');

% Checks that an image has been selected, else display error message
if(isequal(imgPath, []))
    errorMessage = 'No image has been selected'
else
    % Display a new figure, because current one is full
    figure;

    % Gets the image from the path and stores it into a variable
    img1 = imread(imgPath);

    % Split into RGB Channels
    Red = img1(:,:,1);
    Green = img1(:,:,2);
    Blue = img1(:,:,3);

    % Get histValues for each channel
    [yRed,x] = imhist(Red);
    [yGreen,x] = imhist(Green);
    [yBlue,x] = imhist(Blue);

    % Display each channel into a bar
    subplot(3,1,1);
    bar(x, yRed, 'Red');

    subplot(3,1,2);
    bar(x, yGreen, 'Green');

    subplot(3,1,3);
    bar(x, yBlue, 'Blue');

    % Show the thresholds as vertical red bars on the histograms.
    dispThresBars(1, (graythresh(Red) * 255), 255);
    dispThresBars(2, (graythresh(Green) * 255), 255);
    dispThresBars(3, (graythresh(Blue) * 255), 255);
end

% --- A function that displays the min 
% --- and max threshold bars on the histogram when btnHist is pressed
function dispThresBars(plotNumber, minThres, maxThres)
% Display the thresholds as vertical red bars on the histograms.
subplot(3, 1, plotNumber);
hold on;
yAxisRanVal = ylim;
line([minThres, minThres], yAxisRanVal, 'Color', 'r', 'LineWidth', 2);
line([maxThres, maxThres], yAxisRanVal, 'Color', 'r', 'LineWidth', 2);

% Place a text label on the bar chart showing the threshold.
annoTxtL = sprintf('%d', minThres);
annoTxtH = sprintf('%d', maxThres);

% Casted x and y to the data class "double";
text(double(minThres + 5), double(0.85 * yAxisRanVal(2)), annoTxtL);
text(double(maxThres + 5), double(0.85 * yAxisRanVal(2)), annoTxtH);
return;

% --- A function that counts how many bins are there on each image file
% --- and returns that image size
function binSize = getBinSize(cell)
% A variable that will count the amount of integer till 255
binCount = 0;

% A variable that will temporary store all the numbers untill it reach 255
checkNum = 0;

% Get the length of the cell
arrS = size(cell,2);

% A boolean that will turn true when the checkNum is equal to 255
wBool = false;

% A iterative loop that will only stop when wBool is true
while (wBool == false)
    for i = 2:arrS - 1 
        if(checkNum == 255) 
            % If checkNum is equal to 255, set wBool to true
            wBool = true;
        else
            % Whenever checkNum is not equal to 255, add 1 to binCount
            % and store that number to checkNum
            checkNum = str2double(cell{i});
            binCount = binCount + 1; 
        end
    end
end
binSize = binCount; % Return the amount of bins
return;

% --- A function that gets a certain part of an cell array
% --- and returns that as an array
function [cellElement] = getCell(cell, startPoint, endPoint)
% A temporary array holder, that keeps all the numbers
tmpHolder = [];

% A for-loop that starts at a given point, and stop at a given point
for i = startPoint:endPoint
    % Parse the string cell array to a double number
    tmpC = str2double(cell{i});
    % Stores the number into the array, and repeat
    tmpHolder = [tmpHolder
        tmpC];
end
cellElement = tmpHolder; % Return the numbers
return;

% --- A function that will get the bin, 
% --- histogram of the image, Red, Green, Blue channel
function [x, yIMG, yRed, yGreen, yBlue] = cellExtractor(cell)
% A variable that will keep the input
tmpList = cell;

% Find the size of the list, using a private function
fixSize = getBinSize(tmpList) + 1;

% Skip the first index, because it's the file name
startPoint = 2;

% The same as the bin length on the cell
endPoint = fixSize; 

% Get the bin values and stores it in an array
x = getCell(tmpList, startPoint, endPoint);

% Increase the startPoint and endPoint by adding it with 
% the fixedSize and decrease it by 1 since we skipped the first index
startPoint = startPoint + fixSize - 1;
endPoint = endPoint + fixSize - 1;

% Get the image histogram values and stores it in an array
yIMG = getCell(tmpList, startPoint, endPoint);

% Increase the startPoint and endPoint by adding it with 
% the fixedSize and decrease it by 1 since we skipped the first index
startPoint = startPoint + fixSize - 1;
endPoint = endPoint + fixSize - 1;

% Get the red channel histogram values and stores it in an array
yRed = getCell(tmpList, startPoint, endPoint);

% Increase the startPoint and endPoint by adding it with 
% the fixedSize and decrease it by 1 since we skipped the first index
startPoint = startPoint + fixSize - 1;
endPoint = endPoint + fixSize - 1;

% Get the green channel histogram values and stores it in an array
yGreen = getCell(tmpList, startPoint, endPoint);

% Increase the startPoint and endPoint by adding it with 
% the fixedSize and decrease it by 1 since we skipped the first index
startPoint = startPoint + fixSize - 1;
endPoint = endPoint + fixSize - 1;

% Get the blue channel histogram values and stores it in an array
yBlue = getCell(tmpList, startPoint, endPoint);
return;
