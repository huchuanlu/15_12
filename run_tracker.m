clear all;
clc;

%%******Change 'title' to choose the sequence you wish to run******%% 
title = 'Occlusion1';
title = 'Occlusion2';
title = 'Caviar1';
title = 'Caviar2';
title = 'Singer1';
title = 'Car4';
title = 'DavidIndoorNew';
title = 'Sylvester';
% % title = 'Deer';
% % title = 'Leno';
% % title = 'Car11';
% % title = 'Stone';
% % title = 'Girl';
% % title = 'Dudek';
%%******Change 'title' to choose the sequence you wish to run******%%

%%***********************1.Initialization****************************%%
addpath(genpath('./Trackers')); 
addpath(genpath('./Evaluation'));
opt = [];
trackparam;
%%1.1 Initialize variables:
opt.tmplsize = [32,32];  
opt.numsample = 600;
opt.blockNum = [4 4];
load(['./blockIndex_' [ num2str(opt.blockNum(1)) num2str(opt.blockNum(2))] '.mat']);
opt.blockIndex = blockIndex;
%
opt.numPos     = 10; 
opt.numNeg     = 50; 
opt.rangePos   = 1; 
opt.rangeNeg   = 10; 
opt.mu         = 0.1; 
opt.updateRate = 0.95; 
opt.updateTr   = 0.15;


%1.2 Load functions and parameters:
param0 = [p(1), p(2), p(3)/32, p(5), p(4)/p(3), 0];      
param0 = affparam2mat(param0);                  %%The affine parameter of 
                                                %%the tracked object in the first frame
rand('state',0);  randn('state',0);
temp = importdata([dataPath 'datainfo.txt']);   %%DataInfo: Width, Height, Frame Number
TotalFrameNum = temp(3);                        %%Total frame number
frame = imread([dataPath '1.jpg']);             %%Load the first frame
if  size(frame,3) == 3
    framegray = double(rgb2gray(frame))/256;    %%For color images
else
    framegray = double(frame)/256;              %%For Gray images
end
%1.3 Load functions and parameters:
tmpl.mean = warpimg(framegray, param0, opt.tmplsize);                                                                         
%
param = [];
param.est    = param0;                                     
param.wimg   = tmpl.mean;      
param.weight = ones(size(opt.blockIndex))/(size(opt.blockIndex,1)*size(opt.blockIndex,2));
%% draw initial track window
drawopt = drawtrackresult([], 0, frame, tmpl, param);
% disp('resize the window as necessary, then press any key..'); pause;
%%***********************1.Initialization****************************%%

%%***********************2.Object Tracking***************************%%
result = [];    %%Tracking results
duration = 0; 
for num = 1:TotalFrameNum
    %%2.1 Load the (num)-th frame
    frame = imread([dataPath int2str(num) '.jpg']);
    if  size(frame,3) == 3
        framegray = double(rgb2gray(frame))/256;
    else
        framegray = double(frame)/256;
        frame = cat(3,[],framegray,framegray,framegray);
    end
    %%2.2 Do tracking
    tic;
    param = estwarp_condens(framegray, tmpl, param, opt);
    duration = duration + toc; 
    result = [ result; param.est' ];
    %%2.4 Draw tracking results
    drawopt = drawtrackresult(drawopt, num, frame, tmpl, param);   
end     
fps = num/duration;
%%***********************2.Object Tracking***************************%%

%%*************************3.STD Results*****************************%%
myCenterAll  = cell(1,TotalFrameNum);      
myCornersAll = cell(1,TotalFrameNum);
for num = 1:TotalFrameNum
    if  num <= size(result,1)
        est = result(num,:);
        [ center corners ] = p_to_box([32 32], est);
    end
    myCenterAll{num}  = center;      
    myCornersAll{num} = corners;
end
%
load(['./Data/' title '/' title '_gt.mat']);
%
[ overlapRate ] = overlapEvaluationQuad(myCornersAll, gtCornersAll, frameIndex);
mOverlapRate = mean(overlapRate);
%
mSuccessRate = sum(overlapRate>0.5)/length(overlapRate);
%
[ centerError ] = centerErrorEvaluation(myCenterAll, gtCenterAll, frameIndex);
mCenterError = mean(centerError);
%
save([ title '_RS.mat'], 'myCenterAll', 'myCornersAll',...
    'mOverlapRate', 'mSuccessRate', 'mCenterError', 'fps');
%%*************************3.STD Results*****************************%%
