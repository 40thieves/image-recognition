function oversize_test(image)

% Calculate img dimensions
[img_width, img_height] = size(image);
img_center_height = img_height / 2;

im_label = bwlabel(image, 4);

% Get bounding box width
% Returns a set of properties (defined by the arguments passed in)
stats = regionprops(im_label, 'Centroid', 'ConvexArea', 'BoundingBox');

% Find region with largest area, and it's index
[max_area, max_index] = max([stats.ConvexArea]);

% Calculate the centroid of the region
centroids = [stats.Centroid];

% Convert largest area index to centroid's index
centroid_index = (max_index * 2) - 1;

% Get the centroid with the largest area
centroid = [centroids(centroid_index), centroids(centroid_index + 1)];

% Calculate pixel difference of centroid from image center
if centroid(2) < img_center_height
    % Above center
    diff_px = img_center_height - centroid(2);
else
    % Below center
    diff_px = centroid(2) - img_center_height;
end

% Using pixel difference, calculate centroid's angle from center
diff_deg = 60 + (diff_px * 0.042);

% Calculate centroid's distance from camera
distance = 7 * tand(diff_deg);

img_width_m = 2 * (distance * sind(13.44));
pixel_m_ratio = 640 / img_width_m;

% Find bounding box around largest region
bound_box = stats(max_index).BoundingBox;
bound_width = bound_box(3);

% Convert pixel numbers to meters
bound_width_m = bound_width / pixel_m_ratio;

disp('Width in metres: ')
disp(bound_width_m)


















