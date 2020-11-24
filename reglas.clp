; Creamos una regla para indicar las opciones elegidas y crear instancias de robot y niño
; una vez creadas esas instancias se crea el juego elegido 3R/Memoria
; Para las personalidades creamos 3 modos de funcionamiento: Neutro, Impaciente, Distraido

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

; Mi idea para las casillas
; Crear un template/clase casilla con atributos x,y,activa,valor
; Activa = True --> Carta volteada (En Memoria) OR Casilla Marcada por Usuario (3R)
; Valor = X/O (En 3R) OR Forma en la carta (Memoria)
(defrule jugar_tresEnRaya

    ?ni <- (object (is-a NIÑO) (Nombre ?nomn) (Ultima_accion ?ult_acc) (Personalidad ?per) (Eleccion Tres_en_raya))
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

(defrule marcarCasilla
    (movimiento (usuario ?u) (x ?x) (y ?y))
    (turno ?u)
    ?c <- (casilla (x ?x) (y ?y) (vacio true))
    ?jugador <- 
    ;Instancia del jugador (nino o robot) que coincide con el usuario ?u
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


; Esta bien generar dos reglas para generar cada juego? o podriamos decir que ambos tienen 9 casillas?
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





