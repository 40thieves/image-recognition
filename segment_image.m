function im_output = segment_image(im_input)

% Select a region interest (ROI) interactively
mask = roipoly(im_input);
figure, close all

% Retrieve the red, green, blue components of the pixels inside ROI
red = immultiply(mask, im_input(:,:,1));
green = immultiply(mask, im_input(:,:,2));
blue = immultiply(mask, im_input(:,:,3));

% Assemble the RGB components to restore the image in the ROI (image g)
im_color_sample = cat(3, red, green, blue);

% !!!!!! SAVE im_color_sample !!!!!!

% Pre-processing for calculating the covariance matrix
[img_rows, img_columns, color] = size(im_color_sample); % M-rows, N-columns and K-colour components

% Function reshape re-organises the sample image into a M * N-row by 3
% column array, i.e., each row is the rgb values of a pixel
img_matrix = reshape(im_color_sample, img_rows * img_columns, 3);

% Find the row indices of non-zero pixels of the mask
row_indices = find(mask);

% Use the indices to remove the zero components in I
img_matrix = double(img_matrix(row_indices, 1:3));

% Compute covariance matrix C and the mean m of the samples
[covariant, mean] = covmatrix(img_matrix);

im_output = colorseg('euclidean', im_input, 90, mean);

