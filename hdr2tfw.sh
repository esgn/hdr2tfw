#!/bin/bash

for tiffFile in *.tif
do
        filename=$(basename "$tiffFile")
        filename="${filename%.*}"
        tfwFile="$filename.tfw"
        hdrFile="$filename.hdr"
        if [ -f $hdrFile ]
        then
             echo "Lecture du fichier HDR"
             ResX=$(grep -Po "(?<=^XDIM ).*" $hdrFile)
             echo "XDIM" $ResX
             ResY=$(grep -Po "(?<=^YDIM ).*" $hdrFile)
             echo "YDIM" $ResY
             nRows=$(grep -Po "(?<=^NROWS ).*" $hdrFile)
             echo "NROWS" $nRows
             nCols=$(grep -Po "(?<=^NCOLS ).*" $hdrFile)
             echo "NCOLS" $nCols
             X0=$(grep -Po "(?<=^ULXMAP ).*" $hdrFile)
             echo "X0" $X0
             Y0=$(grep -Po "(?<=^ULYMAP ).*" $hdrFile)	
             echo "Y0" $Y0

        
             ResX2=`echo "scale=2;$ResX/2" | bc -l`
             #echo "ResX2" $ResX2
             ResY2=`echo "scale=2;$ResY/2" | bc -l`
             #echo "ResY2" $ResY2
        

             echo "Calcul des éléments du TFW"
             xMin=`echo "scale=2;$ResX2+$X0" | bc -l`
             echo "xMin" $xMin
             yMax=`echo "scale=2;$Y0-$ResY2" | bc -l`
             echo "yMax" $yMax
             
             # Structure fichier TFW
             # ResX
             # 0.0
             # 0.0
             # -ResY
             # xMin
             # yMax

             ResY=`echo "scale=2;-$ResY" | bc -l `
             ResY=${ResY/#-./-0.}
             echo "ResY" $ResY

             touch $tfwFile
             echo $ResX >> $tfwFile
             echo "0.0" >> $tfwFile
             echo "0.0" >> $tfwFile
             echo $ResY >> $tfwFile
             echo $xMin >> $tfwFile
             echo $yMax >> $tfwFile
        fi 

done
