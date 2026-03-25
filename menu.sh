#!/bin/bash

# Crea y exporta la variable de ambiente para usar en consolidar.sh.
FILENAME="archivo"
export FILENAME

# Si el script se ejecuta con el flag -d, busca y mata el proceso por nombre.
if [ "$1" == "-d" ]; then
    if pgrep -f "consolidar.sh" > /dev/null; then
            pkill -f "consolidar.sh" && echo "Proceso en background terminado."
        else
            echo "No hay procesos corriendo en background."
        fi

        # Rescata consolidar.sh y los archivos de texto antes de eliminar todo el entorno.
        mv EPNro1/consolidar.sh EPNro1/{entrada,procesado}/*.txt "$(pwd)"/ 2>/dev/null
        rm -r ./EPNro1 2>/dev/null
        exit 0
fi

echo "Bienvenido al Menu"

#Crea un array con los nombres de las opciones.
opciones=( "Crear Entorno" "Correr Proceso" "Mostrar listado de alumnos ordenado por padrón" "Mostrar las 10 mejores notas del listado" "Buscar Alumno" "Salir" )
# PS3 es la variable predeterminda para promptear al usuario cuando usas select.
PS3="Elija una de las opciones: "

# select toma los items del array y los pone en forma de lista numerada, formando el menu.
select opcion in "${opciones[@]}"
do
    # REPLY es la variable predeterminda para el input del usuario, bash la usa para saber que opcion de select se eligio.
    # Usa case para poder tener una acción distinta para cada opción.
    case "$REPLY" in

        # Crea las carpetas pedidas, mueve consolidar.sh a EPNro1, mueve los archivos de prueba a entrada y crea el archivo donde van a parar los textos procesados
        1)  mkdir -p EPNro1/{entrada,salida,procesado} &&
            mv consolidar.sh EPNro1/. && mv *.txt EPNro1/entrada/
            touch EPNro1/salida/$FILENAME.txt &&
            echo "Entorno creado exitosamente";;

        # Ejecuta consolidar.sh (si es que no esta corriendo ya) en background de forma que sobreviva aun si termina menu.sh.
        2)  if pgrep -f "consolidar.sh"; then
                echo "El proceso ya está corriendo. No se iniciará una nueva instancia."
            else
                # Con las redirecciones nos aseguramos que no aparezca el archivo nohup.out
                nohup ./EPNro1/consolidar.sh > /dev/null 2>&1 & 
                echo "Corriendo proceso en background"
            fi;;

        3)  archivo="$(pwd)/EPNro1/salida/$FILENAME.txt"
           if [ -f "$archivo" ]; then
              echo "Mostrando listado de alumnos por padron:"
              sort -n -k1 "$archivo"
           else 
              echo "No se encontraron archivos"
            fi
        ;;
	
	    4) archivo="$(pwd)/EPNro1/salida/$FILENAME.txt"
           if [ -f "$archivo" ]; then
              echo "Mostrando las primeras 10 mejores notas"
              sort -n -k4 "$archivo" | head
            fi
        ;;

	    5) archivo="$(pwd)/EPNro1/salida/$FILENAME.txt"
            if [ -f "$archivo" ]; then
                read -p "Ingrese numero de padron: " padron
                grep "^$padron " "$archivo" || echo "Padron no encontrado"
            fi
        ;;

	    6)  echo "Chau chau"
            exit;;
    esac
done