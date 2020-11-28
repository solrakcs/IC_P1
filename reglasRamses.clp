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
    (make-instance of CONTROL (Eleccion ?elec) (Personalidad ?per))
    ;(assert(robotSymbol X))
    ;(assert(userSymbol O))
    (retract ?elec)
    (retract ?per)
)

; ===================== REGLAS TRES EN RAYA ====================


;Primera regla que se ejecuta cuando el juego elegido es el Tres en Raya. 
;Inicializa el tablero para llevar a cabo el juego
(defrule initBoard3R
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Ronda 0))
    =>
    (make-instance of CASILLA (x 1) (y 1) (Valor Vacia))
    (make-instance of CASILLA (x 2) (y 1) (Valor Vacia))
    (make-instance of CASILLA (x 3) (y 1) (Valor Vacia))
    (make-instance of CASILLA (x 1) (y 2) (Valor Vacia))
    (make-instance of CASILLA (x 2) (y 2) (Valor Vacia))
    (make-instance of CASILLA (x 3) (y 2) (Valor Vacia))
    (make-instance of CASILLA (x 1) (y 3) (Valor Vacia))
    (make-instance of CASILLA (x 2) (y 3) (Valor Vacia))
    (make-instance of CASILLA (x 3) (y 3) (Valor Vacia))
    (modify-instance ?con (Ronda 1))
)

(defrule CondicionVictoria_3R
    ;Hay que revisar esta verga
    ; Crear algun atributo que diga X es Robot y O es Usuario
    ; Para luego hacer match aqui y poder imprimir quien gano
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno ?turn) (Ronda ?ron))
    (test (> ?ron 2))

    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (Valor ?va1))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (Valor ?va2))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (Valor ?va3))
    ?cas4 <- (object (is-a CASILLA) (x 1) (y 2) (Valor ?va4))
    ?cas5 <- (object (is-a CASILLA) (x 2) (y 2) (Valor ?va5))
    ?cas6 <- (object (is-a CASILLA) (x 3) (y 2) (Valor ?va6))
    ?cas7 <- (object (is-a CASILLA) (x 1) (y 3) (Valor ?va7))
    ?cas8 <- (object (is-a CASILLA) (x 2) (y 3) (Valor ?va8))
    ?cas9 <- (object (is-a CASILLA) (x 3) (y 3) (Valor ?va9))

    ; Esto hace que se de victoria a casillas vacias
    (test (or 
            (or 
                (or 
                    (or 
                        (or
                            (or 
                                (or 
                                    (eq ?va7 ?va5 ?va3)
                                    (eq ?va7 ?va8 ?va9))
                                (eq ?va4 ?va5 ?va6))
                            (eq ?va3 ?va6 ?va9))
                        (eq ?va2 ?va5 ?va8))
                    (eq ?va1 ?va5 ?va9))
                (eq ?va1 ?va4 ?va7))
            (eq ?va1 ?va2 ?va3)))

    ;(test ((eq ?va1 ?va2 ?va3) or (eq ?va1 ?va4 ?va7) or (eq ?va1 ?va5 ?va9) or (eq ?va2 ?va5 ?va8) or 
    ;    (eq ?va3 ?va6 ?va9) or (eq ?va4 ?va5 ?va6) or (eq ?va7 ?va8 ?va9) or (eq ?va7 ?va5 ?va3)))
    =>
    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
    (halt)
)


; --------- Estrategias del Robot en 3 en Raya ----------------

;Estrategia Robot en Ronda 1
(defrule JuegaRobot_3R_Ronda1
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Robot) (Ronda ?r))
    (test (= ?r 1))
    ?cas <- (object (is-a CASILLA) (x 1) (y 1) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))
    =>
    (modify-instance ?cas (x 1) (y 1) (Valor X) (Activada True))
    (modify-instance ?con (Turno Kid))
    ;(Ronda (+ ?r 1))
    (retract ?w)
)

;Estrategia Robot en Ronda 2
(defrule JuegaRobot_3R_Ronda2
    ;Si el niño todavia no ha colocado una O en la casilla del medio (2,2) 
    ;Entonces colocar una X en la esquina (1,3)
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Robot) (Ronda ?r))
    (test (= ?r 2))
    ?casM <- (object (is-a CASILLA) (x 2) (y 2) (Activada False))
    ?cas <- (object (is-a CASILLA) (x 1) (y 3) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))
    =>
    (modify-instance ?cas (Valor X) (Activada True))
    (modify-instance ?con (Turno Kid))
    ;(Ronda (+ ?r 1))
    (retract ?w)
)

;Estrategia Robot en Ronda 3 o más, o si en la ronda 2 esta ocupada la casilla (2,2)
(defrule JuegaRobot_3R_RRondas
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Robot) (Ronda ?ron))
    ?cas <- (object (is-a CASILLA) (Activada False))
    ?casM <- (object (is-a CASILLA) (x 2) (y 2) (Activada ?a))
    ;La regla se ejecuta si ronda > 2 OR si la casilla (2,2) esta activada (ocupada)
    (test (or (> ?ron 2) 
              (eq ?a True)))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))
    =>
    (modify-instance ?cas (Valor X) (Activada True))
    (modify-instance ?con (Turno Kid))
    ; (Ronda (+ ?ron 1))
    (retract ?w)
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
    =>
    ; pedirle que introduzca x, y y el tiempo que tarda en responder (sensor del robot)
    (printout t "Ingresa x: " crlf)
    (assert (xKid (read)))
    (printout t "Ingresa y: " crlf)
    (assert (yKid (read)))
    (printout t "Ingresa el tiempo tomado:" crlf)
    (modify-instance ?con (Cronometro (read)))
)

(defrule juegaKid_3R
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid) (Ronda ?r))
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada False))
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    =>
    (retract ?xkid)
    (retract ?ykid)
    (modify-instance ?cas (Valor O) (Activada true))
    (modify-instance ?con (Turno Robot) (Ronda (+ ?r 1)))
)

; ------------------ Reglas para interaccion Robot-Paciente --------------------

(defrule overTimeDistractedKid
    ?con <- (object (is-a CONTROL) (Turno Kid) (Personalidad Distraido) (Cronometro ?c))
    (test (> ?c 5))
    ;Se ejecuta luego de recibir input (x,y) del usuario
    (xKid ?x)
    (yKid ?y)
    ;!!!! Ver como dar prioridad sobre juegaKid_3R y corregirAccionIncorrecta
    ;Por ahora prioridad con salience, pero ver si se puede implementar otra cosa
    ;Podria implementar un hecho warningDistracted
    (salience 10)
    =>
    (printout t "Has tardado mucho tiempo en elegir! Tienes que concentrarte mejor." crlf)
)

;Las reglas siguientes se ejecutan antes de que el robot mueva
(defrule warningBeforeTurn_Impacient
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Impaciente) (Turno Robot) (Ronda ?ron))
    =>
    (printout t " ¡No seas impaciente, espera a que yo mueva primero!")
    (assert (warningBeforeDone True))
)

(defrule warningBeforeTurn_Distracted
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Distraido) (Turno Robot) (Ronda ?ron))
    =>
    (printout t "¡Recuerda que despues de mi turno te toca a ti!")
    (assert (warningBeforeDone True))
)

(defrule corregirCasillaOutOfBounds
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

(defrule corregirCasillaOcupada_3R
    ;Se corrige al recibir input (x,y) del usuario
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ;Ejecutar regla cuando casilla (x,y) Activada (ocupada)
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada True))
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid))
    =>
    (printout t "Accion incorrecta! La casilla que has elegido esta ocupada." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
)




