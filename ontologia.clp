(defclass JUGADOR (is-a USER)
    (slot Nombre (type STRING))
    (slot Ultima_accion (type )) ;Duda sobre tipo de Ultima_accion
)


(defclass ROBOT (is-a JUGADOR))


(defclass NIÑO (is-a JUGADOR)
    (slot Personalidad (type SYMBOL) (allowed-symbols Neutro Distraido Impaciente) (default Neutro))
    (slot Eleccion (type SYMBOL) (allowed-symbols Tres_en_raya Juego_de_memoria))
)


(defclass ACCION (is-a USER)
    (slot Id (type STRING))
    (slot Usuario (type SYMBOL) (allowed-symbols Robot Niño))
    (slot Ejecutada (type SYMBOL) (allowed-symbols Si No))
    (slot Casilla (type )) ;pensar type de Casilla
)


(defclass JUEGO (is-a USER)
    (slot Nombre (type STRING))
    (slot Estado (type STRING)) ;pensar type (creo que es STRING)
    (slot Acciones_validas (type SYMBOL) (allowed-symbols Accion1 Accion2 Accion3)) ;pensar que acciones queremos hacer (de momento he puesto estas para rellenar)
    (slot Tiempo (type Integer))
    (slot Estado_final (type SYMBOL) (allowed-symbols Estado1 Estado2)) ;pensar que estados finales queremos hacer
)


(defclass ESTADO (is-a USER)
    (slot Id (type STRING))
    (slot Turno (type SYMBOL) (allowed-symbols Robot Niño))
    (slot Acciones_posibles (allowed-symbols Accion1 Accion2 Accion3)) ;pensar que acciones queremos hacer (de momento he puesto estas para rellenar)
    (slot Casillas (type )) ;pensar type para Casillas
)


(defclass CASILLA (is-a USER)
    (slot Activada (type SYMBOL) (allowed-symbols Si No))
    (slot Valor (type SYMBOL) (allowed-symbols X O Vacia Circulo Triangulo Cuadrado Estrella))
    (slot x (type INTEGER))
    (slot y (type INTEGER))
)


(defclass CASILLA_3_RAYA (is-a CASILLA))


(defclass CASILLA_MEMORIA (is a CASILLA))





