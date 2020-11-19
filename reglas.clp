(defrule comenzar_juego
    (eleccion ?c)
    (personalidad ?p)

    =>
    (printout t "El juego elegido es:" ?c crlf)
    (printout t "El nino se caracteriza por ser:" ?p crlf)
    ;Inicializar juego elegido
    ;Crear instancia del nino
    ;Crear instancia del robot
)

(defrule jugar_tresEnRaya
    (eleccion tresEnRaya)
    ;Verificar que ya existe nino y robot
    =>
    (casilla (x 1) (y 1) (vacio true))
    (casilla (x 2) (y 1) (vacio true))
    (casilla (x 3) (y 1) (vacio true))
    (casilla (x 1) (y 2) (vacio true))
    (casilla (x 2) (y 2) (vacio true))
    (casilla (x 3) (y 2) (vacio true))
    (casilla (x 1) (y 3) (vacio true))
    (casilla (x 2) (y 3) (vacio true))
    (casilla (x 3) (y 3) (vacio true))
)

(defrule marcarCasilla
    (movimiento (usuario ?u) (x ?x) (y ?y))
    (turno ?u)
    ?c <- (casilla (x ?x) (y ?y) (vacio true))
    ?jugador <- ;Instancia del jugador (nino o robot) que coincide con el usuario ?u
    ;Suponer que el valor x/o se extrae como ?v
    =>
    (retract ?c)
    (assert (casilla (x ?x) (y ?y) (vacio false) (valor ?v)))
    ;Tambien podria poner como valor ?u (no hace falta que sean x/o, pues
    ; no vamos a imprimir el tablero?)
)

;Podria crear contadores para cada fila/columna/diagonal por usuario e irlos actualizando
;O crear un solo contador por usuario
;ver alguna forma de sumar en una regla las casillas que se llevan en todas direcciones
;y actualizar el contado del usuario correspondiente 
(defrule actualizarContadorJugador
    ;verificar que existe una casilla a la que el usuario ?u le ha puesto un valor
    ;verificar que la suma horizontal, vertical o diagonal de las casillas correspondientes
    ;a la que se coloco, sea mayor al hecho contador actual del usuario
    =>
    ;actualizar contador
)

(defrule victoria3Raya
    ;verificar que existe un hecho contador de un usuario ?u que sume 3
    =>
    ;print: El usuario ?u ha ganado!
)



(defrule jugar_juegoMemoria
    (eleccion tresEnRaya)
    ;Verificar que ya existe nino y robot
    =>
    (casilla (x 1) (y 1))
    (casilla (x 2) (y 1))
    (casilla (x 3) (y 1))
    (casilla (x 1) (y 2))
    (casilla (x 2) (y 2))
    (casilla (x 3) (y 2))
    (casilla (x 1) (y 3))
    (casilla (x 2) (y 3))
    (casilla (x 3) (y 3))
)





