
//-------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------//
//Macro function:
//For calculating TFM displacements. Open one reference bead image, and the other stack with cells on it.
//Then, this macro will make a new stack: ref, stack-frame1, ref, stack-frame2, ref, .... 
// Drift will be corrected and also glare gotten rid off. 
//Drift transformation is saved, and can be applied to separate stacks.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


file = "D://140722 coculture tfm processed/pos12/ForPIV/" ; //change the pathname into the folder for saving output


//waitForUser("Select the reference frame");
selectWindow("Ref.tif");
rename("Ref");
//waitForUser("Select the WithCells.tif")
selectWindow("WithCells.tif");
rename("WithCells");


selectWindow("WithCells");
run("Enhance Contrast...", "saturated=0.2 normalize process_all");  // normalise all contrast

InitialStackNumber=nSlices;//numbeer of slices

selectWindow("Ref");
run("Enhance Contrast...", "saturated=0.2 normalize process_all");  // normalise all contrast


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////Multiply Ref and make Ref Stack - ofr use with MultiStackReg//////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///duplicate ref frame, required for movie analysis
/*
    selectWindow("Ref");
    for (i=1; i<InitialStackNumber; i++){
         selectWindow("Ref");
          run("Duplicate...", " ");  
    }
   run("Images to Stack", "name=Stack title=[] use");

   selectWindow("Stack");
   rename("RefStack");
   run("Duplicate...", "title=Ref duplicate range=1-1");
*/

//////////////////////////////////////////////////////////////////////////////
///////////////FINISH multiplying Ref/////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////Use MultiStackReg//////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
run("MultiStackReg", "stack_1=WithCells action_1=[Use as Reference] file_1=[] stack_2=Ref action_2=[Align to First Stack] file_2=[] transformation=[Translation] save");//for single frame
//run("MultiStackReg", "stack_1=Ref action_1=[Use as Reference] file_1=[] stack_2=WithCells action_2=[Align to First Stack] file_2=[] transformation=[Translation] save");//for movie
//////////////////////////////////////////////////////////////////////////////
///////////////FINISH MultiStackReg/////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////Insert reference Image for each frame in the stack, right before each of the frames///////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Creat ForPIV stack
selectWindow("WithCells");
run("Duplicate...", "duplicate");
rename("test1");
selectWindow("WithCells");
run("Duplicate...", "duplicate");
rename("test2");
run("Concatenate...", "  title=[ForPIV] image1=test1 image2=test2 image3=[-- None --]");
//// Insert the correct frame into ForPIV
for (i=1; i<=InitialStackNumber; i++){
   selectWindow("Ref");
   setSlice(i);
   run("Copy");
   selectWindow("ForPIV");
   setSlice(2*i-1);
   run("Paste");
   
   selectWindow("WithCells");
   setSlice(i);
   run("Copy");
   selectWindow("ForPIV");
   setSlice(2*i);
   run("Paste");
}
//////////////////////////////////////////////////////////////////////////////
///////////////FINISH Inserting/////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////Now normalise all contrast in all frames, then correct drift, then remove glare///////////////////////////
 selectWindow("ForPIV");
   run("8-bit");
 run("Normalize Local Contrast", "block_radius_x=50 block_radius_y=50 standard_deviations=4 center stretch stack");   // remove glare
 //waitForUser();
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//waitForUser("Save ForPIV as Image Sequences into respective folders as (ForPIV_XXXX)");
for (i=1; i<=InitialStackNumber*2; i++){
   selectWindow("ForPIV");
   setSlice(i);
   if(i<10){
	   filename = "ForPIV_00";
	   run("Duplicate...", "title="+filename+i+".tif");
	   saveAs("Tiff", file+filename+i+".tif");
	   close();
   }
   else if(i<100){
	   filename = "ForPIV_0";
	   run("Duplicate...", "title="+filename+i+".tif");
	   saveAs("Tiff", file+filename+i+".tif");
	   close();
   }
   else{
	   filename = "ForPIV_";
	   run("Duplicate...", "title="+filename+i+".tif");
	   saveAs("Tiff", file+filename+i+".tif");
	   close();
   }
}
//-------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------//



/*
//------------------------------------------Last part-------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------//
waitForUser("Open phase-cell movie");

run("Duplicate...", "duplicate");
rename("test");

selectWindow("test");

run("MultiStackReg", "stack_1=test action_1=[Load Transformation File] file_1=["+ file+ "TransformationMatrices.txt] stack_2=None action_2=Ignore file_2=[] transformation=[Translation]");    //******************************************************

      
//------------------------------------------Last part-------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------//
*/











