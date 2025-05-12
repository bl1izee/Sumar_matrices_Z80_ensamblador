; This is a basic template file for writing 48K Spectrum code.

AppFilename             equ "NewFile"                   ; What we're called (for file generation)

AppFirst                equ $8000                       ; First byte of code (uncontended memory)

                        zeusemulate "48K","ULA+"        ; Set the model and enable ULA+


; Start planting code here. (When generating a tape file we start saving from here)

                        org AppFirst                    ; Start of application

AppEntry                LD IX, MATRIZ_A                 ; Cargamos en IX la dirección de memoria de IX
                        LD IY, MATRIZ_B                 ; Cargamos en IY la dirección de memoria de IX
                        LD HL, MATRIZ_RESULTADO         ; Cargamos en HL la dirección de memoria de MATRIZ_RESULTADO
                        LD B, MATRIZ_B-MATRIZ_A         ; Cargamos en B el tamaño de las matrices
BucleSumaMatriz         CALL SumaElementos              ; Llamamos a la función SumaElementos
                        LD DE, (MATRIZ_Z)               ; Cargamos en E el contenido de MATRIZ_Z
                        LD (HL), E                      ; Cargamos en HL el contenido de E
                        INC IX                          ; Incrementamos IX
                        INC IY                          ; Incrementamos IY
                        INC HL                          ; Incrementamos HL
                        DJNZ BucleSumaMatriz            ; Cerramos el bucle
Final                   halt                            ; Final del programa
                        jp Final                        ; Final del programa

SumaElementos           LD A, (IX)                      ; Cargamos en el acumulador el contenido de IX
                        ADD (IY)                        ; Sumamos el contenido de IY
                        LD (MATRIZ_Z), A                ; Cargamos en MATRIZ_Z el contenido de A
                        RET                             ; Volvemos al codigo main


; Stop planting code after this. (When generating a tape file we save bytes below here)
AppLast                 equ *-1                         ; The last used byte's address

MATRIZ_A                defb 1,1,3,2,4,7,1,8,9          ; Definimos la matriz A
MATRIZ_B                defb 9,8,7,6,5,4,3,2,1          ; Definimos la matriz B
MATRIZ_RESULTADO        defs MATRIZ_B-MATRIZ_A          ; Definimos la matriz resultado con el tamaño adecuado
MATRIZ_Z                defs 1                          ; Definimos la variable que guarda el resultado de la suma
; Generate some useful debugging commands

                        profile AppFirst,AppLast-AppFirst+1     ; Enable profiling for all the code

; Setup the emulation registers, so Zeus can emulate this code correctly

Zeus_PC                 equ AppEntry                            ; Tell the emulator where to start
Zeus_SP                 equ $FF40                               ; Tell the emulator where to put the stack

; These generate some output files

                        ; Generate a SZX file
                        output_szx AppFilename+".szx",$0000,AppEntry    ; The szx file

                        ; If we want a fancy loader we need to load a loading screen
;                        import_bin AppFilename+".scr",$4000            ; Load a loading screen

                        ; Now, also generate a tzx file using the loader
                        output_tzx AppFilename+".tzx",AppFilename,"",AppFirst,AppLast-AppFirst,1,AppEntry ; A tzx file using the loader


