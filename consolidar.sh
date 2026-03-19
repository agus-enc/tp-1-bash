#!/bin/bash

# Usando un ciclo for recorre todos los archivos .txt de la carpeta entrada, 
# les copia el contenido a $FILENAME.txt y despues los mueve a procesado.
# Usa $(pwd) porque se corre desde menu.sh que esta en otro directorio, entonces necesita poner el path completo en vez del relativo
for file in $(pwd)/EPNro1/entrada/*.txt; do
    cat $file >> $(pwd)/EPNro1/salida/"$FILENAME.txt" &&
    mv $file $(pwd)/EPNro1/procesado/
done