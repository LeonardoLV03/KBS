; Problema del mono y las bananas

(deftemplate estado
   (slot mono-en)
   (slot caja-en)
   (slot mono-sobre)
   (slot tiene-bananas)
)

(deftemplate paso-plan
   (slot paso)
)

(defglobal ?*loc-bananas* = medio)

; Estado inicial
(deffacts estado-inicial
   (estado (mono-en puerta)
         (caja-en ventana)
         (mono-sobre piso)
         (tiene-bananas no))
   (paso-plan (paso caminar-a-caja))
)

; El mono camina hasta donde está la caja
(defrule caminar-a-caja
   ?ps <- (paso-plan (paso caminar-a-caja))
   ?s <- (estado (mono-en ?m-loc) (caja-en ?c-loc) (mono-sobre piso))
   (test (not (eq ?m-loc ?c-loc)))
=>
   (printout t "El mono camina de la puerta a la ventana" crlf)
   (modify ?s (mono-en ?c-loc))
   (retract ?ps)
   (assert (paso-plan (paso empujar-caja)))
)

(defrule saltar-caminar
   ?ps <- (paso-plan (paso caminar-a-caja))
   (estado (mono-en ?loc) (caja-en ?loc) (mono-sobre piso))
=>
   (retract ?ps)
   (assert (paso-plan (paso empujar-caja)))
)

; Empuja la caja hasta las bananas
(defrule empujar-caja
   ?ps <- (paso-plan (paso empujar-caja))
   ?s <- (estado (mono-en ?loc1) (caja-en ?loc1) (mono-sobre piso))
   (test (not (eq ?loc1 ?*loc-bananas*)))
=>
   (printout t "El mono empuja la caja hacia en medio" crlf)
   (modify ?s (mono-en ?*loc-bananas*) (caja-en ?*loc-bananas*))
   (retract ?ps)
   (assert (paso-plan (paso subir-caja)))
)

(defrule saltar-empujar
   ?ps <- (paso-plan (paso empujar-caja))
   (estado (mono-en ?loc) (caja-en ?loc) (mono-sobre piso))
   (test (eq ?loc ?*loc-bananas*))
=>
   (retract ?ps)
   (assert (paso-plan (paso subir-caja)))
)

; Se sube a la caja
(defrule subir-caja
   ?ps <- (paso-plan (paso subir-caja))
   ?s <- (estado (mono-en ?loc) (caja-en ?loc) (mono-sobre piso))
   (test (eq ?loc ?*loc-bananas*))
=>
   (printout t "El mono se sube a la caja" crlf)
   (modify ?s (mono-sobre caja))
   (retract ?ps)
   (assert (paso-plan (paso agarrar-bananas)))
)

(defrule saltar-subir
   ?ps <- (paso-plan (paso subir-caja))
   (estado (mono-en ?loc) (caja-en ?loc) (mono-sobre caja))
   (test (eq ?loc ?*loc-bananas*))
=>
   (retract ?ps)
   (assert (paso-plan (paso agarrar-bananas)))
)

; Agarra las bananas
(defrule agarrar-bananas
   ?ps <- (paso-plan (paso agarrar-bananas))
   ?s <- (estado (mono-en ?loc) 
                 (caja-en ?loc) 
                 (mono-sobre caja) 
                 (tiene-bananas no))
   (test (eq ?loc ?*loc-bananas*))
=>
   (printout t "El mono agarra las bananas!" crlf)
   (modify ?s (tiene-bananas si))
   (retract ?ps)
   (assert (paso-plan (paso objetivo-logrado)))
)

(defrule objetivo-logrado
   ?ps <- (paso-plan (paso objetivo-logrado))
   (estado (tiene-bananas si))
=>
   (retract ?ps)
   (printout t crlf "Objetivo cumplido" crlf)
)