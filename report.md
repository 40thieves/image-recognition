## Advanced Computer Graphics and Vision: Image Recognition Task

The application processes images of traffic travelling through a tunnel and attempts to recognise vehicles and calculate their speed and size. For instructions on usage, please see the `readme` file included with the program. 

### System Design

#### Fire engine test

The first test attempted by the system is the test for a fire engine. This test will process a colour image to detect a vehicle that is coloured red and has a width-to-height ratio of approximately 1:1.7. A sample image is read into memory, originally sampled from an image of a fire engine, so that the colours can be tested to see if they match.

The application will transform the sample image data into a M-by-N-by-3 array, where M is the height of the test image and N is the width. Within this array, each row represents the RGB values of each individual pixel. The mean value of this array is then calculated.

The test image is then segmented into a binary image, based on regions that match the mean colour of the sample. The parameters (a threshold of 100) for this segmentation were experimented with until the best results were found. The first test is performed here - if no regions are found to match the sample, then the image does not contain a fire engine.

However, not all red vehicles are fire engines, and so a further test is required for the width-to-height ratio. The `regionprops` function is used to find `ConvexArea` and `BoundingBox` properties for each region. The `ConvexArea` property is used to find the largest region, which is assumed to be the detected vehicle. The `BoundingBox` property is also found for this region, which effectively draws a box around the entire region. From this, the width and height of the region can be calculated, and thus, the width-to-height ratio. If this ratio is greater than 1:1.7, then the image contains a fire engine.

#### Image segmentation

To perform the speed test, both images will need to be segmented to isolate the vehicle. Firstly, the function creates a "averaging" filter that will average pixel values within it's 10-by-10 mask. This will help to reduce noise in the image by filling small holes and expanding large areas. Other filters were tested, however this was found to produce the best results.

The function allows for a sample image to be passed in. If provided the function will perform image subtraction on the two images, where areas from the sample image will be removed from the main image. This was found to be very effective at removing noise, especially in the top left of the images. The resulting image is further filtered using the average filter discussed above, before conversion to a binary image using a threshold of 0.3.

If a sample image is not provided, the image is filtered using the average filter followed by conversion to binary using a threshold of 0.25. Various values were tried before this was found to produce the best results. The resulting binary image, however, is reversed, with the background as foreground and vice versa. This is reversed back, giving the desired binary image.

#### Speed test

Once these binary images have been produced, the speed test is applied. All of the following actions have to be applied to both images. The largest region is found using the `ConvexArea` property, and this region's `BoundingBox` is found. The centroid of the bounding box is calculated, which is preferred over the `Centroid` property of the region. This is because the `Centroid` property is calculated from the "centre of mass" of the region, which may not reflect the actual centre of the vehicle. The distance (in pixels) along the y-axis between the centre of the image and the region's centroid is then found. This is converted to the number of degrees the vehicle is off-centre, as shown below.

![Diagram showing geometrical layout of the camera and vehicles](img/distance.png)

This can be simplified to give two triangles, where the angle and the length of one side is known.

![Diagram showing the simplified geometrical layout for the camera and vehicle in the first frame](img/trig-before.png)

This can be solved using trigonometry using the following formula.

![Equation for finding the vehicle's (horizontal) distance from the camera](img/equation-distance.png)

Once the distance has been calculated for both images, the distance between the vehicles can be found. It is assumed that the time elapsed between the two frames is 0.1 seconds. Using this, the speed in meters per second can be calculated. This is then converted to miles per hour.

#### Oversize test

The final test performed is the oversized vehicle test. This test shares much of the speed test's approach, by calculating the vehicle's distance from the camera in order to scale the width. However it differs in that only one image is required for the process. Regions within the image are found and the largest region's `BoundingBox` is found. The centroid of this box is used to calculate the vehicle's distance from the camera. The `BoundingBox`'s width in pixels is converted to degrees. Using this angle and the distance to the vehicle, the width in meters can be calculated. This is shown in the diagram below:


* __WIDTH DIAGRAM__

If the vehicle's width is over 2.5m, the vehicle is oversized, which is output to the Command Window.

#### Coursework function

A function is provided that will perform all of these tests when given file paths to 2 images. This will call the functions described above. If a speed test is not required, or no second image is available, an empty string can be passed as the second argument.

### Testing

The application was tested with the images provided, during the implementation phase and afterwards to ensure that it performs as expected. This was done by viewing the produced output and comparing it to the original input, estimating how effectively they match. This means that the various parameters that can be set could be adjusted until the best results were found. This reflects a real-world situation, where image recognition applications are adjusted for their purpose until the best results are achieved.

### Evaluation

The application achieves it's aims by effectively detecting vehicles and calculating their speed and size. This means that vehicles can be tested to see if they pass the rules set out in the requirements. The main success of the application is the detection of vehicles within the image. This is shown in the following images, before and after segmentation has occurred.

![Before and after image segmentation of image `001.jpg`](img/before-after.png)

Another success of the application is the colour segmentation of fire engines. This allows very accurate segmentation of a specific vehicle, something that is required by the specification.

However, the application was not tested with images of different cars, with various colours and shapes. This means that it may be unsuitable for application in a non-academic scenario. For this to be achieved, the application would have to be further tested and adjusted to the distinct requirements of a real-world situation.