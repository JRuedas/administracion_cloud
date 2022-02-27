Function printMenu {
    Clear-Host
    Write-Host "================ Opciones ================"
    Write-Host "1. Listar los servicios arrancados."
    Write-Host "2. Mostrar la fecha del sistema."
    Write-Host "3. Ejecutar el Bloc de notas."
    Write-Host "4. Ejecutar la Calculadora."
    Write-Host "5. Salir."
}

Do {
    printMenu
    $option = Read-Host -Prompt "Seleccione una opción."
 
    switch($option){
        1 {
            Clear-Host
            Write-Host "Listando servicios en ejecución ..."
            Get-Service | Where-Object {$_.Status -eq "Running"} | Format-Table
            pause
            break
        }
        2 {
            Clear-Host
            Write-Host "Obteniendo fecha ..."
            Get-Date | Format-Custom
            pause
            break
        }
        3 {
            Clear-Host
            Write-Host "Abriendo Bloc de notas ..."
            Start-Process 'C:\windows\system32\notepad.exe'
            pause
            break
        }
        4 {
            Clear-Host
            Write-Host "Abriendo calculadora ..."
            Start-Process 'C:\windows\system32\calc.exe'
            pause
            break
        }
        5 {
            Write-Host "Saliendo ..."
            return
        }
        default {
            Write-Host -ForegroundColor red -BackgroundColor white "Invalid option.";
            pause
        }
    }
} While($option -ne 5)