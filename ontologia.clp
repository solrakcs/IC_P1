(defclass CONTROL (is-a USER)
    (slot Eleccion 
        (type SYMBOL) 
        (allowed-symbols 3R JM))
    (slot Personalidad 
        (type SYMBOL) 
        (allowed-symbols Neutro Distraido Impaciente) 
        (default Neutro))
    (slot Turno 
        (type SYMBOL) 
        (allowed-symbols Kid Robot)
        (default Robot))
    (slot ScoreRobot 
        (type INTEGER) 
        (default 0))
    (slot ScoreKid 
        (type INTEGER) 
        (default 0))
    (slot Ronda 
        (type INTEGER) 
        (default 0))
    (slot Cronometro 
        (type INTEGER) 
        (default 0))
)

(defclass JUEGO (is-a USER)
    (slot ID 
        (type SYMBOL) 
        (allowed-symbols 3R JM))
    (slot Tiempo 
        (type INTEGER))
    (slot EnProgreso 
        (type SYMBOL) 
        (allowed-symbols True False))
)

(defclass CASILLA (is-a USER)
    ; Activada: Dos definiciones distintas segun juego
    ; 1. En 3 en Raya, indicada si la casilla esta marcada, un no es que esta en blanco
    ; 2. En el juego de memoria, indica si la carta fue volteada
    (slot Activada 
        (type SYMBOL) 
        (allowed-symbols True False))
    ; Valor: X/O en 3eR, o un animal en JdM
    (slot Valor 
        (type SYMBOL) 
        (allowed-symbols X O Vacia Monkey Dog Cat Horse Shark Tiger Pig Dolphin Dragon Panda Bird Eagle))
    (slot x 
        (type INTEGER))
    (slot y 
        (type INTEGER))
)







