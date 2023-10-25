//Loop to do FTTC on each PIV files for each frame


//Change parameters here////

Nframes=241; //Number of frames in the original movie
///////////////////////////////////////////

file = "D://140722 coculture tfm processed/pos12/FTTC/"; //folder where PIVXXX.txt is stored

for (i = 0; i <Nframes; i++){   // 
j=i+1;
run("FTTC ", "pixel=0.216 poisson=0.5 young's=15000 regularization=0.000000000 plot=1152 plot=1152 select=["+file+"PIV"+j+".txt]");     //***********************************************************
}


