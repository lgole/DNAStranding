infolder="your image folder/"; //for example "D:/Experiment 1/image folder/"
//note: please use "/" but not "\" in folder path
//"D:/Experiment 1/image folder/" --correct
//"D:\Experiment 1\image folder\" --wrong
outfolder = infolder + "output/";
imgs = getFileList(infolder);
File.makeDirectory(outfolder);
for (i = 0; i < lengthOf(imgs); i = i + 1){
	
	imgshortname = imgs[i];
	imgpath = infolder + imgs[i];

	open(imgpath);
	run("Split Channels");
	selectWindow(imgshortname + " (blue)");
	close();
	run("Images to Stack", "name=" + imgshortname);
	saveAs("Tiff", outfolder + imgshortname);
	close();
}