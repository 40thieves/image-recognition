function oversize_test(image)

% Calculate img dimensions
[img_height, img_width] = size(image);
img_center_x = img_width / 2;
img_center_y = img_height / 2;

im_label = bwlabel(image, 4);

% Calculate ConvexArea and BoundingBox properties of the regions
stats = regionprops(im_label, 'ConvexArea', 'BoundingBox');

% Determine the largest region (by ConvexArea) and it's index
[max_area, max_area_index] = max([stats.ConvexArea]); % max_area is not required, only it's index

% Use largest region's index to retrieve it's BoundingBox
bound_box = stats(max_area_index).BoundingBox;

% Retrieve BoundingBox properties
% The BoundingBox contains values in the following order: upper left
% position for x, upper left position for y, width, height
bound_box_pos_x = bound_box(1);
bound_box_pos_y = bound_box(2);
bound_box_width = bound_box(3);
bound_box_height = bound_box(4);

% Calculate the centre of the bounding box
centroid_x = bound_box_pos_x + (bound_box_width / 2);
centroid_y = bound_box_pos_y + (bound_box_height / 2);

% Calculate the difference (in pixels) between the centre of the image and
% the centre of bounding box
diff_px = img_center_y - centroid_y;

% Convert the difference in pixels to difference in degrees and add to
% degrees from vertical (60)
diff_deg = 60 + (diff_px * 0.042);

% Calculate the (horizontal) distance between the camera and object
horizontal_distance = 7 * tand(diff_deg);

% Calculate the distance from camera to object (i.e. the hypotenuse)
distance = hypot(7, horizontal_distance);

% Calculate the width of the bounding box in degrees
width_deg = (bound_box_width / 2) * 0.042;

% Calculate the width of the bounding box in meters
width_m = 2 * (distance * tand(width_deg));

disp('Width in metres: ')
disp(width_m)

if (width_m > 2.5)
    disp('Contains an oversized vehicle')
else
    disp('Does not contain an oversized vehicle')
end