function fire_engine_test(im_input)

% Read sample img
im_sample = imread('sample.jpg');

% Reorganise sample img into M * N * 3 array where each row represents the
% RGB values of a pixel
[img_rows, img_columns, color] = size(im_sample); % Determine size of img
im_matrix = reshape(im_sample, img_rows * img_columns, 3);

% Determine the mean color for the sample img
m = mean(im_matrix);

% Segment the image based on color of sample img
im_seg = colorseg('euclidean', im_input, 100, m);

% Label segmented img into regions
im_label = bwlabel(im_seg, 4);

% Retrieve ConvexArea and BoundingBox properties of regions
stats = regionprops(im_label, 'ConvexArea', 'BoundingBox');

% Test number of regions, if none found img does not contain a red object
len = length(stats);
if (len > 0)
    % Determine the index of the largest region and use this to find it's
    % BoundingBox
    [max_area, max_area_index] = max([stats.ConvexArea]); % max_area is not needed, only it's index
    bound_box = stats(max_area_index).BoundingBox;

    % Retrieve the width and heights of the BoundingBox
    bound_box_width = bound_box(3);
    bound_box_height = bound_box(4);

    % Calculate the width-to-height ratio of the BoundingBox
    ratio = bound_box_height / bound_box_width;

    % If ratio is higher than 1.7, img contains a fire engine
    if (ratio >= 1.7)
       disp('Contains a fire engine')
    else
        disp('Does not contain a fire engine')
    end
else
    disp('Does not contain a fire engine')
end