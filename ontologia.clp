;(defclass JUGADOR (is-a USER)
;   (slot Nombre (type STRING))
;   (slot Ultima_accion (type SYMBOL) (allowed-symbols Ninguna) (default Ninguna)) 
;)

;(defclass ROBOT (is-a JUGADOR))

;(defclass NINO (is-a JUGADOR)
;    (slot Personalidad (type SYMBOL) (allowed-symbols Neutro Distraido Impaciente) (default Neutro))
;    (slot Eleccion (type SYMBOL) (allowed-symbols Tres_en_raya Juego_de_memoria))
;)

(defclass control (is-a USER)
    (slot eleccion (type SYMBOL) (allowed-symbols 3R JM))
    (slot personalidad (type SYMBOL) (allowed-symbols neutro distraido impaciente))
    (slot turno (type SYMBOL) (allowed-symbols kid robot))
)

(defclass JUEGO (is-a USER)
    (slot ID (type SYMBOL) (allowed-symbols 3R JM))
;    (slot Estado (type STRING))
;    pensar que acciones queremos hacer (de momento he puesto estas para rellenar)
;    (slot Acciones_validas (type SYMBOL) (allowed-symbols Accion1 Accion2 Accion3)) 
    (slot Tiempo (type INTEGER))
    (slot EnProgreso (type SYMBOL) (allowed-symbols true false))
)

(defclass CASILLA (is-a USER)
    ; Activada: Dos definiciones distintas segun juego
    ; 1. En 3 en Raya, indicada si la casilla esta marcada, un no es que esta en blanco
    ; 2. En el juego de memoria, indica si la carta fue volteada
    (slot Activada (type SYMBOL) (allowed-symbols true false))

    ; Valor: X/O en 3eR, o un animal en JdM
    (slot Valor (type SYMBOL) (allowed-symbols X O Vacia 
        Monkey Dog Cat Horse Shark Tiger Pig Dolphin Dragon Panda Bird Eagle))
    
    (slot x (type INTEGER))
    (slot y (type INTEGER))

)


;(defclass ACCION (is-a USER)
;    (slot Id (type STRING))
;    (slot Usuario (type SYMBOL) (allowed-symbols Robot Niño))
;    (slot Ejecutada (type SYMBOL) (allowed-symbols Si No))
;    (slot Casilla (type )) ;pensar type de Casilla
;)

;(defclass ESTADO (is-a USER)
;    (slot Id (type STRING))
;    (slot Turno (type SYMBOL) (allowed-symbols Robot Niño))
;    Pensar que acciones queremos hacer (de momento he puesto estas para rellenar)
;    (slot Acciones_posibles (allowed-symbols Accion1 Accion2 Accion3)) 
;    (slot Casillas (type )) ;pensar type para Casillas
;
;)






