Program options:
ground_truth_path: The relative path to the "PETS2009-S2L1.xml" file
src_path: The relative path to the folder containing the images in JPG format

constrastTh: The luminance threshold to separate the image regions
minArea: The minimum are to consider a detection
medianSize: Size of the median filter to process the regions
matchingTh: Minimum IoU threshold to match regions
edgeDistanceTh: The distance from the edges for the tracking algorithm

subset_size: Number of samples used to extract the background

showGT: Show the ground truth
showBBox: Show the computed bounding boxes
showIds: Show the ID labels given to the objects
showMarkers: Show the trajectory markers
num_markers: The number of markers that linger in each trajectory

showHeatmap: Show the heatmap
isHeatmapDynamic: Toggle between static and dynamic heatmap
isHeatapManhattan: Toggle between Gaussian and Manhattan heatmap
heatmapStd: The size influence of each object on the screen

showOptflow: Plot the optical flow plot (mutually exclusive with heatmap) 