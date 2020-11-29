(defrule 
    (not (secondChance True))
    =>
    (printout t "no existe val1" crlf)
    (assert (val1 (read))
)

(defrule asd
    (test (or
            (?x <- (val1 ?ex))
            (not(val1 ?ex))
    ))
    =>
    (printout t "existe o no val1. Ingresa valor: " crlf)
    (retract ?x)
)