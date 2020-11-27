;Regla en la que sel usuario introduce mediante input la personalidad y la eleccion del niño y creamos la instancia del niño en la base de hechos
(defrule Datos_Comienzo_Juego
    (salience 100)
    =>
    (printout t "El juego elegido es: ")
    (assert (eleccion_usuario (read)))
    (printout t "La personalidad del niño es: ")
    (assert (personalidad_usuario (read)))
)


(defrule Comienzo_Juego
    (salience 90)
    ?elec <- (eleccion_usuario)
    ?per <- (personalidad_usuario)
    =>
    (make-instance of CONTROL (Eleccion ?elec) (Personalidad ?per) (Turno Robot) (ScoreRobot 0) (ScoreKid 0) (Ronda -1))
    (retract ?elec)
    (retract ?per)
)


; ===================== REGLAS TRES EN RAYA ====================


;Primera regla que se ejecuta cuando el niño tiene personalidad neutra y el juego que ha elegido es el Tres en Raya. Establece todo el tablero para llevar a cabo el juego
(defrule jugar_3R_Neutro
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Neutro) (Ronda -1))
    =>
    (make-instance of CASILLA (x 1) (y 1) (valor Vacia))
    (make-instance of CASILLA (x 2) (y 1) (valor Vacia))
    (make-instance of CASILLA (x 3) (y 1) (valor Vacia))
    (make-instance of CASILLA (x 1) (y 2) (valor Vacia))
    (make-instance of CASILLA (x 2) (y 2) (valor Vacia))
    (make-instance of CASILLA (x 3) (y 2) (valor Vacia))
    (make-instance of CASILLA (x 1) (y 3) (valor Vacia))
    (make-instance of CASILLA (x 2) (y 3) (valor Vacia))
    (make-instance of CASILLA (x 3) (y 3) (valor Vacia))
    (modify-instance ?con (Ronda + 1))
)


;Primera regla que se ejecuta cuando el niño tiene personalidad impaciente y el juego que ha elegido es el Tres en Raya. Establece todo el tablero para llevar a cabo el juego
(defrule jugar_3R_Impaciente
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Impaciente) (Ronda -1))
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
    (modify-instance ?con (Ronda + 1)) ;revisar que esto se ahaga asi, aunque creo que si
)


;Primera regla que se ejecuta cuando el niño tiene personalidad distraida y el juego que ha elegido es el Tres en Raya. Establece todo el tablero para llevar a cabo el juego
(defrule jugar_3R_Distraido
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Distraido) (Ronda -1))
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
    (modify-instance ?con (Ronda + 1))
)


;(defrule CondicionVictoria_3R
;    ; Crear algun atributo que diga X es Robot y O es Usuario
;    ; Para luego hacer match aqui y poder imprimir quien gano
;    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno ?turn) (Ronda ?ron))
;    (test (> ?ron 2))
;
;    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (Valor ?va1))
;    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (Valor ?va2))
;    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (Valor ?va3))
;    ?cas4 <- (object (is-a CASILLA) (x 1) (y 2) (Valor ?va4))
;    ?cas5 <- (object (is-a CASILLA) (x 2) (y 2) (Valor ?va5))
;    ?cas6 <- (object (is-a CASILLA) (x 3) (y 2) (Valor ?va6))
;    ?cas7 <- (object (is-a CASILLA) (x 1) (y 3) (Valor ?va7))
;    ?cas8 <- (object (is-a CASILLA) (x 2) (y 3) (Valor ?va8))
;    ?cas9 <- (object (is-a CASILLA) (x 3) (y 3) (Valor ?va9))
;    ;(test ((= ?va1 ?va2 ?va3) or (= ?va1 ?va4 ?va7) or (= ?va1 ?va5 ?va9) or (= ?va2 ?va5 ?va8) or 
;    ;    (= ?va3 ?va6 ?va9) or (= ?va4 ?va5 ?va6) or (= ?va7 ?va8 ?va9) or (= ?va7 ?va5 ?va3)))
;    (test (eq ?va1 ?va2 ?va3)) or (test (eq ?va1 ?va4 ?va7))
;    =>
;    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
;    (halt)
;)


(defrule JuegaRobot_3R_Ronda1_Neutro
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Neutro) (Turno Robot) (Ronda 0))
    ?cas <- (object (is-a CASILLA) (x 1) (y 1) (Activada False))
    =>
    (modify-instance ?cas (x 1) (y 1) (Valor X) (Activada True) (Ronda + 1))
    (modify-instance ?con (Turno Kid))
)


(defrule JuegaRobot_3R_Ronda1_Impaciente
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Impaciente) (Turno Robot) (Ronda 0))
    ?cas <- (object (is-a CASILLA) (x 1) (y 1) (Activada False))
    =>
    (printout t " ¡No seas impaciente, espera a que yo mueva primero!")
    (modify-instance ?cas (x 1) (y 1) (Valor X) (Activada True) (Ronda + 1))
    (modify-instance ?con (Turno Kid))
)


(defrule JuegaRobot_3R_Ronda1_Distraido
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Distraido) (Turno Robot) (Ronda 0))
    ?cas <- (object (is-a CASILLA) (x 1) (y 1) (Activada False))
    =>
    (printout t "¡Recuerda que despues de mi turno te toca a ti!")
    (modify-instance ?cas (x 1) (y 1) (Valor X) (Activada True) (Ronda + 1))
    (modify-instance ?con (Turno Kid))
)



(defrule JuegaRobot_3R_Ronda2_Neutro
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Neutro) (Turno Robot) (Ronda 1))
    ?cas <- (object (is-a CASILLA) (x 2) (y 2) (Activada False))
    =>
    (modify-instance ?cas (x 1) (y 3) (Valor X) (Activada True) (Ronda + 1))
    (modify-instance ?con (Turno Kid))
)


(defrule JuegaRobot_3R_Ronda2_Impaciente
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Impaciente) (Turno Robot) (Ronda 1))
    ?cas <- (object (is-a CASILLA) (x 2) (y 2) (Activada False))
    =>
    (printout t " ¡No seas impaciente, espera a que yo mueva primero!")
    (modify-instance ?cas (x 1) (y 3) (Valor X) (Activada True) (Ronda + 1))
    (modify-instance ?con (Turno Kid))
)


(defrule JuegaRobot_3R_Ronda2_Distraido
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Distraido) (Turno Robot) (Ronda 1))
    ?cas <- (object (is-a CASILLA) (x 2) (y 2) (Activada False))
    =>
    (printout t "¡Recuerda que despues de mi turno te toca a ti!")
    (modify-instance ?cas (x 1) (y 3) (Valor X) (Activada True) (Ronda + 1))
    (modify-instance ?con (Turno Kid))
)


(defrule JuegaRobot_3R_RRondas_Neutro
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Neutro) (Turno Robot) (Ronda ?ron))
    ?cas <- (object (is-a CASILLA) (Activada False))
    (test (> ?ron 1))
    =>
    (modify-instance ?cas (Valor X) (Activada True) (Ronda (+ ?ron 1)))
    (modify-instance ?con (Turno Kid))
)


(defrule JuegaRobot_3R_RRondas_Impaciente
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Impaciente) (Turno Robot) (Ronda ?ron))
    ?cas <- (object (is-a CASILLA) (Activada False))
    (test (> ?ron 1))
    =>
    (printout t " ¡No seas impaciente, espera a que yo mueva primero!")
    (modify-instance ?cas (Valor X) (Activada True) (Ronda (+ ?ron 1)))
    (modify-instance ?con (Turno Kid))
)


(defrule JuegaRobot_3R_RRondas_Distraido
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad Distraido) (Turno Robot) (Ronda ?ron))
    ?cas <- (object (is-a CASILLA) (Activada False))
    (test (> ?ron 1))
    =>
    (printout t "¡Recuerda que despues de mi turno te toca a ti!")
    (modify-instance ?cas (Valor X) (Activada True) (Ronda (+ ?ron 1)))
    (modify-instance ?con (Turno Kid))
)



