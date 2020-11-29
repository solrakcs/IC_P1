;Para este prueba vamos a elegir el juego 3R y la personalidad del niño Impaciente. En esta prueba vamos a ir a ganar, pero el niño en el primer movimiento elige una x e y invalidas.

;Al definir esto inicialmente en la base de hechos en vez de recibirlo mediante input, la ejecucción del programa se salta la primera reglas.
(deffacts hechos-iniciales-p2
        (eleccion_usuario 3R)
        (personalidad_usuario Impaciente)
)


; 1. x = 4, y = 1, tiempo = 1
; 2. x = 1, y = 3, tiempo = 5
; 3. x = 3, y = 1, tiempo = 20
; 4. x = 2, y = 2, tiempo = 5

;Como podemos observar, en este caso el niño gana al robot. En el primer movimiento, el niño es muy rapido a la hora de elegir su opcion y el robot le advierte por ello. El niño elige una casillas
;que no existe y por tanto el robot le vuelve a requerir un nuevo input despues de haberle regañado.
;Como el niño es impaciente, el robot le da un aviso antes de actuar para que el niño no se precipite y mueva antes de que le toque.
;Tambien como podemos observar, como el niño no es distraido, da igual que tarde mucho tiempo en elegir un movimiento ya que el robot no le llamara la antencios. De hecho es bueno que para un niño 
;impaciente se tome el tiempo necesario para tomar su decision.

