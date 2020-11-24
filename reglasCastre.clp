;Regla en la que sel usuario introduce mediante input la personalidad y la eleccion del niño y creamos la instancia del niño en la base de hechos
(defrule Comienzo_Juego
    =>
    (printout t "El juego elegido es: " ?elec (assert (Eleccion ?elec (read))))
    (printout t "La personalidad del niño es: " ?per (assert (Personalidad ?per (read))))
    (make-instance of NIÑO (Nombre Nino) (Ultima_accion Ninguna) (Personalidad ?per) (Eleccion ?elec))
)



(defrule Jugar_tresEnRaya
    ?ni <- (object (is-a NIÑO) (Nombre ?nomn) (Ultima_accion ?ult_acc) (Personalidad Neutro) (Eleccion Tres_en_raya))
    ?robot <- (object (is-a ROBOT) (Nombre ?nomr) (Ultima_accion ?ult_acc))
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



(defrule Jugar_tresEnRaya_Impaciente
    ?ni <- (object (is-a NIÑO) (Nombre ?nomn) (Ultima_accion ?ult_acc) (Personalidad Impaciente) (Eleccion Tres_en_raya))
    ?robot <- (object (is-a ROBOT) (Nombre ?nomr) (Ultima_accion ?ult_acc))
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



(defrule Jugar_tresEnRaya_Distraido
    ?ni <- (object (is-a NIÑO) (Nombre ?nomn) (Ultima_accion ?ult_acc) (Personalidad Distraido) (Eleccion Tres_en_raya))
    ?robot <- (object (is-a ROBOT) (Nombre ?nomr) (Ultima_accion ?ult_acc))
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



(defrule Jugar_juegoMemoria
    ?ni <- (object (is-a NIÑO) (Nombre ?nomn) (Ultima_accion ?ult_acc) (Personalidad Neutro) (Eleccion Juego_de_memoria))
    ?robot <- (object (is-a ROBOT) (Nombre ?nomr) (Ultima_accion ?ult_acc))
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



(defrule Jugar_juegoMemoria_Impaciente
    ?ni <- (object (is-a NIÑO) (Nombre ?nomn) (Ultima_accion ?ult_acc) (Personalidad Impaciente) (Eleccion Juego_de_memoria))
    ?robot <- (object (is-a ROBOT) (Nombre ?nomr) (Ultima_accion ?ult_acc))
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



(defrule Jugar_juegoMemoria_Distraido
    ?ni <- (object (is-a NIÑO) (Nombre ?nomn) (Ultima_accion ?ult_acc) (Personalidad Distraido) (Eleccion Juego_de_memoria))
    ?robot <- (object (is-a ROBOT) (Nombre ?nomr) (Ultima_accion ?ult_acc))
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