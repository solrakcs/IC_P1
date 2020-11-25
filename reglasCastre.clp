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


(defrule condicionVictoria_tresEnRaya
    (Casilla (x 1) (y 1) (Valor ?va1))
    (Casilla (x 2) (y 1) (Valor ?va2))
    (Casilla (x 3) (y 1) (Valor ?va3))
    (Casilla (x 1) (y 2) (Valor ?va4))
    (Casilla (x 2) (y 2) (Valor ?va5))
    (Casilla (x 3) (y 2) (Valor ?va6))
    (Casilla (x 1) (y 3) (Valor ?va7))
    (Casilla (x 2) (y 3) (Valor ?va8))
    (Casilla (x 3) (y 3) (Valor ?va9))
    (test (= ?va1 ?va2 ?va3) or (= ?va1 ?va4 ?va7) or (= ?va1 ?va5 ?va9) or (= ?va2 ?va5 ?va8) or (= ?va3 ?va6 ?va9) or (= ?va4 ?va5 ?va6) or (= ?va7 ?va8 ?va9) or (= ?va7 ?va5 ?va3))
    =>
    (printout t "¡El juego ha acabado!")
)

(defrule Finalizar_Juego


)