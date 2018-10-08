//1/28/18: Threshold Step might be your issue. Try adjusting that.



//NOTE: Change the file names on lines 7 and 33, otherwise the macro will not run.
//Last index point - numberOfPoints = beginning point

run("Clear Results");
selectWindow("90-Maxmrad512512.tif"); //Will have to open picture and change line to match file name
getPixelSize(unit, pixelWidth, pixelHeight) //Get resolution of image.
waitForUser(pixelWidth);
waitForUser(pixelHeight);

//Brightness/Contrast Step
//run("Brightness/Contrast...");
//setMinAndMax(-3,3);

//Threshold step
run("Duplicate...", "duplicate");
setAutoThreshold("Default dark");
setThreshold(706542.4510, 1470050.5000);
run("NaN Background", "stack");
//setAutoThreshold("Default dark");
//run("Threshold...");

//Noise reduction step
//run("Convert to Mask");
//run("Despeckle");
//run("Make Binary");
//run("Erode");
//run("Erode");
//run("Minimum...", "radius=0.08");


//Set measurement step
run("Set Measurements...", "mean center limit add redirect=[90-Maxmrad512512.tif] decimal=3"); //Rename redirect here to original file name in Line 3.
run("Analyze Particles...", "size=1.5 circularity=0.2 pixel show=Nothing display clear add");
rad = getNumber("Input circle diameter (Units are in Pixels)", 0);
numberOfPoints = getValue("results.count");
waitForUser("Start Data Analysis after this point:")
waitForUser(numberOfPoints) //Mark this number down. It will be used to distinguish between the particles and circle ROIs.


//Make circle ROIs
for (i = 0; i < numberOfPoints; i++) {
    X = getResult("XM", i);
    //waitForUser(X/pixelWidth); //Debugging purposes
    Y = getResult("YM", i);
    //waitForUser(Y/pixelHeight); //Debugging purposes
    makeOval((X/pixelWidth)-(rad/2), (Y/pixelHeight)-(rad/2), rad, rad);
    roiManager("Add");
}



//http://forum.imagej.net/t/create-a-roi-set-using-xy-coordinates/5997
//http://imagej.1557.x6.nabble.com/Macro-Language-select-all-masks-from-ROI-Manager-td5004323.html
run("Analyze Particles...", "display"); //Analyzes circles for their mean greyscale values, and adds to the Results table.
array1 = newArray("0");
for (i=1;i<roiManager("count");i++){
        array1 = Array.concat(array1,i);
        Array.print(array1);
}
roiManager("select", array1);
roiManager("Measure"); //Remember to save your data!