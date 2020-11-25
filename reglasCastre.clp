;Regla en la que sel usuario introduce mediante input la personalidad y la eleccion del niño y creamos la instancia del niño en la base de hechos
(defrule Comienzo_Juego
    =>
    (printout t "El juego elegido es: " ?elec (assert (Eleccion ?elec (read))))
    (printout t "La personalidad del niño es: " ?per (assert (Personalidad ?per (read))))
    (make-instance of NIÑO (Nombre Nino) (Ultima_accion Ninguna) (Personalidad ?per) (Eleccion ?elec))
)

; ===================== REGLAS TRES EN RAYA ====================

;Regla para iniciar las casillas si el juego es Tres_en_raya
(defrule Jugar_tresEnRaya
    ?ni <- (object (is-a NIÑO) (Eleccion Tres_en_raya))
    =>
    (Casilla (x 1) (y 1) (Valor Vacia))
    (Casilla (x 2) (y 1) (Valor Vacia))
    (Casilla (x 3) (y 1) (Valor Vacia))
    (Casilla (x 1) (y 2) (Valor Vacia))
    (Casilla (x 2) (y 2) (Valor Vacia))
    (Casilla (x 3) (y 2) (Valor Vacia))
    (Casilla (x 1) (y 3) (Valor Vacia))
    (Casilla (x 2) (y 3) (Valor Vacia))
    (Casilla (x 3) (y 3) (Valor Vacia))
)

(defrule condicionVictoria_tresEnRaya
    ; Crear algun atributo que diga X es Robot y O es Usuario
    ; Para luego hacer match aqui y poder imprimir quien gano
    ?con <- (object (is-a control) (eleccion Tres_en_raya) (turno ?turn))

    ?cas1 <- (object (is-a casilla) (x 1) (y 1) (valor ?va1))
    ?cas2 <- (object (is-a casilla) (x 2) (y 1) (valor ?va2))
    ?cas3 <- (object (is-a casilla) (x 3) (y 1) (valor ?va3))
    ?cas4 <- (object (is-a casilla) (x 1) (y 2) (valor ?va4))
    ?cas5 <- (object (is-a casilla) (x 2) (y 2) (valor ?va5))
    ?cas6 <- (object (is-a casilla) (x 3) (y 2) (valor ?va6))
    ?cas7 <- (object (is-a casilla) (x 1) (y 3) (valor ?va7))
    ?cas8 <- (object (is-a casilla) (x 2) (y 3) (valor ?va8))
    ?cas9 <- (object (is-a casilla) (x 3) (y 3) (valor ?va9))

    (test (= ?va1 ?va2 ?va3) or (= ?va1 ?va4 ?va7) or (= ?va1 ?va5 ?va9) or (= ?va2 ?va5 ?va8) or 
          (= ?va3 ?va6 ?va9) or (= ?va4 ?va5 ?va6) or (= ?va7 ?va8 ?va9) or (= ?va7 ?va5 ?va3))
    =>
    (printout t "¡El juego ha acabado! El ganador es: " ?turn crlf)
    (halt)
)

(defrule juegaRobot_3R
    ?con <- (object (is-a control) (eleccion Tres_en_raya) (turno robot))
    ?cas <- (object (is-a casilla) (activada false))
    =>
    (modify-instance ?cas (valor X) (activada true))
    (modify-instance ?con (turno kid)))
)

(defrule inputKid
    ?con <- (object (is-a control) (turno kid))
    =>
    (printout t "Enter x: " crlf)
    (assert (xKid (read)))
    (printout t "Enter y: " crlf)
    (assert (yKid (read)))
)

(defrule corregirAccionIncorrecta_3R
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ; Poner tambien en esta regla si la casilla esta ocupada?
    ;?cas <-- (object (is-a casilla) (x ?) (y ) (activada false))
    (test (> x 3) or (< x 1) or (> y 3) or (< y 1))
    =>
    (printout t "Accion incorrecta, elige X e Y entre [1,3] " crlf)
    (retract ?xkid)
    (retract ?ykid)
)

(defrule juegaKid_3R
    ?con <- (object (is-a control) (eleccion Tres_en_raya) (turno kid))
    ?cas <- (object (is-a casilla) (x ?x) (y ?y) (activada false))
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    =>
    (retract ?xkid)
    (retract ?ykid)
    (modify-instance ?cas (valor O) (activada true))
    (modify-instance ?con (turno robot)))
)

; ==================== REGLAS JUEGO DE MEMORIA ==========================

;Regla para iniciar las casillas si el juego es Juego_de_memoria
(defrule Jugar_juegoMemoria
    ?ni <- (object (is-a NIÑO) (Eleccion Juego_de_memoria))
    =>
    (Casilla (x 1) (y 1) (Valor Vacia))
    (Casilla (x 2) (y 1) (Valor Vacia))
    (Casilla (x 3) (y 1) (Valor Vacia))
    (Casilla (x 4) (y 1) (Valor Vacia))
    (Casilla (x 5) (y 1) (Valor Vacia))
    (Casilla (x 6) (y 1) (Valor Vacia))
    (Casilla (x 7) (y 1) (Valor Vacia))
    (Casilla (x 8) (y 1) (Valor Vacia))
    (Casilla (x 9) (y 1) (Valor Vacia))
    (Casilla (x 10) (y 1) (Valor Vacia))
    (Casilla (x 11) (y 1) (Valor Vacia))
    (Casilla (x 12) (y 1) (Valor Vacia))
    (Casilla (x 13) (y 1) (Valor Vacia))
    (Casilla (x 14) (y 1) (Valor Vacia))
    (Casilla (x 15) (y 1) (Valor Vacia))
    (Casilla (x 16) (y 1) (Valor Vacia))
    (Casilla (x 17) (y 1) (Valor Vacia))
    (Casilla (x 18) (y 1) (Valor Vacia))
    (Casilla (x 19) (y 1) (Valor Vacia))
    (Casilla (x 20) (y 1) (Valor Vacia))
    (Casilla (x 21) (y 1) (Valor Vacia))
    (Casilla (x 22) (y 1) (Valor Vacia))
    (Casilla (x 23) (y 1) (Valor Vacia))
    (Casilla (x 24) (y 1) (Valor Vacia))
)

(defrule Finalizar_Juego


)