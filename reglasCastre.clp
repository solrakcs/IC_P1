;Regla en la que sel usuario introduce mediante input la personalidad y la eleccion del niño y creamos la instancia del niño en la base de hechos
(defrule Comienzo_Juego
    =>
    (printout t "El juego elegido es: " ?elec (assert (Eleccion ?elec (read))))
    (printout t "La personalidad del niño es: " ?per (assert (Personalidad ?per (read))))
    (make-instance of NIÑO (Nombre Nino) (Ultima_accion Ninguna) (Personalidad ?per) (Eleccion ?elec))
)


;Regla para iniciar las casillas si el juego es Tres_en_raya
(defrule Jugar_tresEnRaya
    ?ni <- (object (is-a NIÑO) (Eleccion Tres_en_raya))
    =>
    (Casilla (x 1) (y 1) (vacio true))
    (Casilla (x 2) (y 1) (vacio true))
    (Casilla (x 3) (y 1) (vacio true))
    (Casilla (x 1) (y 2) (vacio true))
    (Casilla (x 2) (y 2) (vacio true))
    (Casilla (x 3) (y 2) (vacio true))
    (Casilla (x 1) (y 3) (vacio true))
    (Casilla (x 2) (y 3) (vacio true))
    (Casilla (x 3) (y 3) (vacio true))

)


;Regla para iniciar las casillas si el juego es Juego_de_memoria
(defrule Jugar_juegoMemoria
    ?ni <- (object (is-a NIÑO) (Eleccion Juego_de_memoria))
    =>
    (Casilla (x 1) (y 1) (vacio true))
    (Casilla (x 2) (y 1) (vacio true))
    (Casilla (x 3) (y 1) (vacio true))
    (Casilla (x 4) (y 1) (vacio true))
    (Casilla (x 5) (y 1) (vacio true))
    (Casilla (x 6) (y 1) (vacio true))
    (Casilla (x 7) (y 1) (vacio true))
    (Casilla (x 8) (y 1) (vacio true))
    (Casilla (x 9) (y 1) (vacio true))
    (Casilla (x 10) (y 1) (vacio true))
    (Casilla (x 11) (y 1) (vacio true))
    (Casilla (x 12) (y 1) (vacio true))
    (Casilla (x 13) (y 1) (vacio true))
    (Casilla (x 14) (y 1) (vacio true))
    (Casilla (x 15) (y 1) (vacio true))
    (Casilla (x 16) (y 1) (vacio true))
    (Casilla (x 17) (y 1) (vacio true))
    (Casilla (x 18) (y 1) (vacio true))
    (Casilla (x 19) (y 1) (vacio true))
    (Casilla (x 20) (y 1) (vacio true))
    (Casilla (x 21) (y 1) (vacio true))
    (Casilla (x 22) (y 1) (vacio true))
    (Casilla (x 23) (y 1) (vacio true))
    (Casilla (x 24) (y 1) (vacio true))
)


(defrule Finalizar_Juego


)