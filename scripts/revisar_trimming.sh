#!/bin/bash


mkdir -p resumen_trim

for file in logs/slurm/*trim*.out logs/slurm/*trimmomatic*.out; do
    echo "=============================="
    echo "Archivo: $file"
    
    if grep -q "Completed successfully" "$file"; then
        echo " STATUS: OK (trimming correcto)"
        grep "Input Read Pairs" "$file"
    
    elif grep -q "Exception\|FileNotFound\|command not found" "$file"; then
        echo " STATUS: ERROR"
        grep -i "Exception\|FileNotFound\|command not found" "$file"
    
    else
        echo "STATUS: DESCONOCIDO (revisar manual)"
    fi
    
    echo ""
done > resumen_trim/reporte_trimming.txt



