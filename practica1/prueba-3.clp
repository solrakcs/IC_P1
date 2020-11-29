;Para este prueba vamos a elegir el juego JM y la personalidad del niño Distraido. Para esta prueba, el niño va a elegir una carta a la que el robot ya le ha dado la vuelta.
;Lo completan en el menor numero de rondas posibles, que es 6 rondas.

;Al definir esto inicialmente en la base de hechos en vez de recibirlo mediante input, la ejecucción del programa se salta la primera reglas.
(deffacts hechos-iniciales-p3
        (eleccion_usuario JM)
        (personalidad_usuario Distraido)
)


; 1. carta1 = 12, carta2 = 13, tiempo = 20
; 2. carta1 = 1, carta2 = 24, tiempo = 1
; 3. carta1 = 3, carta2 = 22, tiempo = 1
; 4. carta1 = 5, carta2 = 20, tiempo = 1
; 5. carta1 = 7, carta2 = 18, tiempo = 1
; 6. carta1 = 9, carta2 = 16, tiempo = 1
; 7. carta1 = 11, carta2 = 14, tiempo = 1


;Como podemos apreciar en esta ejecución del programa, el juego se completa sin problemas, excepto que al principio el niño eligió una carta a la que el robot ya le había dado la vuelta
; y por tanto el robot le llama la atención. El robot le pide que vuelva a seleccionar dos cartas iguales.