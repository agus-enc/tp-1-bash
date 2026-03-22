#!/bin/bash

# Crea y exporta la variable de ambiente para usar en consolidar.sh
FILENAME="archivo"
export FILENAME

echo "Bienvenido al menu"

#Crea un array con los nombres de las opciones
opciones=( "Crear entorno" "Correr proceso" "Mostrar alumnos" "Mostrar mejores notas" "Buscar alumno" "Salir" )
# PS3 es la variable predeterminda para promptear al usuario cuando usas select, quise ponerle otro nombre mas descriptivo pero no se puede
PS3="Elija una de las opciones: "

# select toma los items del array y los pone en forma de lista numerada, formando el menu
select opcion in "${opciones[@]}"
do
    # REPLY es la variable predeterminda para el input del usuario, bash la usa para saber que opcion de select se eligio
    # Usa case para poder tener una acción distinta para cada opción
    case "$REPLY" in

        # Crea las carpetas pedidas, mueve consolidar.sh a EPNro1 y crea el archivo donde van a parar los textos procesados
        1)  mkdir -p EPNro1/{entrada,salida,procesado} && mv consolidar.sh EPNro1/. && touch EPNro1/salida/$FILENAME.txt &&
            echo "Entorno creado exitosamente";;

        # Ejecuta consolidar.sh en background, chequeando si existe el proceso antes.
        2)  if pgrep -f "consolidar.sh"; then
                echo "El proceso ya está corriendo. No se iniciará una nueva instancia."
            else
                # Con las redirecciones nos aseguramos que no aparezca el archivo nohup.out
                nohup ./EPNro1/consolidar.sh > /dev/null 2>&1 & 
                echo "Corriendo proceso en background"
            fi;;

        3)  archivo="$HOME/EPNro1/salida/$FILENAME.txt"
           if [ -f "$archivo" ]; then
              echo "Mostrando listado de alumnos por padron:"
              sort -n -k1 "$archivo"
           else 
              echo "No se encontraron archivos"
            fi
        ;;
	
	    4) archivo="$HOME/EPNro1/salida/$FILENAME.txt"
           if [ -f "$archivo" ]; then
              echo "Mostrando las primeras 10 mejores notas"
              sort -n -k4 "$archivo" | head
        ;;

	    5)  echo "Ingresar padron";;

	    6)  echo "saliste"
            exit;;
    esac
done