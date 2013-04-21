%% Blob Tracking with Hue Segmentation
% Author: Steven Waslander
% Version: 1.0
% Copyright: May 2009

% Load the video
if (~exist('video'))
    video = mmreader('tricycle_orange_cone.mpg')
end
% Grab the number of frames in the video
nframes = get(video, 'NumberOfFrames');

% To play the video, you can use
%implay('traffic.avi');

% For faster processing, preallocate the memory used to store the processed
% video.
tmp = read(video,1);
tmp2 = rgb2hsv(tmp);
h = size(tmp,1);
v = size(tmp,2);
processedVideo = zeros([h 2*v 3 nframes/2], class(tmp));

% Pick a hue to identify, and a form a window about that hue
hue = 10/256;
hue_window = 10/256;
hue_min = hue-hue_window;
hue_max = hue+hue_window;

% For each frame in the movie
for k = 1:nframes/2
    % Progress update
    if (~mod(k,10)) disp(k); end;
    % Read in a frame from the movie
    singleFrame = read(video, k);
    
    % Convert to HSV (note, this returns matrix of doubles)
    tmp2 = rgb2hsv(singleFrame);
    % Find all areas that are of a specific hue, and have reasonable
    % saturation
    for i=1:h
        for j=1:v
            if ((tmp2(i,j,1) >= hue_min) && (tmp2(i,j,1) <= hue_max) ... % Hue
                 &&  (tmp2(i,j,2) >= 0.1) && (tmp2(i,j,2) <= 0.9)) %... % Saturation
                 %&&  (tmp2(i,j,3) >= 0.1) && (tmp2(i,j,3) <= 0.9)) $ Value
                tmp2(i,j,:) = [0 0 1];  % Colour these pixels white
            end
        end
    end
    % Convert to rgb and then to bytes
    tmp = im2uint8(hsv2rgb(tmp2));

    % Store video (double frame)
    processedVideo(:,1:v,:,k) = singleFrame(:,:,:);
    processedVideo(:,v+1:2*v,:,k) = tmp;
end

% Run the following commands to see the video. 
  frameRate = get(video,'FrameRate');
  implay(processedVideo,frameRate);
% Store as an avi video
% movie2avi(immovie(processedVideo),'cones.avi')