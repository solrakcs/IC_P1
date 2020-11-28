; =================== REGLAS DE COMIENZO DE SESION ==========================

;El usuario elige juego y personalidad del niño.
;La entrada se almancena en los hechos correspondientes
(defrule pickGameNPersonality
    =>
    (printout t "Hola! ¿Estas listo para jugar conmigo?" crlf)
    (printout t "¿Que quieres jugar hoy? Elige entre 3R y JM: " crlf)
    (assert (eleccion_usuario (read)))
    (printout t "¿Cómo es tu personalidad? (Neutro, Distraido, Impaciente): " crlf)
    (assert (personalidad_usuario (read)))
)

;Se genera la instancia de CONTROL a partir de la entrada del usuario
(defrule readGameNPersonality
    (eleccion_usuario ?elec)
    (personalidad_usuario ?per)
    =>
    (make-instance of CONTROL (Eleccion ?elec) (Personalidad ?per) (Turno Robot))
    ;Hecho de control para el warning que se lanza antes de que el robot juegue
    (assert (warningBeforeDone False))
    ;Hechos de control para verificar que los jugadores ya han marcado casillas en su turno
    (assert (kidPlayed False))
    (assert (robotPlayed False))
    
    (retract ?elec)
    (retract ?per)
)

; ===================== REGLAS TRES EN RAYA ====================


;Primera regla que se ejecuta cuando el juego elegido es el Tres en Raya. 
;Inicializa el tablero para llevar a cabo el juego
(defrule initBoard3R
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Ronda 0))
    =>
    (make-instance of CASILLA (x 1) (y 1))
    (make-instance of CASILLA (x 2) (y 1))
    (make-instance of CASILLA (x 3) (y 1))
    (make-instance of CASILLA (x 1) (y 2))
    (make-instance of CASILLA (x 2) (y 2))
    (make-instance of CASILLA (x 3) (y 2))
    (make-instance of CASILLA (x 1) (y 3))
    (make-instance of CASILLA (x 2) (y 3))
    (make-instance of CASILLA (x 3) (y 3))
    (modify-instance ?con (Ronda 1))
)

(defrule CondicionVictoria_3R
    ;Esta regla se tiene que ejecutar antes que cualquier otra
    (salience 100)
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno ?turn) (Ronda ?ron))

    ;Hechos de control para verificar que los jugadores ya han marcado casillas en su turno
    ?kp <- (kidPlayed ?kid)
    ?rp <- (robotPlayed ?robot)
    
    (test(or
            ;Si es el turno del robot que el robot ya haya marcado en esta ronda
            (and (eq ?turn Robot) (eq ?robot True))
            ;Si es el turno del niño que el niño ya haya marcado en esta ronda
            (and (eq ?turn Kid) (eq ?kid True)))
    )

    ;Leer tablero entero
    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (Valor ?va1) (Activada ?a1))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (Valor ?va2) (Activada ?a2))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (Valor ?va3) (Activada ?a3))
    ?cas4 <- (object (is-a CASILLA) (x 1) (y 2) (Valor ?va4) (Activada ?a4))
    ?cas5 <- (object (is-a CASILLA) (x 2) (y 2) (Valor ?va5) (Activada ?a5))
    ?cas6 <- (object (is-a CASILLA) (x 3) (y 2) (Valor ?va6) (Activada ?a6))
    ?cas7 <- (object (is-a CASILLA) (x 1) (y 3) (Valor ?va7) (Activada ?a7))
    ?cas8 <- (object (is-a CASILLA) (x 2) (y 3) (Valor ?va8) (Activada ?a8))
    ?cas9 <- (object (is-a CASILLA) (x 3) (y 3) (Valor ?va9) (Activada ?a9))

    ;Se ejecuta si 3 casillas en raya NO VACIAS (Activada = True) tienen el mismo valor
    (test (or 
            (or 
                (or 
                    (or 
                        (or
                            (or 
                                (or 
                                    (and (eq ?va7 ?va5 ?va3) (eq ?a7 ?a5 ?a3 True))
                                    (and (eq ?va7 ?va8 ?va9) (eq ?a7 ?a8 ?a9 True)))
                                (and (eq ?va4 ?va5 ?va6) (eq ?a4 ?a5 ?a6 True)))
                            (and (eq ?va3 ?va6 ?va9) (eq ?a3 ?a6 ?a9 True)))
                        (and (eq ?va2 ?va5 ?va8) (eq ?a2 ?a5 ?a8 True)))
                    (and (eq ?va1 ?va5 ?va9) (eq ?a1 ?a5 ?a9 True)))
                (and (eq ?va1 ?va4 ?va7) (eq ?a1 ?a4 ?a7 True)))
            (and (eq ?va1 ?va2 ?va3) (eq ?a1 ?a2 ?a3 True)))
    )
    =>
    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
    (halt)
)

;Reinicia hechos de warning, kidPlayed y robotPlayed a False, y va a la siguiente ronda
(defrule changeRound
    ?con <- (object (is-a CONTROL) (Turno Kid) (Ronda ?ron))

    ;Verificar que ambos jugadores ya han tomado acciones en esta ronda
    ?kp <- (kidPlayed True)
    ?rp <- (robotPlayed True)

    ;Almacenar hecho warning de antes de que juegue el robot para modificaciones
    ?w <- (warningBeforeDone ?war)
    =>
    (modify-instance ?con (Turno Robot) (Ronda (+ ?ron 1)))

    ;Cambio de ronda, indicar en la BH que ningun jugador ha tomado accion en esta ronda aun
    (retract ?kp)
    (retract ?rp)
    (assert (kidPlayed False))
    (assert (robotPlayed False))
    ;Indicar que no se ha hecho el warning en esta ronda
    (retract ?w)
    (assert (warningBeforeDone False))
    
    (printout t "Cambio de ronda: " ?ron " a ronda: " (+ ?ron 1) crlf)
)

(defrule changeTurn
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad ?p) (Turno Robot))
    ?rp <- (robotPlayed True)
    =>
    (modify-instance ?con (Turno Kid))
    (printout t "Cambio de turno: Termina robot, turno del niño" crlf)
)


; --------- Estrategias del Robot en 3 en Raya ----------------

;Estrategia Robot en Ronda 1
(defrule JuegaRobot_3R_Ronda1
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad ?p) (Turno Robot) (Ronda 1))
    ?cas <- (object (is-a CASILLA) (x 1) (y 1) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))

    ?rp <- (robotPlayed False)
    =>
    ;Marcar casilla (1,1)
    (modify-instance ?cas (Valor X) (Activada True))
    ;Eliminar de la BH el hecho que indica que el robot no ha jugado esta ronda
    (retract ?rp)
    ;Indicar en la BH que el robot ya jugo en esta ronda
    (assert (robotPlayed True))
    (printout t "Robot marca X en casilla (" 1 "," 1 ")" crlf)
)

;!!! REVISAR: NO PUEDE CAMBIAR DE TURNO AUN
;Estrategia Robot en Ronda 2
(defrule JuegaRobot_3R_Ronda2
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad ?p) (Turno Robot) (Ronda 2))
    ;Si el niño todavia no ha colocado una O en la casilla del medio (2,2).. 
    ?cas22 <- (object (is-a CASILLA) (x 2) (y 2) (Activada False))
    ;..ver si la casilla (1,3) esta vacia
    ?cas <- (object (is-a CASILLA) (x 1) (y 3) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))

    ?rp <- (robotPlayed False)
    =>
    ;Marcar casilla (1,3)
    (modify-instance ?cas (Valor X) (Activada True))
    ;Eliminar de la BH el hecho que indica que el robot no ha jugado esta ronda
    (retract ?rp)
    ;Indicar en la BH que el robot ya jugo en esta ronda
    (assert (robotPlayed True))
    (printout t "Robot marca X en casilla (" 1 "," 3 ")" crlf)
)

;Estrategia Robot en Ronda 3 o más, o si en la ronda 2 esta ocupada la casilla (2,2)
(defrule JuegaRobot_3R_RRondas
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad ?p) (Turno Robot) (Ronda ?ron))
    ;Elige una casilla al azar
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada False))
    ;La regla se ejecuta si ronda > 2 OR, si la casilla (2,2) o la (1,3) esta activada (ocupada)
    ?casM <- (object (is-a CASILLA) (x 2) (y 2) (Activada ?a22))
    ?cas13 <- (object (is-a CASILLA) (x 1) (y 3) (Activada ?a13))

    (test (or 
            (> ?ron 2)
            (or
                (eq ?a13 True) 
                (eq ?a22 True)))
    )
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))

    ;Verificar que el robot no haya jugado aun en esta ronda
    ?rp <- (robotPlayed False)
    =>
    ;Marcar casilla elegida al azar
    (modify-instance ?cas (Valor X) (Activada True))
    ;Eliminar de la BH el hecho que indica que el robot no ha jugado esta ronda
    (retract ?rp)
    ;Indicar en la BH que el robot ya jugo en esta ronda
    (assert (robotPlayed True))
    (printout t "Robot marca X en casilla (" ?x "," ?y ")" crlf)
)

; --------------- Reglas de Input del Usuario para 3 en Raya -----------------

; Regla para leer el input del niño
; !!! Esto se puede usar para JM tambien
(defrule inputKid_3R
    ;Cuando es el turno del niño..
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid) (Cronometro ?c))
    ; y no ha elegido x e y...
    (not(xKid ?x))
    (not(yKid ?y))

    ;El niño no ha jugado en esta ronda
    (kidPlayed False)
    =>
    ;...pedirle que introduzca x, y y el tiempo que tarda en responder (sensor del robot)
    (printout t "Ingresa x: " crlf)
    (assert (xKid (read)))
    (printout t "Ingresa y: " crlf)
    (assert (yKid (read)))
    (printout t "Ingresa el tiempo tomado:" crlf)
    (modify-instance ?con (Cronometro (read)))
)

(defrule juegaKid_3R
    ;Turno del niño
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid) (Ronda ?r))
    ;El niño ha elegido (x,y) validas (dentro del rango y vacia (no activada))
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada False))
    ;El niño no ha jugado en esta ronda
    ?kp <- (kidPlayed False)
    =>
    ;Marca la casilla (x,y)
    (modify-instance ?cas (Valor O) (Activada True))
    ;Indica en la BH que el niño ya jugo en esta ronda
    (retract ?kp)
    (assert (kidPlayed True))

    ;Borra hechos de entrada del niño (x,y) para que se vuelvan a solicitar en la ronda siguiente
    (retract ?xkid)
    (retract ?ykid)

    (printout t "Has marcado la casilla (" ?x "," ?y ") correctamente!" crlf) 
)

; ------------------ Reglas para interaccion Robot-Paciente --------------------

; Reutilizable para JM
(defrule overTimeDistractedKid
    ;Se ejecuta cuando el niño tarda mas de 15 segundos en ingresar (x,y) y es de personalidad distraida
    ?con <- (object (is-a CONTROL) (Turno Kid) (Personalidad Distraido) (Cronometro ?c))
    (test (> ?c 15))
    ;Se ejecuta luego de recibir input (x,y) del usuario
    (xKid ?x)
    (yKid ?y)
    ;!!!! Ver como dar prioridad sobre juegaKid_3R y corregirAccionIncorrecta
    ;Por ahora prioridad con salience, pero ver si se puede implementar otra cosa
    ;Podria implementar un hecho warningDistracted
    (salience 10)
    =>
    (printout t "Has tardado mucho tiempo en elegir! Tienes que concentrarte mejor." crlf)
    ;No se vuelve a solicitar entrada, simplemente se avisa de que tardo mucho en decidir
)

;Las reglas siguientes se ejecutan antes de que el robot mueva
; Son reutilizables para JM
(defrule warningBeforeTurn_Impacient
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Impaciente) (Turno Robot) (Ronda ?ron))
    ?w <- (warningBeforeDone False)
    (test (> ?ron 0))
    =>
    (printout t " ¡No seas impaciente, espera a que yo mueva primero!" crlf)
    (retract ?w)
    (assert (warningBeforeDone True))
)

(defrule warningBeforeTurn_Distracted
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Distraido) (Turno Robot) (Ronda ?ron))
    ?w <- (warningBeforeDone False)
    (test (> ?ron 0))
    =>
    (printout t "¡Recuerda que despues de mi turno te toca a ti!" crlf)
    (retract ?w)
    (assert (warningBeforeDone True))
)

;Indica que la casilla esta fuera de rango y elimina la entrada del usurio para obligarle a ingresar un nuevo par (x,y)
(defrule corregirCasillaOutOfBounds_3R
    ;Se corrige al recibir input (x,y) del usuario
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid))
    
    ;Ejecutar regla si x > 3 OR x < 1 OR y > 3 OR y < 1
    (test (or 
            (or 
                (or 
                    (< ?y 1)
                    (> ?y 3))
                (< ?x 1))
            (> ?x 3)))

    =>
    (printout t "Accion incorrecta! La casilla que has elegido esta fuera de rango." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
)

; !!! REVISAR: Se ejecuta luego de que el niño pone en su turno y antes de cambiar de ronda
;Indica que la casilla (x,y) elegida esta ocupada y elimina entrada del usuario para que ingrese un nuevo par (x,y)
;Esta es reutilizable
(defrule corregirCasillaOcupada_3R
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid))
    ;Se corrige al recibir input (x,y) del usuario
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ;Ejecutar regla cuando casilla (x,y) Activada (ocupada) 
    ; REVISAR: Se ejecuta luego de que el niño pone en su turno y antes de cambiar de ronda
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada True))
    =>
    (printout t "Accion incorrecta! La casilla que has elegido esta ocupada." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
)



; ===================== REGLAS JUEGO DE MEMORIA ====================


;Primera regla que se ejecuta cuando el juego elegido es el Juego de Memoria. 
;Inicializa el tablero para llevar a cabo el juego
(defrule initBoardJM
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Ronda 0))
    =>
    (make-instance of CASILLA (x 1) (y 1) (Valor Monkey) (Activada False))
    (make-instance of CASILLA (x 2) (y 1) (Valor Dog) (Activada False))
    (make-instance of CASILLA (x 3) (y 1) (Valor Cat) (Activada False))
    (make-instance of CASILLA (x 4) (y 2) (Valor Horse) (Activada False))
    (make-instance of CASILLA (x 5) (y 2) (Valor Shark) (Activada False))
    (make-instance of CASILLA (x 6) (y 2) (Valor Tiger) (Activada False))
    (make-instance of CASILLA (x 7) (y 3) (Valor Pig) (Activada False))
    (make-instance of CASILLA (x 8) (y 3) (Valor Dolphin) (Activada False))
    (make-instance of CASILLA (x 9) (y 3) (Valor Dragon) (Activada False))
    (make-instance of CASILLA (x 10) (y 1) (Valor Panda) (Activada False))
    (make-instance of CASILLA (x 11) (y 1) (Valor Bird) (Activada False))
    (make-instance of CASILLA (x 12) (y 1) (Valor Eagle) (Activada False))
    (make-instance of CASILLA (x 13) (y 2) (Valor Eagle) (Activada False))
    (make-instance of CASILLA (x 14) (y 2) (Valor Bird) (Activada False))
    (make-instance of CASILLA (x 15) (y 2) (Valor Panda) (Activada False))
    (make-instance of CASILLA (x 16) (y 3) (Valor Dragon) (Activada False))
    (make-instance of CASILLA (x 17) (y 3) (Valor Dolphin) (Activada False))
    (make-instance of CASILLA (x 18) (y 3) (Valor Pig) (Activada False))
    (make-instance of CASILLA (x 19) (y 3) (Valor Tiger) (Activada False))
    (make-instance of CASILLA (x 20) (y 3) (Valor Shark) (Activada False))
    (make-instance of CASILLA (x 21) (y 3) (Valor Horse) (Activada False))
    (make-instance of CASILLA (x 22) (y 3) (Valor Cat) (Activada False))
    (make-instance of CASILLA (x 23) (y 3) (Valor Dog) (Activada False))
    (make-instance of CASILLA (x 24) (y 3) (Valor Monkey) (Activada False))
    (modify-instance ?con (Ronda 1))
)


(defrule CondicionVictoria_JM

    ;Esta regla se tiene que ejecutar antes que cualquier otra
    (salience 100)
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno ?turn) (Ronda ?ron))
    

    ;Hechos de control para verificar que los jugadores ya han marcado casillas en su turno
    ?kp <- (kidPlayed ?kid)
    ?rp <- (robotPlayed ?robot)

    (test(or
            ;Si es el turno del robot que el robot ya haya marcado en esta ronda
            (and (eq ?turn Robot) (eq ?robot True))
            ;Si es el turno del niño que el niño ya haya marcado en esta ronda
            (and (eq ?turn Kid) (eq ?kid True))
         )
    )

    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (Activada True))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (Activada True))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (Activada True))
    ?cas4 <- (object (is-a CASILLA) (x 4) (y 1) (Activada True))
    ?cas5 <- (object (is-a CASILLA) (x 5) (y 1) (Activada True))
    ?cas6 <- (object (is-a CASILLA) (x 6) (y 1) (Activada True))
    ?cas7 <- (object (is-a CASILLA) (x 7) (y 1) (Activada True))
    ?cas8 <- (object (is-a CASILLA) (x 8) (y 1) (Activada True))
    ?cas9 <- (object (is-a CASILLA) (x 9) (y 1) (Activada True))
    ?cas10 <- (object (is-a CASILLA) (x 10) (y 1) (Activada True))
    ?cas11 <- (object (is-a CASILLA) (x 11) (y 1) (Activada True))
    ?cas12 <- (object (is-a CASILLA) (x 12) (y 1) (Activada True))
    ?cas13 <- (object (is-a CASILLA) (x 13) (y 1) (Activada True))
    ?cas14 <- (object (is-a CASILLA) (x 14) (y 1) (Activada True))
    ?cas15 <- (object (is-a CASILLA) (x 15) (y 1) (Activada True))
    ?cas16 <- (object (is-a CASILLA) (x 16) (y 1) (Activada True))
    ?cas17 <- (object (is-a CASILLA) (x 17) (y 1) (Activada True))
    ?cas18 <- (object (is-a CASILLA) (x 18) (y 1) (Activada True))
    ?cas19 <- (object (is-a CASILLA) (x 19) (y 1) (Activada True))
    ?cas20 <- (object (is-a CASILLA) (x 20) (y 1) (Activada True))
    ?cas21 <- (object (is-a CASILLA) (x 21) (y 1) (Activada True))
    ?cas22 <- (object (is-a CASILLA) (x 22) (y 1) (Activada True))
    ?cas23 <- (object (is-a CASILLA) (x 23) (y 1) (Activada True))
    ?cas24 <- (object (is-a CASILLA) (x 24) (y 1) (Activada True))
    =>
    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
    (halt)
)

(defrule changeRound_JM
    ?con <- (object (is-a CONTROL) (Turno Kid) (Ronda ?ron))

    ;Verificar que ambos jugadores ya han tomado acciones en esta ronda
    ?kp <- (kidPlayed True)
    ?rp <- (robotPlayed True)
    =>
    (modify-instance ?con (Turno Robot) (Ronda (+ ?ron 1)))

    ;Cambio de ronda, indicar en la BH que ningun jugador ha tomado accion en esta ronda aun
    (retract ?kp)
    (retract ?rp)
    ;Hechos de control para verificar que los jugadores ya han tomado accion en su turno en la nueva ronda
    (assert (kidPlayed False))
    (assert (robotPlayed False))
    
    (printout t "Cambio de ronda: " ?ron " a ronda: " (+ ?ron 1) crlf)
)


; --------- Estrategias del Robot en Juego de Memoria ----------------


;Estrategia Robot en todas las rondas. Lo hace al azar
(defrule JuegaRobot_JM_Rondas
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Personalidad ?p) (Turno Robot) (Ronda 1))
    ?cas1 <- (object (is-a CASILLA) (Valor ?val1) (Activada False))
    ?cas2 <- (object (is-a CASILLA) (Valor ?val2) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
               eq ?war True))
    (test (eq ?val1 ?val2))

    ?rp <- (robotPlayed False)
    =>
    (modify-instance ?cas1 (Valor ?val1) (Activada True))
    (modify-instance ?cas2 (Valor ?val2) (Activada True))
    (modify-instance ?con (Turno Kid))
    (retract ?w)
    (retract ?rp)
    (assert (robotPlayed True))
)


; --------------- Reglas de Input del Usuario para Juego de Memoria -----------------


; Regla para leer el input del niño
; Regla reutilizable
(defrule inputKid_JM
    ;Cuando es el turno del niño..
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Cronometro ?c))
    ; y no ha elegido x
    (not(xKid1 ?x1))
    (not(xKid2 ?x2))

    ;El niño no ha jugado en esta ronda
    (kidPlayed False)
    =>
    ;...pedirle que introduzca x, y y el tiempo que tarda en responder (sensor del robot)
    (printout t "Ingresa la primera carta: " crlf)
    (assert (xKid1 (read)))
    (printout t "Ingresa la segunda carta: " crlf)
    (assert (xKid2 (read)))
    (printout t "Ingresa el tiempo tomado:" crlf)
    (modify-instance ?con (Cronometro (read)))
)


(defrule juegaKid_JM
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Ronda ?r))
    ?cas1 <- (object (is-a CASILLA) (Valor ?val1) (x ?x1) (Activada False))
    ?cas2 <- (object (is-a CASILLA) (Valor ?val2) (x ?x2) (Activada False))
    ?xkid1 <- (xKid1 ?x1)
    ?xkid2 <- (xKid2 ?x2)

    ;El niño no ha jugado en esta ronda
    ?kp <- (kidPlayed False)
    =>
    ;Borra hechos de entrada (x) para que se vuelvan a solicitar en la ronda siguiente
    (retract ?xkid1)
    (retract ?xkid2)
    ;Activa la casillas
    (modify-instance ?cas1 (Valor ?val1) (Activada True))
    (modify-instance ?cas2 (Valor ?val2) (Activada True))
    ;Indica en la BH que el niño ya jugo en esta ronda
    (retract ?kp)
    (assert (kidPlayed True))
)


; ------------------ Reglas para interaccion Robot-Paciente --------------------


; Regla reuitilizable
(defrule overTimeDistractedKid_JM
    ;Se ejecuta cuando el niño tarda mas de 15 segundos en ingresar (x) y es de personalidad distraida
    ?con <- (object (is-a CONTROL) (Turno Kid) (Personalidad Distraido) (Cronometro ?c))
    (test (> ?c 15))
    ;Se ejecuta luego de recibir input (x) del usuario
    (xKid1 ?x1)
    (xKid2 ?x2)
    ;!!!! Ver como dar prioridad sobre juegaKid_3R y corregirAccionIncorrecta
    ;Por ahora prioridad con salience, pero ver si se puede implementar otra cosa
    ;Podria implementar un hecho warningDistracted
    (salience 10)
    =>
    (printout t "Has tardado mucho tiempo en elegir! Tienes que concentrarte mejor." crlf)
    ;No se vuelve a solicitar entrada, simplemente se avisa de que tardo mucho en decidir
)

; Las reglas siguientes se ejecutan antes de que el robot mueva
; Regla reutilizable
(defrule warningBeforeTurn_Impacient_JM
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Personalidad Impaciente) (Turno Robot) (Ronda ?ron))
    ?w <- (warningBeforeDone False)
    =>
    (printout t " ¡No seas impaciente, espera a que yo mueva primero!")
    (retract ?w)
    (assert (warningBeforeDone True))
)


(defrule warningBeforeTurn_Distracted_JM
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Personalidad Distraido) (Turno Robot) (Ronda ?ron))
    ?w <- (warningBeforeDone False)
    =>
    (printout t "¡Recuerda que despues de mi turno te toca a ti!")
    (retract ?w)
    (assert (warningBeforeDone True))
)


;Indica que la casilla esta fuera de rango y elimina la entrada del usurio para obligarle a ingresar una nueva (x)
(defrule corregirCasillaOutOfBounds_JM
    ;Se corrige al recibir input (x) del usuario
    ?xkid1 <- (xKid1 ?x1)
    ?xkid2 <- (xKid2 ?x2)
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid))
    
    ;Ejecutar regla si x > 1 OR x < 24
    (test (and (and (< ?x1 24) (> ?x1 0)) (and (< ?x2 24) (> ?x2 0))))
    =>
    (printout t "Accion incorrecta! La casilla que has elegido esta fuera de rango." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid1)
    (retract ?xkid2)
)


;Indica que la casilla (x,y) elegida esta ya levantada y elimina entrada del usuario para que ingrese un nuevo par (x)
;Esta es reutilizable
(defrule corregirCasillaOcupada_JM
    ;Se corrige al recibir input (x,y) del usuario
    ?xkid <- (xKid ?x)
    ;Ejecutar regla cuando casilla (x,y) Activada (ocupada)
    ?cas <- (object (is-a CASILLA) (x ?x) (Activada True))
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid))
    =>
    (printout t "Accion incorrecta! La casilla que has elegido esta ocupada." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
)