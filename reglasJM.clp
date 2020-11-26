; ==================== REGLAS JUEGO DE MEMORIA ==========================

;Regla para iniciar las CASILLAS si el juego es Juego_de_memoria
(defrule Jugar_JM
    ?ni <- (object (is-a NINO) (Eleccion Juego_de_memoria))
    =>
    (make-instance-of CASILLA (x 1) (y 1) (valor Monkey))
    (make-instance-of CASILLA (x 2) (y 1) (valor Dog))
    (make-instance-of CASILLA (x 3) (y 1) (valor Monkey))
    (make-instance-of CASILLA (x 4) (y 1) (valor Dog))
    (make-instance-of CASILLA (x 5) (y 1) (valor Cat))
    (make-instance-of CASILLA (x 6) (y 1) (valor Horse))
    (make-instance-of CASILLA (x 7) (y 1) (valor Cat))
    (make-instance-of CASILLA (x 8) (y 1) (valor Horse))
    (make-instance-of CASILLA (x 9) (y 1) (valor Shark))
    (make-instance-of CASILLA (x 10) (y 1) (valor Tiger))
    (make-instance-of CASILLA (x 11) (y 1) (valor Shark))
    (make-instance-of CASILLA (x 12) (y 1) (valor Tiger))
    (make-instance-of CASILLA (x 13) (y 1) (valor Pig))
    (make-instance-of CASILLA (x 14) (y 1) (valor Dolphin))
    (make-instance-of CASILLA (x 15) (y 1) (valor Pig))
    (make-instance-of CASILLA (x 16) (y 1) (valor Dolphin))
    (make-instance-of CASILLA (x 17) (y 1) (valor Dragon))
    (make-instance-of CASILLA (x 18) (y 1) (valor Panda))
    (make-instance-of CASILLA (x 19) (y 1) (valor Dragon))
    (make-instance-of CASILLA (x 20) (y 1) (valor Panda))
    (make-instance-of CASILLA (x 21) (y 1) (valor Bird))
    (make-instance-of CASILLA (x 22) (y 1) (valor Eagle))
    (make-instance-of CASILLA (x 23) (y 1) (valor Bird))
    (make-instance-of CASILLA (x 24) (y 1) (valor Eagle))
)


(defrule CondicionVictoria_JM
    ?con <- (object (is-a CONTROL) (eleccion Juego_de_memoria) (turno ?turn))
    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (Valor Monkey) (Activada True))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (Valor Dog) (Activada True))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (Valor Monkey) (Activada True))
    ?cas4 <- (object (is-a CASILLA) (x 4) (y 1) (Valor Dog) (Activada True))
    ?cas5 <- (object (is-a CASILLA) (x 5) (y 1) (Valor Cat) (Activada True))
    ?cas6 <- (object (is-a CASILLA) (x 6) (y 1) (Valor Horse) (Activada True))
    ?cas7 <- (object (is-a CASILLA) (x 7) (y 1) (Valor Cat) (Activada True))
    ?cas8 <- (object (is-a CASILLA) (x 8) (y 1) (Valor Horse) (Activada True))
    ?cas9 <- (object (is-a CASILLA) (x 9) (y 1) (Valor Shark) (Activada True))
    ?cas10 <- (object (is-a CASILLA) (x 10) (y 1) (Valor Tiger) (Activada True))
    ?cas11 <- (object (is-a CASILLA) (x 11) (y 1) (Valor Shark) (Activada True))
    ?cas12 <- (object (is-a CASILLA) (x 12) (y 1) (Valor Tiger) (Activada True))
    ?cas13 <- (object (is-a CASILLA) (x 13) (y 1) (Valor Pig) (Activada True))
    ?cas14 <- (object (is-a CASILLA) (x 14) (y 1) (Valor Dolphin) (Activada True))
    ?cas15 <- (object (is-a CASILLA) (x 15) (y 1) (Valor Pig) (Activada True))
    ?cas16 <- (object (is-a CASILLA) (x 16) (y 1) (Valor Dolphin) (Activada True))
    ?cas17 <- (object (is-a CASILLA) (x 17) (y 1) (Valor Dragon) (Activada True))
    ?cas18 <- (object (is-a CASILLA) (x 18) (y 1) (Valor Panda) (Activada True))
    ?cas19 <- (object (is-a CASILLA) (x 19) (y 1) (Valor Dragon) (Activada True))
    ?cas20 <- (object (is-a CASILLA) (x 20) (y 1) (Valor Panda) (Activada True))
    ?cas21 <- (object (is-a CASILLA) (x 21) (y 1) (Valor Bird) (Activada True))
    ?cas22 <- (object (is-a CASILLA) (x 22) (y 1) (Valor Eagle) (Activada True))
    ?cas23 <- (object (is-a CASILLA) (x 23) (y 1) (Valor Bird) (Activada True))
    ?cas24 <- (object (is-a CASILLA) (x 24) (y 1) (Valor Eagle) (Activada True))
    =>
    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
    (halt)
)


(defrule juegaRobot_JM_Ronda1_Neutro
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Personalidad Neutro) (Turno Robot) (Ronda 0))
    ?cas <- (object (is-a CASILLA) (Valor ?va) (Activada False))
    =>
    (modify-instance ?cas (Valor ?va) (Activada True) (+ Ronda 1))
    (modify-instance ?con (Turno Kid)))
)


(defrule JuegaRobot_JM_Ronda1_Impaciente
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Personalidad Impaciente) (Turno Robot) (Ronda 0))
    ?cas <- (object (is-a CASILLA) (Valor ?va) (Activada False))
    =>
    (printout t " ¡No seas impaciente, espera a que yo mueva primero!")
    (modify-instance ?cas (Valor ?va) (Activada True) (+ Ronda 1))
    (modify-instance ?con (Turno Kid)))
)


(defrule JuegaRobot_JM_Ronda1_Distraido
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Personalidad Impaciente) (Turno Robot) (Ronda 0))
    ?cas <- (object (is-a CASILLA) (Valor ?va) (Activada False))
    =>
    (printout t "¡Recuerda que despues de mi turno te toca a ti!")
    (modify-instance ?cas (Valor ?va) (Activada True) (+ Ronda 1))
    (modify-instance ?con (Turno Kid)))
)

