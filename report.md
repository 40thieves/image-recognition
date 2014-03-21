## Advanced Computer Graphics and Vision: Image Recognition Task

The application processes images of traffic travelling through a tunnel and attempts to recognise vehicles and calculate their speed and size. 

* Images read into the system
* Fire engine test
	* Uses a colour single image
	* Reads sample image
		* Small red image, taken from original image of fire engine
	* Reorganises sample image into M * N by 3 array where each row represents the RGB values of a pixel
	* Finds the mean of the sample image array
	* Segments the input image based on the mean colour of the sample
		* Experimented with values until a good result was found
	* Image split into regions
	* ConvexArea and BoundingBox properties found for each region
	* If no regions are found, image does not contain a fire engine
	* If regions are found, the largest region is found (assumed to be the region for the object)
	* The width-to-height ratio of the BoundingBox is found
	* If the width-to-height ratio is greater than 1.7, the image contains a fire engine
		* This value based of the width-to-height ratio of the original image of fire engine
* Image segmentation
	* Average filter is created
		* Not LoG - an "averaging" filter
		* Experimented with other filters, and found this to produce the best results
	* If second (sample) image _is not_ provided - i.e. input as an empty string
		* Filters image using average filter alone
		* Converts image to b&w using threshold
			* Experimented with values until best results found
		* Resulting image is reversed - background is foreground and vice versa
		* So reverse the image to get true b&w
	* If second (sample) image _is_ provided
		* Image subtraction is performed, where the sample image is removed from the main image
			* Found to be best for removing noise in top left of image
		* Image filtered using average filter
			* Further reduces noise
		* Image converted to b&w using threshold
* Speed test
	* 2 frames passed in - need to compare the two to calculate speed
	* Image center is calculated (same for both images)
		* Important for geometry
	* Images split into regions
	* ConvexArea and BoundingBox properties found for each region
	* The largest region for each image is determined using the convex area properties
	* The bounding box of this region is retrieved
	* The centroid of the bounding box is found
	* The difference in number of pixels along the y axis between the centre of the image and the centroid of the bounding box is found
	* The distance in pixels is converted to degrees
	* The distance from the camera is calculated for each image
		* `7 * tand(degrees)`
	* The difference in distance between the two vehicles is calculated
	* The distance is converted to speed in m/s
		* Time between frames assumed to be 0.1s
	* Speed in m/s converted to mph
* Oversize test
	* Somewhat similar to speed test
		* Need to calculate distance from camera
		* But only applied to 1 image
	* Image centre is found
	* Image split into regions
	* ConvexArea and BoundingBox properties found for each region
	* The largest region for each image is determined using the convex area properties
	* The bounding box for this region is retrieved
	* Centroid for bounding box is found
	* The difference in number of pixels along the y axis between the centre of the image and the centroid of the bounding box is found
	* The distance in pixels is converted to degrees
	* The distance from the camera is calculated
	* Width of bounding box (in pixels) converted to degrees
	* Width in meters is calculated
		* `distance * tand(degrees)` - gives half width
		* This value multiplied by 2 to get full width
	* If width is over 2.5, the vehicle is oversized

__Instructions__

* Script
	* Run the `coursework` script
	* Output printed to Command Window
* Function
	* Call the `coursework_func` function
	* 2 arguments
		* Path to image files
	* Second image can be an empty string
		* Only performs fire engine and oversize tests
		* No second image to compare for speed
