function fire_engine_test(im_input)

im_sample = imread('sample.jpg');

[img_rows, img_columns, color] = size(im_sample);
im_matrix = reshape(im_sample, img_rows * img_columns, 3);
m = mean(im_matrix);

im_seg = colorseg('euclidean', im_input, 100, m);
im_label = bwlabel(im_seg, 4);

stats = regionprops(im_label, 'ConvexArea', 'BoundingBox');

len = length(stats);
if (len > 0)
    [max_area, max_area_index] = max([stats.ConvexArea]);
    bound_box = stats(max_area_index).BoundingBox;

    bound_box_width = bound_box(3);
    bound_box_height = bound_box(4);

    ratio = bound_box_height / bound_box_width;

    if (ratio > 1.7)
       disp('Fire engine') 
    end
else
    disp('Not a fire engine')
end


