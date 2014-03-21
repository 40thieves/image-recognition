function fire_engine_test(im_input)

im_sample = imread('sample.jpg');

[img_rows, img_columns, color] = size(im_sample);
im_matrix = reshape(im_sample, img_rows * img_columns, 3);
m = mean(im_matrix);

im_seg = colorseg('euclidean', im_input, 100, m);
im_label = bwlabel(im_seg, 4);

stats = regionprops(im_label, 'BoundingBox');
len = length(stats);

if (len > 0)
    disp('Fire engine')
end

