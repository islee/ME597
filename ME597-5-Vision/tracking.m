%% Detecting Cars in a Video of Traffic
% Author: Steven Waslander
% Version: 1.0
% Copyright: May 2009

% Load the video
video = mmreader('streettraffic.avi')
% Grab the number of frames in the video
nframes = get(video, 'NumberOfFrames');

% To play the video, you can use
%implay('traffic.avi');

% Save the first image as the background image to subtract from subsequent
% images
background = read(video, 120);

% For faster processing, preallocate the memory used to store the processed
% video.
h = size(background,1);
v = size(background,2);
processedVideo = zeros([h 2*v 3 nframes], class(background));
tmp = background;
tmpbw = im2bw(tmp, graythresh(tmp));

for k = 1 : nframes
    singleFrame = read(video, k);
    
    tmp = imabsdiff(singleFrame, background);
    
    tmpbw = im2bw(tmp, graythresh(tmp));
    [B, L, N, A] = bwboundaries(tmpbw);
    Bs{k} = B;
    processedVideo(:,1:v,:,k) = singleFrame(:,:,:);
    processedVideo(:,v+1:2*v,:,k) = tmp;
    for i=1:length(B)
        bndry = B{i};
        processedVideo(bndry(:,1),v+bndry(:,2),1,k) = 100; 
    end

end

% Run the following commands to see the video. 
  frameRate = get(video,'FrameRate');
  implay(processedVideo,frameRate);
% Store as an avi video
movie2avi(immovie(processedVideo),'traffic.avi')