#!/bin/bash

# shopt permite cambiar el comportamiento predeterminado de la shell. En este caso, setea la opcion
# nullglob, que hace que el ciclo for que viene despues se termine solo si ve que no hay archivos .txt.
# Si no estuviera, cuando el for buscara por *.txt y no encontrase, pasaria *.txt como el nombre del archivo y haría crashear al cat.
shopt -s nullglob

# Usando un ciclo for recorre todos los archivos .txt de la carpeta entrada, les copia el contenido a $FILENAME.txt y despues los mueve a procesado.
# Usa $(pwd) porque se corre desde menu.sh que esta en otro directorio, entonces necesita poner el path completo en vez del relativo
# También redirige los errores a /dev/null para que no aparezcan en la pantalla cuando se termine el ciclo.
while true; do 
    for file in "$(pwd)"/EPNro1/entrada/*.txt; do
        cat "$file" >> "$(pwd)"/EPNro1/salida/"$FILENAME.txt" &&
        mv "$file" "$(pwd)"/EPNro1/procesado/
    done
    # Pause el proceso por 3 segundos para no saturar la CPU
    sleep 3
done