clear;

im_input = imread('001.jpg');
im_sample = imread('sample.jpg');

% Calculate the mean of sample img
[img_rows, img_columns, color] = size(im_sample); % Find img size
% reshape function re-organises the sample image into a M * N-row by 3 
% column array (where M is img height and N is img width), i.e., each row
% is the RGB values of a pixel
im_matrix = reshape(im_sample, img_rows * img_columns, 3);
m = mean(im_matrix); % Finds mean of matrix

% Segment img into regions using matrix mean
im_seg = colorseg('euclidean', im_input, 100, m);
im_label = bwlabel(im_seg, 4); % Label regions

% Get bounding box from regions
stats = regionprops(im_label, 'BoundingBox');

% Get the number of regions
len = length(stats);

% If there are regions - i.e. areas that match the sample - img contains a 
% fire engine
if (len > 0)
    disp('Fire engine')
else
    disp('Not a fire engine')
end

