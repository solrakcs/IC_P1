;Para este prueba vamos a elegir el juego 3R y la personalidad del niño Distraido. En esta prueba el robot gana.

;Al definir esto inicialmente en la base de hechos en vez de recibirlo mediante input, la ejecucción del programa se salta la primera reglas.
(deffacts hechos-iniciales-p1
        (eleccion_usuario 3R)
        (personalidad_usuario Distraido)
)

; 1. x = 1, y = 3, tiempo = 20
; 2. x = 2, y = 2, tiempo = 5


;Todo funciona correctamente. Todo se ejecuta sin problemas, dado que el niño elige opciones validas aunque no consigue ganar al robot.
;Lo unico a mencionar es que como el niño es distraido, el robot le avisa que despues de que el realice su turno, le toca al niño.