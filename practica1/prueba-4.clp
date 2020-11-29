;Para este prueba vamos a elegir el juego 3R y la personalidad del niño Distraido. En esta prueba vamos a ir a ganar.

;Al definir esto inicialmente en la base de hechos en vez de recibirlo mediante input, la ejecucción del programa se salta la primera reglas.
(deffacts hechos-iniciales-p4
        (eleccion_usuario JM)
        (personalidad_usuario Impaciente)
)


; 1. carta1 = 1, carta2 = 24, tiempo = 1
; 2. carta1 = 1, carta2 = 24, tiempo = 5
; 3. carta1 = 4, carta2 = 5, tiempo = 5
; 4. carta1 = 5, carta2 = 4, tiempo = 5
; 5. carta1 = 4, carta2 = 21, tiempo = 5
; 6. carta1 = 6, carta2 = 19, tiempo = 5
; 7. carta1 = 8, carta2 = 17, tiempo = 5
; 8. carta1 = 10, carta2 = 15, tiempo = 5


;En el paso 1, el rbot regaña al niño por tardar muy poco tiempo, ya que es impaciente y el niño elige su respuesta demasiado pronto. El robot le aconseja que para el proximo turno el niño tome
;la decision con mas calma. En el turno 2 el robot regaña al niño porque el niño intenta levantar cartas que ya estan levantadas. El resto se ejecuta de manera correcta.