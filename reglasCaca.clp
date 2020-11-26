;Regla en la que sel usuario introduce mediante input la personalidad y la eleccion del niño y creamos la instancia del niño en la base de hechos
(defrule Comienzo_Juego
    =>
    (printout t "El juego elegido es: " ?elec (assert (Eleccion ?elec (read))))
    (printout t "La personalidad del niño es: " ?per (assert (Personalidad ?per (read))))
    ;(make-instance of NIÑO (Nombre Nino) (Ultima_accion Ninguna) (Personalidad ?per) (Eleccion ?elec))
)

; ===================== REGLAS TRES EN RAYA ====================

;Regla para iniciar las CASILLAs si el juego es Tres_en_raya
(defrule Jugar_tresEnRaya_Neutro
    ?ni <- (object (is-a NINO) (Eleccion Tres_en_raya) (Personalidad Neutra))
    =>
    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (valor vacio))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (valor vacio))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (valor vacio))
    ?cas4 <- (object (is-a CASILLA) (x 1) (y 2) (valor vacio))
    ?cas5 <- (object (is-a CASILLA) (x 2) (y 2) (valor vacio))
    ?cas6 <- (object (is-a CASILLA) (x 3) (y 2) (valor vacio))
    ?cas7 <- (object (is-a CASILLA) (x 1) (y 3) (valor vacio))
    ?cas8 <- (object (is-a CASILLA) (x 2) (y 3) (valor vacio))
    ?cas9 <- (object (is-a CASILLA) (x 3) (y 3) (valor vacio))
    (assert strat11)
)


(defrule Jugar_tresEnRaya_Impaciente
    ?ni <- (object (is-a NINO) (Eleccion Tres_en_raya) (Personalidad Impaciente))
    =>
    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (valor vacio))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (valor vacio))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (valor vacio))
    ?cas4 <- (object (is-a CASILLA) (x 1) (y 2) (valor vacio))
    ?cas5 <- (object (is-a CASILLA) (x 2) (y 2) (valor vacio))
    ?cas6 <- (object (is-a CASILLA) (x 3) (y 2) (valor vacio))
    ?cas7 <- (object (is-a CASILLA) (x 1) (y 3) (valor vacio))
    ?cas8 <- (object (is-a CASILLA) (x 2) (y 3) (valor vacio))
    ?cas9 <- (object (is-a CASILLA) (x 3) (y 3) (valor vacio))
    (assert strat11)
    (assert stratImpaciente)
)


(defrule Jugar_tresEnRaya_Distraido
    ?ni <- (object (is-a NINO) (Eleccion Tres_en_raya) (Personalidad Distraido))
    =>
    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (valor vacio))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (valor vacio))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (valor vacio))
    ?cas4 <- (object (is-a CASILLA) (x 1) (y 2) (valor vacio))
    ?cas5 <- (object (is-a CASILLA) (x 2) (y 2) (valor vacio))
    ?cas6 <- (object (is-a CASILLA) (x 3) (y 2) (valor vacio))
    ?cas7 <- (object (is-a CASILLA) (x 1) (y 3) (valor vacio))
    ?cas8 <- (object (is-a CASILLA) (x 2) (y 3) (valor vacio))
    ?cas9 <- (object (is-a CASILLA) (x 3) (y 3) (valor vacio))
    (assert strat11)
    (assert stratDistraido)
)


(defrule condicionVictoria_tresEnRaya
    ; Crear algun atributo que diga X es Robot y O es Usuario
    ; Para luego hacer match aqui y poder imprimir quien gano
    ?con <- (object (is-a CONTROL) (eleccion Tres_en_raya) (turno ?turn))
    ?strat <- (stratRandom)

    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (valor ?va1))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (valor ?va2))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (valor ?va3))
    ?cas4 <- (object (is-a CASILLA) (x 1) (y 2) (valor ?va4))
    ?cas5 <- (object (is-a CASILLA) (x 2) (y 2) (valor ?va5))
    ?cas6 <- (object (is-a CASILLA) (x 3) (y 2) (valor ?va6))
    ?cas7 <- (object (is-a CASILLA) (x 1) (y 3) (valor ?va7))
    ?cas8 <- (object (is-a CASILLA) (x 2) (y 3) (valor ?va8))
    ?cas9 <- (object (is-a CASILLA) (x 3) (y 3) (valor ?va9))

    (test (= ?va1 ?va2 ?va3) or (= ?va1 ?va4 ?va7) or (= ?va1 ?va5 ?va9) or (= ?va2 ?va5 ?va8) or 
          (= ?va3 ?va6 ?va9) or (= ?va4 ?va5 ?va6) or (= ?va7 ?va8 ?va9) or (= ?va7 ?va5 ?va3))
    =>
    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
    (halt)
)

(defrule juegaRobot_3R_strat11
    ?con <- (object (is-a CONTROL) (Eleccion Tres_en_raya) (turno robot))
    ?cas <- (object (is-a CASILLA) (x 1) (y 1) (Activada False))
    ?strat <- (strat11)
    =>
    (modify-instance ?cas (x 1) (y 1) (valor X) (Activada True))
    (modify-instance ?con (turno kid)))
    (retract ?strat)
    (assert strat12)
)

(defrule juegaRobot_3R_strat12
    ?con <- (object (is-a CONTROL) (Eleccion Tres_en_raya) (turno robot))
    ?cas1 <- (object (is-a CASILLA) (x 2) (y 2) (Activada False))
    ?strat <- (strat12)
    =>
    (modify-instance ?cas1 (x 1) (y 3) (valor X) (Activada True))
    (modify-instance ?con (turno kid)))
    (retract ?strat)
    (assert stratRandom)
)


(defrule juegaRobot_3R_stratRandom
    ?con <- (object (is-a CONTROL) (Eleccion Tres_en_raya) (turno robot))
    ?cas <- (object (is-a CASILLA) (Activada False))
    ?strat <- (stratRandom)
    =>
    (modify-instance ?cas (valor X) (Activada True))
    (modify-instance ?con (turno kid)))
    (retract ?strat)
)



(defrule inputKid_3R
    ?con <- (object (is-a CONTROL) (turno kid))
    ?crono <- (cronometer ?t)
    =>
    (printout t "Enter x: " crlf)
    (assert (xKid (read)))
    (printout t "Enter y: " crlf)
    (assert (yKid (read)))
    (printout t "Enter time take:" crlf)
    (retract ?crono) (assert (cronometer (read)))
)

(defrule corregirAccionIncorrecta_3R
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ; Poner tambien en esta regla si la CASILLA esta ocupada?
    ;?cas <-- (object (is-a CASILLA) (x ?) (y ) (activada false))
    (test (> x 3) or (< x 1) or (> y 3) or (< y 1))
    =>
    (printout t "Accion incorrecta, elige X e Y entre [1,3] " crlf)
    (retract ?xkid)
    (retract ?ykid)
)

(defrule juegaKid_3R
    ?con <- (object (is-a CONTROL) (Eleccion Tres_en_raya) (turno kid))
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada False))
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    =>
    (retract ?xkid)
    (retract ?ykid)
    (modify-instance ?cas (valor O) (activada true))
    (modify-instance ?con (turno robot)))
)

; ==================== REGLAS JUEGO DE MEMORIA ==========================

;Regla para iniciar las CASILLAs si el juego es Juego_de_memoria
(defrule Jugar_juegoMemoria
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

(defrule condicionVictoria_juegoMemoria
    ?con <- (object (is-a CONTROL) (eleccion Juego_de_memoria) (turno ?turn))
    ;contador de robot/usuario == 12

    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (valor Monkey) (Activada True))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (valor Dog) (Activada True))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (valor Monkey) (Activada True))
    ?cas4 <- (object (is-a CASILLA) (x 4) (y 1) (valor Dog) (Activada True))
    ?cas5 <- (object (is-a CASILLA) (x 5) (y 1) (valor Cat) (Activada True))
    ?cas6 <- (object (is-a CASILLA) (x 6) (y 1) (valor Horse) (Activada True))
    ?cas7 <- (object (is-a CASILLA) (x 7) (y 1) (valor Cat) (Activada True))
    ?cas8 <- (object (is-a CASILLA) (x 8) (y 1) (valor Horse) (Activada True))
    ?cas9 <- (object (is-a CASILLA) (x 9) (y 1) (valor Shark) (Activada True))
    ?cas10 <- (object (is-a CASILLA) (x 10) (y 1) (valor Tiger) (Activada True))
    ?cas11 <- (object (is-a CASILLA) (x 11) (y 1) (valor Shark) (Activada True))
    ?cas12 <- (object (is-a CASILLA) (x 12) (y 1) (valor Tiger) (Activada True))
    ?cas13 <- (object (is-a CASILLA) (x 13) (y 1) (valor Pig) (Activada True))
    ?cas14 <- (object (is-a CASILLA) (x 14) (y 1) (valor Dolphin) (Activada True))
    ?cas15 <- (object (is-a CASILLA) (x 15) (y 1) (valor Pig) (Activada True))
    ?cas16 <- (object (is-a CASILLA) (x 16) (y 1) (valor Dolphin) (Activada True))
    ?cas17 <- (object (is-a CASILLA) (x 17) (y 1) (valor Dragon) (Activada True))
    ?cas18 <- (object (is-a CASILLA) (x 18) (y 1) (valor Panda) (Activada True))
    ?cas19 <- (object (is-a CASILLA) (x 19) (y 1) (valor Dragon) (Activada True))
    ?cas20 <- (object (is-a CASILLA) (x 20) (y 1) (valor Panda) (Activada True))
    ?cas21 <- (object (is-a CASILLA) (x 21) (y 1) (valor Bird) (Activada True))
    ?cas22 <- (object (is-a CASILLA) (x 22) (y 1) (valor Eagle) (Activada True))
    ?cas23 <- (object (is-a CASILLA) (x 23) (y 1) (valor Bird) (Activada True))
    ?cas24 <- (object (is-a CASILLA) (x 24) (y 1) (valor Eagle) (Activada True))
    =>
    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
    (halt)
)

(defrule juegaRobot_JM
    ?con <- (object (is-a CONTROL) (eleccion Juego_de_memoria) (turno robot))
    ?cas <- (object (is-a CASILLA) (Valor ?va) (activada False))
    =>
    (modify-instance ?cas (valor ?va) (activada True))
    (modify-instance ?con (turno kid)))
)

(defrule inputKid_JM
    ?con <- (object (is-a CONTROL) (turno kid))
    =>
    (printout t "Enter x: " crlf)
    (assert (xKid (read)))
    (assert (yKid 1)
)

(defrule corregirAccionIncorrecta_JM
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid 1)
    ; Poner tambien en esta regla si la CASILLA esta ocupada?
    ;?cas <-- (object (is-a CASILLA) (x ?) (y ) (activada false))
    (test (< x 25) or (> x 1))
    =>
    (printout t "Accion incorrecta, elige X e Y entre [1,3] " crlf)
    (retract ?xkid)
    (retract ?ykid)
)

(defrule juegaKid_JM
    ?con <- (object (is-a CONTROL) (Eleccion Juego_de_memoria) (turno kid))
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Valor ?va) (Activada False))
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    =>
    (retract ?xkid)
    (retract ?ykid)
    (modify-instance ?cas (Valor ?va) (Activada True))
    (modify-instance ?con (turno robot)))
)