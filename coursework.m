clear;

im = imread('010.jpg');

figure, imshow(im)

% Convert image to black and white
filter_av = fspecial('average', 15); % Create average filter
im_gau = imfilter(im, filter_av, 'replicate'); % Apply average filter
im_bw_reversed = im2bw(im_gau, 0.25); % Convert to b/w
im_bw = im_bw_reversed < max(im_bw_reversed(:)); % Reverse the b/w img, so foreground becomes background

% figure, imshow(im_reversed);

% Calculate and get longest boundary
bounds = boundaries(im_bw); % Get boundaries
bounds_length = cellfun('length', bounds); % Find the length of boundaries i.e. how many boundaries in bounds
[max_bounds_length, long_bound_index] = max(bounds_length); % Find the largest cell (longest boundary) of bounds and return max value/length in max_bounds_length and it's index in long_bound_index
long_bound = bounds{long_bound_index}; % Extract the longest boundary from bounds

% Convert boundary b into an image of size M-by-N so that you can see it
[img_width, img_height] = size(im_bw); % Find the size of the image to use for image of boundary
im_bound = bound2im(long_bound, img_width, img_height, min(long_bound(:, 1)), min(long_bound(:, 2))); % Convert bounds to img

figure, imshow(im_bound);

% Down-sample the number of points in the boundary
[samp, normal_samp] = bsubsamp(long_bound, 50);
im_bound_samp = bound2im(samp, img_width, img_height, min(samp(:, 1)), min(samp(:, 2))); % Convert down-sampled boundary into image
% figure, imshow(im_bound_samp)

% Connect down-sampled boundary
connected_bound = connectpoly(samp(:, 1), samp(:, 2));
im_bound_connected_samp = bound2im(connected_bound, img_width, img_height, min(connected_bound(:, 1)), min(connected_bound(:, 2))); % Convert connected, down-sampled boundary to image
% figure, imshow(im_bound_connected_samp)

chain_code = fchcode(normal_samp);
[chain_code_height, chain_code_length] = size(chain_code.diffmm);

chain_code_length