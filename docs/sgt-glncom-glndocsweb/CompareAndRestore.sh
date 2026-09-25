#!/bin/bash

clear
SRC="C:/Users/n63623/Downloads/GDocs/docs/"
DST="docs/"
#SRC="C:/Users/n63623/Downloads/pruebas/source"
#DST="C:/Users/n63623/Downloads/pruebas/target"

echo "++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Comparando y restaurando ficheros diferentes o nuevos"
echo ""
echo "Datos de comparación y restauración:"
echo "Origen: $SRC"
echo "Destino: $DST"

# compara numero

if [ -z "$SRC" ] || [ -z "$DST" ]; then
    echo "Uso: $0 <carpeta1> <carpeta2>"
    exit 1
fi

COUNT1=$(find "$SRC" -type f | wc -l)
COUNT2=$(find "$DST" -type f | wc -l)

# Guardar valores iniciales para el resumen ejecutivo
COUNT1_INICIAL=$COUNT1
COUNT2_INICIAL=$COUNT2

echo ""
echo "-------------------------------------"
echo ""
echo "Antes de la copia"
echo "Ficheros en Origen: $COUNT1"
echo "Ficheros en Destino: $COUNT2"

if [ "$COUNT1" -eq "$COUNT2" ]; then
    echo "Ambas carpetas tienen el mismo número de ficheros."
else
    echo "Diferencia: $((COUNT1 - COUNT2))"
fi

echo ""
echo "-------------------------------------"
echo ""
echo "Comprobación del estado antes de la sincronización:"

# Ejecutar diff una sola vez y guardar todos los resultados
echo "Analizando diferencias entre carpetas..."
diff -qr "$SRC" "$DST" > diff_complete.txt 2>/dev/null

# Filtrar y separar los diferentes tipos de archivos de forma optimizada
grep -E "differ" diff_complete.txt > diff_list_antes.txt 2>/dev/null || touch diff_list_antes.txt
grep -E "Only in $SRC" diff_complete.txt >> diff_list_antes.txt 2>/dev/null
grep -E "Only in $DST" diff_complete.txt > deleted_files.txt 2>/dev/null || touch deleted_files.txt

# Calcular contadores de forma optimizada
NUM_NUEVOS=$(grep -c "Only in $SRC" diff_list_antes.txt)
NUM_MODIFICADOS=$(grep -c "differ" diff_list_antes.txt)
NUM_ELIMINADOS=$(grep -c "Only in $DST" deleted_files.txt)

echo "Resumen antes de sincronizar:"
echo "  Archivos nuevos: $NUM_NUEVOS"
echo "  Archivos modificados: $NUM_MODIFICADOS"
echo "  Archivos eliminados: $NUM_ELIMINADOS"
echo "-----------------------------------------------"

# Petición de confirmación antes de proceder
echo ""
echo "¿Desea proceder con la sincronización? (s/N): "
read -r CONFIRMACION

if [[ ! "$CONFIRMACION" =~ ^[sS]$ ]]; then
    echo "Sincronización cancelada por el usuario."
    echo "No se han realizado cambios."
    # Limpiar archivos temporales
    rm -f diff_complete.txt diff_list_antes.txt deleted_files.txt modified_files_temp.txt new_files_temp.txt
    exit 0
fi

echo "Procediendo con la sincronización..."
echo ""

# Sincronización
echo ""
echo "Procesando archivos para sincronización..."

# Procesar archivos modificados - método optimizado
echo "Copiando archivos modificados:"
# Crear archivo temporal para archivos modificados
grep "differ" diff_list_antes.txt > modified_files_temp.txt 2>/dev/null || touch modified_files_temp.txt

# Contador para mostrar progreso
CONTADOR_MOD=0
TOTAL_MOD=$NUM_MODIFICADOS

while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        # Extraer las rutas usando sed de forma más robusta
        SRC_FILE=$(echo "$line" | sed -n "s/Files \(.*\) and .* differ/\1/p" | sed "s/^'//;s/'$//")
        
        if [[ -n "$SRC_FILE" && -f "$SRC_FILE" ]]; then
            REL_PATH=$(echo "$SRC_FILE" | sed "s|^$SRC/||")
            DEST_PATH="$DST/$REL_PATH"
            
            # Crear directorio de destino si no existe
            mkdir -p "$(dirname "$DEST_PATH")" 2>/dev/null
            
            # Copiar archivo con manejo de errores
            if cp "$SRC_FILE" "$DEST_PATH" 2>/dev/null; then
                CONTADOR_MOD=$((CONTADOR_MOD + 1))
                echo "  [$CONTADOR_MOD/$TOTAL_MOD] Copiado modificado: $(basename "$SRC_FILE")"
            else
                echo "  Error copiando: $(basename "$SRC_FILE")"
            fi
        fi
    fi
done < modified_files_temp.txt

# Procesar archivos nuevos - método optimizado
echo "Copiando archivos nuevos:"
# Crear archivo temporal para archivos nuevos
grep "Only in $SRC" diff_list_antes.txt > new_files_temp.txt 2>/dev/null || touch new_files_temp.txt

# Contador para mostrar progreso
CONTADOR_NEW=0
TOTAL_NEW=$NUM_NUEVOS

while IFS= read -r line; do
    if [[ -n "$line" && $line =~ Only\ in\ (.*):\ (.*)$ ]]; then
        DIR="${BASH_REMATCH[1]}"
        FILE_NAME="${BASH_REMATCH[2]}"
        # Limpiar comillas si existen
        FILE_NAME=$(echo "$FILE_NAME" | sed "s/^'//;s/'$//")
        
        SRC_FILE="$DIR/$FILE_NAME"
        if [[ -f "$SRC_FILE" ]]; then
            REL_PATH=$(echo "$SRC_FILE" | sed "s|^$SRC/||")
            DEST_PATH="$DST/$REL_PATH"
            
            # Crear directorio de destino si no existe
            mkdir -p "$(dirname "$DEST_PATH")" 2>/dev/null
            
            # Copiar archivo con manejo de errores
            if cp "$SRC_FILE" "$DEST_PATH" 2>/dev/null; then
                CONTADOR_NEW=$((CONTADOR_NEW + 1))
                echo "  [$CONTADOR_NEW/$TOTAL_NEW] Copiado nuevo: $FILE_NAME"
            else
                echo "  Error copiando: $FILE_NAME"
            fi
        fi
    fi
done < new_files_temp.txt

# Generar diff_list_despues.txt para el resumen actualizado
echo "Verificando estado después de la sincronización..."
diff -qr "$SRC" "$DST" | grep -E "differ|Only in $SRC" > diff_list_despues.txt 2>/dev/null || touch diff_list_despues.txt

# Resumen después de la sincronización (optimizado)
NUM_NUEVOS_DESPUES=$(grep -c "Only in $SRC" diff_list_despues.txt)
NUM_MODIFICADOS_DESPUES=$(grep -c "differ" diff_list_despues.txt)

echo "Resumen después de sincronizar:"
echo "  Archivos nuevos: $NUM_NUEVOS_DESPUES"
echo "  Archivos modificados: $NUM_MODIFICADOS_DESPUES"
echo "  Archivos eliminados: $NUM_ELIMINADOS"
echo "-----------------------------------------------"


# vuelve a comparar numero

if [ -z "$SRC" ] || [ -z "$DST" ]; then
    echo "Uso: $0 <carpeta1> <carpeta2>"
    exit 1
fi

COUNT1=$(find "$SRC" -type f | wc -l)
COUNT2=$(find "$DST" -type f | wc -l)

echo "Después de la copia:"
echo ""
echo "Ficheros en Origen: $COUNT1"
echo "Ficheros en Destino: $COUNT2"

if [ "$COUNT1" -eq "$COUNT2" ]; then
    echo "Ambas carpetas tienen el mismo número de ficheros."
else
    echo "Diferencia: $((COUNT1 - COUNT2))"
fi

echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "           RESUMEN EJECUCION DEL PROCESO           "
echo ""
echo "================================================="

# Crear archivo de log con fecha y hora
FECHA_HORA=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="sincronizacion_$(date '+%Y%m%d_%H%M%S').log"

# Crear encabezado del log
{
echo "================================================="
echo "           REGISTRO DE SINCRONIZACIÓN           "
echo "================================================="
echo ""
echo "Fecha y hora de ejecución: $FECHA_HORA"
echo "Origen: $SRC"
echo "Destino: $DST"
echo ""
echo "ESTADO INICIAL:"
echo "  - Ficheros en Origen: $COUNT1_INICIAL"
echo "  - Ficheros en Destino: $COUNT2_INICIAL"
echo "  - Diferencia inicial: $((COUNT1_INICIAL - COUNT2_INICIAL))"
echo ""
echo "ESTADO FINAL:"
echo "  - Ficheros en Origen: $COUNT1"
echo "  - Ficheros en Destino: $COUNT2"
echo "  - Diferencia final: $((COUNT1 - COUNT2))"
echo ""
echo "RESUMEN DE OPERACIONES:"
echo "  - Archivos modificados copiados: $NUM_MODIFICADOS"
echo "  - Archivos nuevos copiados: $NUM_NUEVOS"
echo "  - Archivos eliminados identificados: $NUM_ELIMINADOS"
echo ""

# Escribir el mismo contenido al archivo de log
echo "ESTADO INICIAL:"
echo "  - Ficheros en Origen: $COUNT1_INICIAL"
echo "  - Ficheros en Destino: $COUNT2_INICIAL"
echo "  - Diferencia inicial: $((COUNT1_INICIAL - COUNT2_INICIAL))"
echo ""
echo "ESTADO FINAL:"
echo "  - Ficheros en Origen: $COUNT1"
echo "  - Ficheros en Destino: $COUNT2"
echo "  - Diferencia final: $((COUNT1 - COUNT2))"
echo ""
echo "RESUMEN DE OPERACIONES:"
echo "  - Archivos modificados copiados: $NUM_MODIFICADOS"
echo "  - Archivos nuevos copiados: $NUM_NUEVOS"
echo "  - Archivos eliminados identificados: $NUM_ELIMINADOS"
echo ""
} >> "$LOG_FILE"

if [ $NUM_MODIFICADOS -gt 0 ]; then
    echo "DETALLE DE ARCHIVOS MODIFICADOS COPIADOS:"
    echo "DETALLE DE ARCHIVOS MODIFICADOS COPIADOS:" >> "$LOG_FILE"
    cat diff_list_antes.txt | tr '\n' ' ' | sed 's/Files /\nFiles /g' | grep "differ" | while IFS= read -r line; do
        SRC_FILE=$(echo "$line" | sed -n "s/.*Files '\([^']*\)' and.*/\1/p")
        if [[ -n "$SRC_FILE" ]]; then
            REL_PATH=$(echo "$SRC_FILE" | sed "s|^$SRC/||")
            echo "  - $REL_PATH"
            echo "  - $REL_PATH" >> "$LOG_FILE"
        fi
    done
    echo ""
    echo "" >> "$LOG_FILE"
fi

if [ $NUM_NUEVOS -gt 0 ]; then
    echo "DETALLE DE ARCHIVOS NUEVOS COPIADOS:"
    echo "DETALLE DE ARCHIVOS NUEVOS COPIADOS:" >> "$LOG_FILE"
    grep "Only in $SRC" diff_list_antes.txt | while IFS= read -r line; do
        if [[ $line =~ Only\ in\ (.*):\ (.*)$ ]]; then
            DIR="${BASH_REMATCH[1]}"
            FILE_NAME="${BASH_REMATCH[2]}"
            FILE_NAME=$(echo "$FILE_NAME" | sed "s/^'//;s/'$//")
            REL_PATH=$(echo "$DIR/$FILE_NAME" | sed "s|^$SRC/||")
            echo "  - $REL_PATH"
            echo "  - $REL_PATH" >> "$LOG_FILE"
        fi
    done
    echo ""
    echo "" >> "$LOG_FILE"
fi

if [ $NUM_ELIMINADOS -gt 0 ]; then
    echo "ARCHIVOS ELIMINADOS (solo identificados, NO eliminados):"
    echo "  - Total identificados: $NUM_ELIMINADOS"
    echo "  - Listado completo disponible en: deleted_files.txt"
    echo ""
    
    # Escribir al log
    {
    echo "ARCHIVOS ELIMINADOS (solo identificados, NO eliminados):"
    echo "  - Total identificados: $NUM_ELIMINADOS"
    echo "  - Listado completo disponible en: deleted_files.txt"
    echo ""
    } >> "$LOG_FILE"
fi

echo "================================================="
echo "Sincronización completada exitosamente"
echo "================================================="

# Finalizar el archivo de log
{
echo "================================================="
echo "Sincronización completada exitosamente"
echo "Archivo de log generado: $LOG_FILE"
echo "================================================="
} >> "$LOG_FILE"

echo ""
echo "Archivo de log generado: $LOG_FILE"

# Limpiar archivos temporales
rm -f diff_complete.txt diff_list_despues.txt modified_files_temp.txt new_files_temp.txt

echo ""
echo "++++++++++++++++++++++++++++++++++++++++++++++++"