; =================== REGLAS GENERALES ==========================

; ---- Reglas Generales de Configuracion Inicial de la Sesion ----

;El usuario elige juego y personalidad del niño.
;La entrada se almancena en los hechos correspondientes
(defrule pickGameNPersonality
    ;Ejecutar cuando no existan estos hechos que representan las elecciones del niño/usuario
    (not(eleccion_usuario ?elec))
    (not(personalidad_usuario ?per))
    =>
    (printout t "Hola! Estas listo para jugar conmigo?" crlf)
    (printout t "Que quieres jugar hoy? Elige entre 3R (Para 3 en Raya) y JM (Para Juego de Memoria): " crlf)
    (assert (eleccion_usuario (read)))
    (printout t "Como es tu personalidad? (Neutro, Distraido, Impaciente): " crlf)
    (assert (personalidad_usuario (read)))
)

;Se genera la instancia de CONTROL a partir de la entrada del usuario
(defrule readGameNPersonality
    (eleccion_usuario ?elec)
    (personalidad_usuario ?per)

    ;Comprobar que las entradas del usuario sean correctas
    (test (and
            (or 
                (eq ?elec 3R) 
                (eq ?elec JM)) 
            (or 
                (or
                    (eq ?per Distraido)
                    (eq ?per Impaciente)) 
                (eq ?per Neutro)))
    )

    =>
    (make-instance of CONTROL (Eleccion ?elec) (Personalidad ?per) (Turno Robot))
    ;Hecho de control para el warning que se lanza antes de que el robot juegue
    (assert (warningBeforeDone False))
    ;Hechos de control para verificar que los jugadores ya han marcado casillas en su turno
    (assert (kidPlayed False))
    (assert (robotPlayed False))
    (printout t "Has elegido el juego: " ?elec " y por lo que me cuentan eres un chicx " ?per ". Dame un segundo para preparar todo!" crlf)
)

;Regla para evitar entradas no legales por parte del usuario y solicitar que introduzca sus opciones de nuevo
(defrule incorrectChoices
    ?e <- (eleccion_usuario ?elec)
    ?p <- (personalidad_usuario ?per)

    ;Si las entradas del usuario son incorrectass
    (not(test (and
            (or 
                (eq ?elec 3R) 
                (eq ?elec JM)) 
            (or 
                (or
                    (eq ?per Distraido)
                    (eq ?per Impaciente)) 
                (eq ?per Neutro)))
    ))

    =>
    (printout t "Las opciones que has elegido son incorrectas, por favor elige un juego entre 3R (Para 3 en Raya) o JM (Para el juego de memoria), y una personalidad entre Neutro, Distraido o Impaciente" crlf)
    ;Eliminar hechos de eleccion de juego y personalidad de la BH para que vuelvan a ser solicitados
    (retract ?e)
    (retract ?p)
)

; ----------- Reglas Generales de Control durante Sesion -------


;Reinicia hechos de warning, kidPlayed y robotPlayed a False, y va a la siguiente ronda tras terminar el turno del niño
(defrule changeRound
    ;Comprobar que sea el turno del niño
    ?con <- (object (is-a CONTROL) (Turno Kid) (Ronda ?ron))

    ;Verificar que ambos jugadores ya han tomado acciones en esta ronda
    ?kp <- (kidPlayed True)
    ?rp <- (robotPlayed True)

    ;Almacenar hecho warning de antes de que juegue el robot para modificaciones
    ?w <- (warningBeforeDone ?war)
    =>
    ;Da turno al robot, va a la siguiente ronda y resetea el atributo de segunda oportunidad
    (modify-instance ?con (Turno Robot) (Ronda (+ ?ron 1)) (SecondChance False))

    ;Cambio de ronda, indicar en la BH que ningun jugador ha tomado accion en esta ronda aun
    (retract ?kp)
    (retract ?rp)
    (assert (kidPlayed False))
    (assert (robotPlayed False))
    ;Indicar que no se ha hecho el warning que se lanza antes de que juegue el robot en esta ronda
    (retract ?w)
    (assert (warningBeforeDone False))
    
    (printout t "Cambio de ronda: " ?ron " a ronda: " (+ ?ron 1) crlf)
)

;Regla para efectuar cambio de turno de robot a niño
(defrule changeTurn
    ?con <- (object (is-a CONTROL) (Personalidad ?p) (Turno Robot))
    ;Se ejecuta cuando se indica en la BH que el el robot ya ha jugado
    ?rp <- (robotPlayed True)
    =>
    ;Cambiar la instancia de control indicando que es el turno del niño
    (modify-instance ?con (Turno Kid))
    ;Indicar que no se ha realizado el warning por motivos de tiempo
    (assert (timeWarningDone False))
    (printout t "Ya he terminado! Te toca jugar." crlf)
)

; --------- Reglas Generales de Interaccion Robot-Paciente -------

(defrule overTimeDistractedKid
    ;Se ejecuta cuando el niño tarda mas de 15 segundos en ingresar (x,y) y es de personalidad distraida
    ?con <- (object (is-a CONTROL) (Turno Kid) (Personalidad Distraido) (Cronometro ?c))
    (test (>= ?c 15))
    ;Se ejecuta luego de recibir input (x,y) del usuario
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ;Comprobar que en la BH se indica que no se ha realizado el warning por motivos de tiempo
    ?w <- (timeWarningDone False)
    =>
    ;No se vuelve a solicitar entrada, simplemente se avisa de que tardo mucho en decidir
    (printout t "Has tardado mucho tiempo en elegir! Tienes que concentrarte mejor." crlf)
    ;Indicar en la BH que ya se realizo el warning 
    (retract ?w)
    (assert (timeWarningDone True))
)

(defrule tooFastImpacientKid
    ;Se ejecuta cuando el niño tarda menos de 3 segundos en ingresar (x,y) y es de personalidad impaciente
    ?con <- (object (is-a CONTROL) (Turno Kid) (Personalidad Impaciente) (Cronometro ?c))
    (test (<= ?c 3))
    ;Se ejecuta luego de recibir input (x,y) del usuario
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ;Comprobar que en la BH se indica que no se ha realizado el warning por motivos de tiempo
    ?w <- (timeWarningDone False)
    =>
    ;No se vuelve a solicitar entrada, simplemente se avisa de que tardo mucho en decidir
    (printout t "Oye! Relaaajate. Has elegido muy rapido! Se que eres muy avispadx, pero trata de disfrutar este tiempo de juego y piensa bien tus jugadas." crlf)
    ;Indicar en la BH que ya se realizo el warning 
    (retract ?w)
    (assert (timeWarningDone True))
)

;Las reglas siguientes se ejecutan antes de que el robot tome accion
(defrule warningBeforeTurn_Impacient
    ;Turno del robot
    ?con <- (object (is-a CONTROL) (Personalidad Impaciente) (Turno Robot) (Ronda ?ron))
    ;Comprueba que no se ha realizado el aviso correspondiente en esta ronda
    ?w <- (warningBeforeDone False)
    (test (> ?ron 0))
    => 
    (printout t "No seas impaciente, espera a que yo mueva primero!" crlf)
    ;Indica en la BH que ya se realizó el aviso
    (retract ?w)
    (assert (warningBeforeDone True))
)

(defrule warningBeforeTurn_Distracted
    ?con <- (object (is-a CONTROL) (Personalidad Distraido) (Turno Robot) (Ronda ?ron))
    ?w <- (warningBeforeDone False)
    (test (> ?ron 0))
    =>
    (printout t "Recuerda que despues de mi turno te toca a ti!" crlf)
    (retract ?w)
    (assert (warningBeforeDone True))
)

; ===================== REGLAS TRES EN RAYA ====================

;Primera regla que se ejecuta cuando el juego elegido es el Tres en Raya. 
;Inicializa el tablero para llevar a cabo el juego
(defrule initBoard3R
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Ronda 0))
    =>
    (make-instance of CASILLA (x 1) (y 1))
    (make-instance of CASILLA (x 2) (y 1))
    (make-instance of CASILLA (x 3) (y 1))
    (make-instance of CASILLA (x 1) (y 2))
    (make-instance of CASILLA (x 2) (y 2))
    (make-instance of CASILLA (x 3) (y 2))
    (make-instance of CASILLA (x 1) (y 3))
    (make-instance of CASILLA (x 2) (y 3))
    (make-instance of CASILLA (x 3) (y 3))
    (modify-instance ?con (Ronda 1))
    (printout t "El tablero esta listo, empezamos el juego de Tres en Raya!" crlf)
)

(defrule CondicionVictoria_3R
    ;Esta regla se tiene que ejecutar antes que cualquier otra
    (declare (salience 100))
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno ?turn) (Ronda ?ron))

    ;Hechos de control para verificar que los jugadores ya han marcado casillas en su turno
    ?kp <- (kidPlayed ?kid)
    ?rp <- (robotPlayed ?robot)
    
    (test(or
            ;Si es el turno del robot que el robot ya haya marcado en esta ronda
            (and (eq ?turn Robot) (eq ?robot True))
            ;Si es el turno del niño que el niño ya haya marcado en esta ronda
            (and (eq ?turn Kid) (eq ?kid True)))
    )

    ;Leer tablero entero
    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (Valor ?va1) (Activada ?a1))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (Valor ?va2) (Activada ?a2))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (Valor ?va3) (Activada ?a3))
    ?cas4 <- (object (is-a CASILLA) (x 1) (y 2) (Valor ?va4) (Activada ?a4))
    ?cas5 <- (object (is-a CASILLA) (x 2) (y 2) (Valor ?va5) (Activada ?a5))
    ?cas6 <- (object (is-a CASILLA) (x 3) (y 2) (Valor ?va6) (Activada ?a6))
    ?cas7 <- (object (is-a CASILLA) (x 1) (y 3) (Valor ?va7) (Activada ?a7))
    ?cas8 <- (object (is-a CASILLA) (x 2) (y 3) (Valor ?va8) (Activada ?a8))
    ?cas9 <- (object (is-a CASILLA) (x 3) (y 3) (Valor ?va9) (Activada ?a9))

    ;Se ejecuta si 3 casillas en raya NO VACIAS (Activada = True) tienen el mismo valor
    (test (or 
            (or 
                (or 
                    (or 
                        (or
                            (or 
                                (or 
                                    (and (eq ?va7 ?va5 ?va3) (eq ?a7 ?a5 ?a3 True))
                                    (and (eq ?va7 ?va8 ?va9) (eq ?a7 ?a8 ?a9 True)))
                                (and (eq ?va4 ?va5 ?va6) (eq ?a4 ?a5 ?a6 True)))
                            (and (eq ?va3 ?va6 ?va9) (eq ?a3 ?a6 ?a9 True)))
                        (and (eq ?va2 ?va5 ?va8) (eq ?a2 ?a5 ?a8 True)))
                    (and (eq ?va1 ?va5 ?va9) (eq ?a1 ?a5 ?a9 True)))
                (and (eq ?va1 ?va4 ?va7) (eq ?a1 ?a4 ?a7 True)))
            (and (eq ?va1 ?va2 ?va3) (eq ?a1 ?a2 ?a3 True)))
    )
    =>
    ;Indicar en la BH el ganador de la partida
    (assert (winner ?turn))
    ;Eliminar instancia de control para que no se ejecuten otras reglas del juego
    (unmake-instance ?con)
)

; --------- Estrategias del Robot en 3 en Raya ----------------

;Estrategia Robot en Ronda 1
(defrule JuegaRobot_3R_Ronda1
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad ?p) (Turno Robot) (Ronda 1))
    ?cas <- (object (is-a CASILLA) (x 1) (y 1) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))

    ?rp <- (robotPlayed False)
    =>
    ;Marcar casilla (1,1)
    (modify-instance ?cas (Valor X) (Activada True))
    ;Eliminar de la BH el hecho que indica que el robot no ha jugado esta ronda
    (retract ?rp)
    ;Indicar en la BH que el robot ya jugo en esta ronda
    (assert (robotPlayed True))
    (printout t "Robot marca X en casilla (" 1 "," 1 ")" crlf)
)

;Estrategia Robot en Ronda 2
(defrule JuegaRobot_3R_Ronda2
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad ?p) (Turno Robot) (Ronda 2))
    ;Si el niño todavia no ha colocado una O en la casilla del medio (2,2).. 
    ?cas22 <- (object (is-a CASILLA) (x 2) (y 2) (Activada False))
    ;..ver si la casilla (1,3) esta vacia
    ?cas <- (object (is-a CASILLA) (x 1) (y 3) (Activada False))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))

    ?rp <- (robotPlayed False)
    =>
    ;Marcar casilla (1,3)
    (modify-instance ?cas (Valor X) (Activada True))
    ;Eliminar de la BH el hecho que indica que el robot no ha jugado esta ronda
    (retract ?rp)
    ;Indicar en la BH que el robot ya jugo en esta ronda
    (assert (robotPlayed True))
    (printout t "Robot marca X en casilla (" 1 "," 3 ")" crlf)
)

;Estrategia Robot en Ronda 3 o más, o si en la ronda 2 esta ocupada la casilla (2,2)
(defrule JuegaRobot_3R_RRondas
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Personalidad ?p) (Turno Robot) (Ronda ?ron))
    ;Elige una casilla al azar
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada False))
    ;La regla se ejecuta si ronda > 2 OR, si la casilla (2,2) o la (1,3) esta activada (ocupada)
    ?casM <- (object (is-a CASILLA) (x 2) (y 2) (Activada ?a22))
    ?cas13 <- (object (is-a CASILLA) (x 1) (y 3) (Activada ?a13))

    (test (or 
            (> ?ron 2)
            (or
                (eq ?a13 True) 
                (eq ?a22 True)))
    )
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))

    ;Verificar que el robot no haya jugado aun en esta ronda
    ?rp <- (robotPlayed False)
    =>
    ;Marcar casilla elegida al azar
    (modify-instance ?cas (Valor X) (Activada True))
    ;Eliminar de la BH el hecho que indica que el robot no ha jugado esta ronda
    (retract ?rp)
    ;Indicar en la BH que el robot ya jugo en esta ronda
    (assert (robotPlayed True))
    (printout t "Robot marca X en casilla (" ?x "," ?y ")" crlf)
)

; --------------- Reglas de Input del Usuario para 3 en Raya -----------------

; Regla para leer el input del niño
(defrule inputKid_3R
    ;Cuando es el turno del niño..
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid) (Cronometro ?c))
    ; y no ha elegido x e y...
    (not(xKid ?x))
    (not(yKid ?y))

    ;El niño no ha jugado en esta ronda
    (kidPlayed False)
    =>
    ;...pedirle que introduzca x, y, y el tiempo que tarda en responder (sensor del robot)
    (printout t "Ingresa x: " crlf)
    (assert (xKid (read)))
    (printout t "Ingresa y: " crlf)
    (assert (yKid (read)))
    (printout t "Ingresa el tiempo tomado (en segundos):" crlf)
    (modify-instance ?con (Cronometro (read)))
)

(defrule juegaKid_3R
    ;Turno del niño
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid) (Ronda ?r) (Cronometro ?c) (Personalidad ?p))
    ;El niño ha elegido (x,y) validas (dentro del rango y vacia (no activada))
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada False))
    ;El niño no ha jugado en esta ronda
    ?kp <- (kidPlayed False)

    ?tw <- (timeWarningDone ?war)

    ;Se ejecutara la regla cuando:
    (test (or
            (or
                (or
                    ;O bien, el niño es distraido pero tomo una decision en menos de 15 segundos
                    (and (eq ?p Distraido) (< ?c 15))
                    ;O bien, el niño es impaciente pero penso durante mas de 3 segundos para tomar su decision
                    (and (eq ?p Impaciente) (> ?c 3)))
                ; O bien, el warning por motivos de tiempo ya se ha hecho
                (eq ?war True))
            ;O bien, el niño es de personalidad Neutro, por lo que no se necesita hacer un warning por motivos de tiempo
            (eq ?p Neutro))
    )
    =>
    ;Marca la casilla (x,y)
    (modify-instance ?cas (Valor O) (Activada True))
    ;Indica en la BH que el niño ya jugo en esta ronda
    (retract ?kp)
    (assert (kidPlayed True))

    ;Borra hechos de entrada del niño (x,y) para que se vuelvan a solicitar en la ronda siguiente
    (retract ?xkid)
    (retract ?ykid)

    ;Eliminar de la BH el hecho del warning por motivos de tiempo, pues se reseteara al cambiar el turno al niño en la proxima ronda
    (retract ?tw)

    (printout t "Has marcado la casilla (" ?x "," ?y ") correctamente!" crlf) 
)

; ------------------ Reglas para interaccion Robot-Paciente en 3R --------------------

;Indica que la casilla esta fuera de rango y elimina la entrada del usurio para obligarle a ingresar un nuevo par (x,y)
(defrule corregirCasillaOutOfBounds_3R
    ;Se corrige al recibir input (x,y) del usuario
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid))
    
    ;Ejecutar regla si no se cumple que: x,y <= 3 AND x,y >= 1
    (not(test (and
                (and (>= ?x 1) (<= ?x 3))
                (and (>= ?y 1) (<= ?y 3)))
    ))

    ;Almacenar hecho en variable para borrarlo luego
    ?tw <- (timeWarningDone ?war)

    =>
    (printout t "Accion incorrecta! La casilla que has elegido esta fuera de rango." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
    ;Como se va a solicitar de nuevo una entrada, indicar que el warning por motivos de tiempo no se ha realizado
    (retract ?tw)
    (assert (timeWarningDone False))
)

;Indica que la casilla (x,y) elegida esta ocupada y elimina entrada del usuario para que ingrese un nuevo par (x,y)
(defrule corregirCasillaOcupada_3R
    ?con <- (object (is-a CONTROL) (Eleccion 3R) (Turno Kid))
    ;Se corrige al recibir input (x,y) del usuario
    ?xkid <- (xKid ?x)
    ?ykid <- (yKid ?y)
    ;Ejecutar regla cuando casilla (x,y) Activada (ocupada) 
    ?cas <- (object (is-a CASILLA) (x ?x) (y ?y) (Activada True))

    ;Almacenar hecho en variable para borrarlo luego
    ?tw <- (timeWarningDone ?war)
    =>
    (printout t "Accion incorrecta! La casilla que has elegido esta ocupada." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
    ;Como se va a solicitar de nuevo una entrada, indicar que el warning por motivos de tiempo no se ha realizado
    (retract ?tw)
    (assert (timeWarningDone False))
)

;Regla para dar recomendaciones a un niño distraido cuando pierde en 3R
(defrule winner3RRobot_DistractedKid
    (winner Robot)
    (personalidad_usuario Distraido)
    =>
    (printout t "Lo has hecho genial! Pero puedes hacerlo mejor si te enfocas mas en el juego. Seguro que la proxima me ganas" crlf)
    (printout t "Vuelve a activarme cuando quieras intentarlo de nuevo. Adios!")
    (halt)
)
;Regla para dar recomendaciones a un niño impaciente cuando pierde en 3R
(defrule winner3RRobot_ImpacienteKid
    (winner Robot)
    (personalidad_usuario Impaciente)
    =>
    (printout t "Buen trabajo! Solo necesitas tener un poco mas de paciencia y pensar con mas calma. Seguro que la proxima me ganas" crlf)
    (printout t "Vuelve a activarme cuando quieras intentarlo de nuevo. Adios!")
    (halt)
)
;Regla para felicitar a un niño cuando gana en 3R
(defrule winner3RKid
    (winner Kid)
    (personalidad_usuario ?p)
    =>
    (printout t "FELICIDADES! Has ganado! Parece que ya eres un poco menos " ?p ", que antes. Sigue asi!" crlf)
    (printout t "Vuelve a activarme cuando quieras seguir mejorando. Adios!")
    (halt)
)

; ===================== REGLAS JUEGO DE MEMORIA ====================

;Primera regla que se ejecuta cuando el juego elegido es el Juego de Memoria. 
;Inicializa el tablero para llevar a cabo el juego
(defrule initBoardJM
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Ronda 0))
    =>
    (make-instance of CASILLA (x 1) (y 1) (Valor Monkey) (Activada False))
    (make-instance of CASILLA (x 2) (y 1) (Valor Dog) (Activada False))
    (make-instance of CASILLA (x 3) (y 1) (Valor Cat) (Activada False))
    (make-instance of CASILLA (x 4) (y 1) (Valor Horse) (Activada False))
    (make-instance of CASILLA (x 5) (y 1) (Valor Shark) (Activada False))
    (make-instance of CASILLA (x 6) (y 1) (Valor Tiger) (Activada False))
    (make-instance of CASILLA (x 7) (y 1) (Valor Pig) (Activada False))
    (make-instance of CASILLA (x 8) (y 1) (Valor Dolphin) (Activada False))
    (make-instance of CASILLA (x 9) (y 1) (Valor Dragon) (Activada False))
    (make-instance of CASILLA (x 10) (y 1) (Valor Panda) (Activada False))
    (make-instance of CASILLA (x 11) (y 1) (Valor Bird) (Activada False))
    (make-instance of CASILLA (x 12) (y 1) (Valor Eagle) (Activada False))
    (make-instance of CASILLA (x 13) (y 1) (Valor Eagle) (Activada False))
    (make-instance of CASILLA (x 14) (y 1) (Valor Bird) (Activada False))
    (make-instance of CASILLA (x 15) (y 1) (Valor Panda) (Activada False))
    (make-instance of CASILLA (x 16) (y 1) (Valor Dragon) (Activada False))
    (make-instance of CASILLA (x 17) (y 1) (Valor Dolphin) (Activada False))
    (make-instance of CASILLA (x 18) (y 1) (Valor Pig) (Activada False))
    (make-instance of CASILLA (x 19) (y 1) (Valor Tiger) (Activada False))
    (make-instance of CASILLA (x 20) (y 1) (Valor Shark) (Activada False))
    (make-instance of CASILLA (x 21) (y 1) (Valor Horse) (Activada False))
    (make-instance of CASILLA (x 22) (y 1) (Valor Cat) (Activada False))
    (make-instance of CASILLA (x 23) (y 1) (Valor Dog) (Activada False))
    (make-instance of CASILLA (x 24) (y 1) (Valor Monkey) (Activada False))
    (modify-instance ?con (Ronda 1))
    (printout t "El tablero esta listo, empezamos el juego de memoria!" crlf)
)


(defrule CondicionVictoria_JM

    ;Esta regla se tiene que ejecutar antes que cualquier otra
    (declare (salience 100))
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno ?turn) (Ronda ?ron))
    

    ;Hechos de control para verificar que los jugadores ya han marcado casillas en su turno
    ?kp <- (kidPlayed ?kid)
    ?rp <- (robotPlayed ?robot)

    (test(or
            ;Si es el turno del robot que el robot ya haya marcado en esta ronda
            (and (eq ?turn Robot) (eq ?robot True))
            ;Si es el turno del niño que el niño ya haya marcado en esta ronda
            (and (eq ?turn Kid) (eq ?kid True))
         )
    )

    ?cas1 <- (object (is-a CASILLA) (x 1) (y 1) (Activada True))
    ?cas2 <- (object (is-a CASILLA) (x 2) (y 1) (Activada True))
    ?cas3 <- (object (is-a CASILLA) (x 3) (y 1) (Activada True))
    ?cas4 <- (object (is-a CASILLA) (x 4) (y 1) (Activada True))
    ?cas5 <- (object (is-a CASILLA) (x 5) (y 1) (Activada True))
    ?cas6 <- (object (is-a CASILLA) (x 6) (y 1) (Activada True))
    ?cas7 <- (object (is-a CASILLA) (x 7) (y 1) (Activada True))
    ?cas8 <- (object (is-a CASILLA) (x 8) (y 1) (Activada True))
    ?cas9 <- (object (is-a CASILLA) (x 9) (y 1) (Activada True))
    ?cas10 <- (object (is-a CASILLA) (x 10) (y 1) (Activada True))
    ?cas11 <- (object (is-a CASILLA) (x 11) (y 1) (Activada True))
    ?cas12 <- (object (is-a CASILLA) (x 12) (y 1) (Activada True))
    ?cas13 <- (object (is-a CASILLA) (x 13) (y 1) (Activada True))
    ?cas14 <- (object (is-a CASILLA) (x 14) (y 1) (Activada True))
    ?cas15 <- (object (is-a CASILLA) (x 15) (y 1) (Activada True))
    ?cas16 <- (object (is-a CASILLA) (x 16) (y 1) (Activada True))
    ?cas17 <- (object (is-a CASILLA) (x 17) (y 1) (Activada True))
    ?cas18 <- (object (is-a CASILLA) (x 18) (y 1) (Activada True))
    ?cas19 <- (object (is-a CASILLA) (x 19) (y 1) (Activada True))
    ?cas20 <- (object (is-a CASILLA) (x 20) (y 1) (Activada True))
    ?cas21 <- (object (is-a CASILLA) (x 21) (y 1) (Activada True))
    ?cas22 <- (object (is-a CASILLA) (x 22) (y 1) (Activada True))
    ?cas23 <- (object (is-a CASILLA) (x 23) (y 1) (Activada True))
    ?cas24 <- (object (is-a CASILLA) (x 24) (y 1) (Activada True))
    =>
    (printout t "Felicidades! Hemos ganado el juego en: " ?ron " rondas! Buen trabajo!" crlf)
    (halt)
)

; --------- Estrategias del Robot en Juego de Memoria ----------------


;Estrategia Robot en todas las rondas.
(defrule JuegaRobot_JM_Rondas
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Personalidad ?p) (Turno Robot))

    ?cas1 <- (object (is-a CASILLA) (x ?x1) (Valor ?val1) (Activada False))
    ?cas2 <- (object (is-a CASILLA) (x ?x2) (Valor ?val1) (Activada False))
    (not(test (= ?x1 ?x2)))
    ;Se ejecuta la accion del robot una vez ha hecho el aviso al niño según su personalidad, o si la personalidad es neutra
    ?w <- (warningBeforeDone ?war)
    (test (or (eq ?p Neutro)
              (eq ?war True)))

    ?rp <- (robotPlayed False)
    =>
    ;Marcar las cartas como volteadas (activadas)
    (modify-instance ?cas1 (Activada True))
    (modify-instance ?cas2 (Activada True))
    ;Eliminar de la BH el hecho que indica que el robot no ha jugado esta ronda
    (retract ?rp)
    ;Indicar en la BH que el robot ya jugo en esta ronda
    (assert (robotPlayed True))
    (printout t "He volteado las cartas: " ?x1 " y " ?x2 ", y he acertado! Ambas eran: " ?val1 crlf)
)

; --------------- Reglas de Input del Usuario para Juego de Memoria -----------------


; Regla para leer el input del niño
; Regla reutilizable
(defrule inputKid_JM
    ;Cuando es el turno del niño..
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Cronometro ?c))
    ;..no ha elegido cartas x e y
    (not(xKid ?x))
    (not(yKid ?y))
    ;..y el niño no ha jugado en esta ronda
    (kidPlayed False)
    =>
    ;...pedirle que introduzca x, y,  y el tiempo que tarda en responder (sensor del robot)
    (printout t "Ingresa la primera carta: " crlf)
    (assert (xKid (read)))
    (printout t "Ingresa la segunda carta: " crlf)
    (assert (yKid (read)))
    (printout t "Ingresa el tiempo tomado (en segundos):" crlf)
    (modify-instance ?con (Cronometro (read)))
)


(defrule juegaKid_JM
    ;Turno del niño
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Ronda ?r) (Personalidad ?p) (Cronometro ?c))
    ;Se ejecuta cuando las cartas seleccionadas (x e y) tienen el mismo valor, no se han volteado (activado) aun..
    ?xkid <- (xKid ?carta1)
    ?ykid <- (yKid ?carta2)
    ?cas1 <- (object (is-a CASILLA) (Valor ?val1) (x ?carta1) (Activada False))
    ?cas2 <- (object (is-a CASILLA) (Valor ?val1) (x ?carta2) (Activada False))
    ;..y son distintas
    (not (test (= ?carta1 ?carta2)))


    ;El niño no ha jugado en esta ronda
    ?kp <- (kidPlayed False)

    ?tw <- (timeWarningDone ?war)

    ;Se ejecutara la regla cuando:
    (test (or
            (or
                (or
                    ;O bien, el niño es distraido pero tomo una decision en menos de 15 segundos
                    (and (eq ?p Distraido) (< ?c 15))
                    ;O bien, el niño es impaciente pero penso durante mas de 3 segundos para tomar su decision
                    (and (eq ?p Impaciente) (> ?c 3)))
                ; O bien, el warning por motivos de tiempo ya se ha hecho
                (eq ?war True))
            ;O bien, el niño es de personalidad Neutro, por lo que no se necesita hacer un warning por motivos de tiempo
            (eq ?p Neutro))
    )

    =>
    ;Borra hechos de entrada (x e y) para que se vuelvan a solicitar en la ronda siguiente
    (retract ?xkid)
    (retract ?ykid)
    ;Voltea (Activa) las cartas
    (modify-instance ?cas1 (Activada True))
    (modify-instance ?cas2 (Activada True))
    ;Indica en la BH que el niño ya jugo en esta ronda
    (retract ?kp)
    (assert (kidPlayed True))
    ;Borrar de la BH el hecho de el warning por motivos de tiempo pues se reseteara al cambiar de turno al niño en la siguiente ronda
    (retract ?tw)

    (printout t "Has volteado las cartas: " ?carta1 " y " ?carta2 ", y has acertado! Ambas eran: " ?val1 crlf)
)


; ------------------ Reglas para interaccion Robot-Paciente en JM --------------------

;Indica que la casilla esta fuera de rango y elimina la entrada del usurio para obligarle a ingresar una nueva (x)
(defrule corregirCasillaOutOfBounds_JM
    ;Se corrige al recibir input (x) del usuario
    ?xkid <- (xKid ?carta1)
    ?ykid <- (yKid ?carta2)
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid))
    
    ;Ejecutar regla si carta1,carta2 < 1 OR carta1,carta2 > 24
    (test (or
            (or (> ?carta1 24) (< ?carta1 1)) 
            (or (> ?carta2 24) (< ?carta2 1)))
    )

    ;Almacenar hecho en variable para borrarlo luego
    ?tw <- (timeWarningDone ?war)
    =>
    (printout t "Accion incorrecta! La carta que has elegido esta fuera de rango." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
    ;Como se va a solicitar de nuevo una entrada, indicar que el warning por motivos de tiempo no se ha realizado
    (retract ?tw)
    (assert (timeWarningDone False))
)


;Indica que alguna carta elegida (xkid o ykid) esta ya levantada y elimina entrada del usuario para que ingrese un nuevo par de cartas
(defrule corregirCasillaOcupada_JM
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid))
    ;Se corrige al recibir input (x1,x2) del usuario
    ?xkid <- (xKid ?carta1)
    ?ykid <- (yKid ?carta2)
    ;Ejecutar regla cuando carta1 o carta2 esta Activada (volteada)
    ?cas1 <- (object (is-a CASILLA) (x ?carta1) (Activada ?a1))
    ?cas2 <- (object (is-a CASILLA) (x ?carta2) (Activada ?a2))

    (test(or
            (eq ?a1 True)
            (eq ?a2 True))
    )

    ;Almacenar hecho en variable para borrarlo luego
    ?tw <- (timeWarningDone ?war)
    =>
    (printout t "Accion incorrecta! Alguna de las cartas que has elegido ya estan volteadas." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
    ;Como se va a solicitar de nuevo una entrada, indicar que el warning por motivos de tiempo no se ha realizado
    (retract ?tw)
    (assert (timeWarningDone False))
)

(defrule corregirCasillaIgual_JM_Distraido
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Personalidad Distraido))
    ;Se corrige al recibir input (x1,x2) del usuario
    ?xkid <- (xKid ?carta1)
    ?ykid <- (yKid ?carta2)
    ;Ejecutar regla cuando carta1 o carta2 esta Activada (volteada)
    ?cas1 <- (object (is-a CASILLA) (x ?carta1) (Activada ?a1))
    ?cas2 <- (object (is-a CASILLA) (x ?carta2) (Activada ?a2))

    (test(= ?carta1 ?carta2))

    ;Almacenar hecho en variable para borrarlo luego
    ?tw <- (timeWarningDone ?war)
    =>
    (printout t "Cuidado! Has elegido la misma carta! Recuerda que nuestro objetivo es voltear pares de cartas distintas pero con el mismo animal! Intenta de nuevo." crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
    ;Como se va a solicitar de nuevo una entrada, indicar que el warning por motivos de tiempo no se ha realizado
    (retract ?tw)
    (assert (timeWarningDone False))
)

(defrule corregirCasillaIgual_JM_Impaciente
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Personalidad Impaciente))
    ;Se corrige al recibir input (x1,x2) del usuario
    ?xkid <- (xKid ?carta1)
    ?ykid <- (yKid ?carta2)
    ;Ejecutar regla cuando carta1 o carta2 esta Activada (volteada)
    ?cas1 <- (object (is-a CASILLA) (x ?carta1) (Activada ?a1))
    ?cas2 <- (object (is-a CASILLA) (x ?carta2) (Activada ?a2))

    (test(= ?carta1 ?carta2))

    ;Almacenar hecho en variable para borrarlo luego
    ?tw <- (timeWarningDone ?war)
    =>
    (printout t "Oye! No tan rapido, has escogido dos cartas iguales. Tómate tu tiempo, haz memoria y elige dos cartas distintas" crlf)
    ;Eliminar de la BH los hechos xkid e ykid para que el usuario vuelva a introducir x e y
    (retract ?xkid)
    (retract ?ykid)
    ;Como se va a solicitar de nuevo una entrada, indicar que el warning por motivos de tiempo no se ha realizado
    (retract ?tw)
    (assert (timeWarningDone False))
)

(defrule secondChance_JM_Distraido
    ;Turno del niño, juego JM, niño distraido, y no ha dado segunda oportunidad en esta ronda
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Personalidad Distraido) (Ronda ?r) (SecondChance False))
    ;Se ejecuta cuando las cartas seleccionadas (x e y) NO tienen el mismo valor, no se han volteado (activado) aun..
    ?xkid <- (xKid ?carta1)
    ?ykid <- (yKid ?carta2)
    ?cas1 <- (object (is-a CASILLA) (Valor ?val1) (x ?carta1) (Activada False))
    ?cas2 <- (object (is-a CASILLA) (Valor ?val2) (x ?carta2) (Activada False))
    (not(test (eq ?val1 ?val2)))
    ;..y son distintas
    (not (test (= ?carta1 ?carta2)))

    ;El niño no ha jugado en esta ronda
    ?kp <- (kidPlayed False)
    ;Almacenar hecho en variable para borrarlo luego
    ?tw <- (timeWarningDone ?war)
    =>

    (printout t "Ohh vaya! Has volteado las cartas: " ?carta1 " y " ?carta2 ", pero no has acertado. Las cartas eran: " ?val1 " y " ?val2 crlf)
    (printout t "No pasa nada, te dejo que lo intentes una vez más. Trata de enforcarte y hacer memoria!")
    ;Borra hechos de entrada (x e y) para que se vuelvan a solicitar
    (retract ?xkid)
    (retract ?ykid)
    ;Se deja saber en la BH que ya se dio una segunda oportunidad para que no se vuelva a dar
    (modify-instance ?con (SecondChance True))
    ;Como se va a solicitar de nuevo una entrada, indicar que el warning por motivos de tiempo no se ha realizado
    (retract ?tw)
    (assert (timeWarningDone False))
)

(defrule cardsNotEqual_JM_Distraido
    ;Turno del niño, juego JM, niño distraido, y YA SE DIO segunda oportunidad en esta ronda
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Personalidad Distraido) (Ronda ?r) (SecondChance True))
    ;Se ejecuta cuando las cartas seleccionadas (x e y) NO tienen el mismo valor, no se han volteado (activado) aun..
    ?xkid <- (xKid ?carta1)
    ?ykid <- (yKid ?carta2)
    ?cas1 <- (object (is-a CASILLA) (Valor ?val1) (x ?carta1) (Activada False))
    ?cas2 <- (object (is-a CASILLA) (Valor ?val2) (x ?carta2) (Activada False))
    (not(test (eq ?val1 ?val2)))
    ;..y son distintas
    (not (test (= ?carta1 ?carta2)))

    ;El niño no ha jugado en esta ronda
    ?kp <- (kidPlayed False)
    =>
    ;
    (printout t "Vaya! Has vuelto a fallar. Has volteado 2 cartas con valores: " ?val1 " y " ?val2 crlf) 
    (printout t "No pasa nada, trata de memorizar las cartas que has volteado y seguro que la proxima lo lograras!" crlf)
    ;Se vuelve a equivocar, pero como ya se dio una segunda oportunidad, simplemente indica que ya el niño jugo
    (retract ?kp)
    (assert (kidPlayed True))
    ;Se eliminan las cartas introducidas de la BH para que se solicite de nuevo en la siguiente ronda
    (retract ?xkid)
    (retract ?ykid)
)

(defrule cardsNotEqual_JM_Impaciente
    ;Turno del niño, juego JM y niño impacinete
    ?con <- (object (is-a CONTROL) (Eleccion JM) (Turno Kid) (Personalidad Impaciente) (Ronda ?r))
    ;Se ejecuta cuando las cartas seleccionadas (x e y) NO tienen el mismo valor, no se han volteado (activado) aun..
    ?xkid <- (xKid ?carta1)
    ?ykid <- (yKid ?carta2)
    ?cas1 <- (object (is-a CASILLA) (Valor ?val1) (x ?carta1) (Activada False))
    ?cas2 <- (object (is-a CASILLA) (Valor ?val2) (x ?carta2) (Activada False))
    (not(test (eq ?val1 ?val2)))
    ;..y son distintas
    (not (test (= ?carta1 ?carta2)))

    ;El niño no ha jugado en esta ronda
    ?kp <- (kidPlayed False)
    =>
    ;
    (printout t "Rayos! No has acertado. Quiza podrias intentar tomarte un poco mas de tiempo para pensar en tu proximo turno." crlf)
    ;Se vuelve a equivocar, pero como ya se dio una segunda oportunidad, simplemente indica que ya el niño jugo
    (retract ?kp)
    (assert (kidPlayed True))
    ;Se eliminan las cartas introducidas de la BH para que se solicite de nuevo en la siguiente ronda
    (retract ?xkid)
    (retract ?ykid)
)
