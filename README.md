# CE4302-vector_processor

Our implementation of an vector processor in Quartus FPGA. ASIP.

# Herramientas requeridas

Para poder ejecutar este proyecto se requiere que previamente disponga de las siguientes herramientas:

1. Para compilar el código y obtener la simulación del VGA, Python 3.8+.
2. Para realizar la ejecución del código se requiere ModelSim 10.5b (Quartus Prime 18.1).
3. Además debe descargar el actual repositorio.

# Pasos para ejecutarlo

1. Colocar en la raíz del repositorio un archivo de texto(`.txt`) con el siguiente nombre `quartus_directory.txt`  y colocar el directorio que contiene todos los archivos de Quartus Prime. Por ejemplo:  `C:\intelFPGA_lite\18.1`.
2. Para poder compilar un código ensamblador `.asmrsa` debe ejecutar el script de Python del presente repositorio que se encuentra en `Compiler\compiler.py`. Asegúrese de que el código fuente tenga el siguiente nombre: `RSA_Decrypt.asmrsa`.
3. Ejecute el script del paso 2. Esto va a generar un archivo `RSA_Decrypt.b`, el cual se almacenará en la ruta previamente ingresada en el archivo del paso 1.
4. En el mismo directorio del paso 1, debe agregar los archivos `data.mif` y `data.ver` los cuales corresponden a la memoria donde están almacenados los pixeles de la imagen encriptada.
5. Abra ModelSim y seleccione en la barra de navegación, `Compile > Compile...`.
6. En la ventana emergente, acceda a la carpeta `Processor` del presente repositorio y seleccione todos los archivos que ModelSim le permite seleccionar.
7. Diríjase a `Simulate > Start Simulation > Libraries` y seleccione `Add...` y añada **en el siguiente orden** las librerías `altera_mf_ver` y `altera_mf` . Luego seleccione `Design`, expanda el fichero `work` y seleccione el archivo `rsa_asip_system_tb_output` y seleccione `OK`.
8. Ahora seleccione `Simulate > Run > Run All`. A partir de este paso, comienza todo el proceso de desencripción de la imagen.
9. Una vez finalizado, le saldrá la opción de cerrar ModelSim. Seleccione la opción de su preferencia. Si se dirige al directorio que contiene todos los archivos de Quartus Prime, encontrará un fichero llamado `monitor_inputs.txt` el cual contiene los datos de simulación del monitor VGA.
10. En el directorio `VGA` abra el script de Python llamado `simulator.py` y ejecútelo. Esto va a generar los frames de la imagen encriptada y desencriptada.
11. Por último, diríjase al folder `VGA\Simulator outputs` y encontrará dos frames. El primero (`frame1.png`) corresponde a lo que se observaría en el monitor al seleccionar la imagen encriptada y el segundo (`frame2.png`) corresponde a lo que se observaría en el monitor al seleccionar la imagen desencriptada.
