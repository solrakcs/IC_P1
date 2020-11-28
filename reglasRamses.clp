; =================== REGLAS DE COMIENZO DE SESION ==========================

;El usuario elige juego y personalidad del niño.
;La entrada se almancena en los hechos correspondientes
(defrule pickGameNPersonality
    =>
    (printout t "El juego elegido es: ")
    (assert (eleccion_usuario (read)))
    (printout t "La personalidad del niño es: ")
    (assert (personalidad_usuario (read)))
)

;Se genera la instancia de CONTROL a partir de la entrada del usuario
(defrule readGameNPersonality
    (eleccion_usuario ?elec)
    (personalidad_usuario ?per)
    =>
    (make-instance of CONTROL (Eleccion ?elec) (Personalidad ?per) (Turno Robot) (ScoreRobot 0) (ScoreKid 0) (Ronda 1))
    (assert(robotSymbol X))
    (assert(userSymbol O))
    (retract ?elec)
    (retract ?per)
)


; ===================== REGLAS TRES EN RAYA ====================


;Primera regla que se ejecuta cuando el juego elegido es el Tres en Raya. 
;Inicializa el tablero para llevar a cabo el juego
(defrule initBoard3R
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad ?p) (Ronda ?r))
    (not(juego_iniciado true))
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
    (assert (juego_iniciado true))
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
            (eq ?va1 ?va2 ?va3))

    ;(test ((eq ?va1 ?va2 ?va3) or (eq ?va1 ?va4 ?va7) or (eq ?va1 ?va5 ?va9) or (eq ?va2 ?va5 ?va8) or 
    ;    (eq ?va3 ?va6 ?va9) or (eq ?va4 ?va5 ?va6) or (eq ?va7 ?va8 ?va9) or (eq ?va7 ?va5 ?va3)))
    =>
    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
    (halt)
)


; --------- Estrategias del Robot en 3 en Raya ----------------

;Estrategia Robot en Ronda 1
(defrule JuegaRobot_3R_Ronda1
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Robot) (Personalidad ?p) (Ronda ?r))
    (test (= ?r 1))
    ?cas <- (object (is-a CASILLA) (x 1) (y 1) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))
    =>
    (modify-instance ?cas (x 1) (y 1) (Valor X) (Activada True) (Ronda (+ ?r 1)))
    (modify-instance ?con (Turno Kid))
    (retract ?w)
)

;Estrategia Robot en Ronda 2
(defrule JuegaRobot_3R_Ronda2
    ;Si el niño todavia no ha colocado una O en la casilla del medio (2,2) 
    ;Entonces colocar una X en la esquina (1,3), asegurando una victoria en la siguiente ronda
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Robot) (Personalidad ?p) (Ronda ?r))
    (test (= ?r 2))
    ?casM <- (object (is-a CASILLA) (x 2) (y 2) (Activada False))
    ?cas2 <- (object (is-a CASILLA) (x 1) (y 3) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))
    =>
    (modify-instance ?casM (x 1) (y 3) (Valor X) (Activada True) (Ronda (+ ?r 1)))
    (modify-instance ?con (Turno Kid))
    (retract ?w)
)

;Estrategia Robot en Ronda 3 o más, o si en la ronda 2 esta ocupada la casilla (2,2)
(defrule JuegaRobot_3R_RRondas
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Robot) (Personalidad ?p) (Ronda ?ron))
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
    (modify-instance ?cas (Valor X) (Activada True) (Ronda (+ ?ron 1)))
    (modify-instance ?con (Turno Kid))
    (retract ?w)
)

; --------------- Reglas de Input del Usuario para 3 en Raya -----------------

; Regla para leer el input del niño
(defrule inputKid_3R
    ;Cuando es el turno del niño..
    ?con <- (object (is-a CONTROL) (Turno Kid) (Cronometro ?c))
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
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid))
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada False))
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    =>
    (retract ?xkid)
    (retract ?ykid)
    (modify-instance ?cas (Valor O) (Activada true))
    (modify-instance ?con (Turno robot)))
)

; ------------------ Reglas para interaccion Robot-Paciente --------------------

(defrule overTimeDistractedKid
    ?con <- (object (is-a CONTROL) (Turno Kid) (Personalidad Distraido) (Cronometro ?c))
    (test (> ?c 5))
    (xKid ?x)
    (yKid ?y)
    ;Ver como dar prioridad sobre juegaKid_3R
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

(defrule corregirAccionIncorrecta_3R
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada True))
    
    ;Ejecutar regla si x > 3 OR x < 1 OR y > 3 OR y < 1 OR  casilla (x,y) Activada (ocupada)
    (test (or 
            (or 
                (or 
                    (or 
                        (eq ?a True)
                        (< y 1))
                    (> y 3)
                (< x 1))
            (> x 3))
    =>
    (printout t "Accion incorrecta! La casilla que has elegido esta Ocupada o Fuera de rango." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
)




