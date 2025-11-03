;; rules.clp
;; Motor de inferencia con 21 reglas

;; Regla de inicio
(defrule regla-bienvenida
    (declare (salience 100))
    ?f <- (initial-fact)
    =>
    (retract ?f)
    (assert (proceso-iniciado))
    (printout t ">>> Iniciando motor de reglas para nueva orden..." crlf crlf)
)

;; Validar si la tarjeta está vencida
(defrule error-tarjeta-vencida
    (declare (salience 20)) 
    ?o <- (orden (metodo-pago credito) (tarjeta-id ?tid))
    (tarjeta-credito (id ?tid) (exp-date ?exp))
    (test (< (str-compare (str-cat (sub-string 4 5 ?exp) "-" (sub-string 1 2 ?exp)) "25-11") 0))
    =>
    (retract ?o) 
    (printout t "!!! ERROR DE PAGO !!!" crlf)
    (printout t "   -> La tarjeta " ?tid " esta VENCIDA (Fecha exp: " ?exp "). Orden cancelada." crlf crlf)
)

;; Procesar orden con tarjeta de crédito
(defrule pre-procesar-orden-CREDITO
    (declare (salience 10))
    ?o <- (orden (marca ?m) (modelo ?mod) (qty ?q) (metodo-pago credito) (tarjeta-id ?tid))
    ?p <- (producto (marca ?m) (modelo ?mod) (categoria ?cat) (precio ?pr) (stock ?s&:(>= ?s ?q)))
    (tarjeta-credito (id ?tid) (banco ?banco)) 
    =>
    (retract ?o) 
    (modify ?p (stock (- ?s ?q)))
    (printout t "--- Actualizacion de Stock ---" crlf)
    (printout t "   -> Pedido: " ?q " " ?mod ". Stock restante: " (- ?s ?q) crlf crlf)
    (assert (orden-procesando (marca ?m) (modelo ?mod) (categoria ?cat) (qty ?q) 
                             (metodo-pago credito) (banco-tarjeta ?banco) 
                             (precio-total (* ?q ?pr))))
)

;; Procesar orden pagada de contado
(defrule pre-procesar-orden-CONTADO
    (declare (salience 10))
    ?o <- (orden (marca ?m) (modelo ?mod) (qty ?q) (metodo-pago contado) (tarjeta-id nil))
    ?p <- (producto (marca ?m) (modelo ?mod) (categoria ?cat) (precio ?pr) (stock ?s&:(>= ?s ?q)))
    =>
    (retract ?o) 
    (modify ?p (stock (- ?s ?q)))
    (printout t "--- Actualizacion de Stock ---" crlf)
    (printout t "   -> Pedido: " ?q " " ?mod ". Stock restante: " (- ?s ?q) crlf crlf)
    (assert (orden-procesando (marca ?m) (modelo ?mod) (categoria ?cat) (qty ?q) 
                             (metodo-pago contado) (banco-tarjeta nil) 
                             (precio-total (* ?q ?pr))))
)

;; Checar que haya suficiente stock
(defrule error-stock-insuficiente
    (declare (salience 10)) 
    ?o <- (orden (marca ?m) (modelo ?mod) (qty ?q))
    (producto (marca ?m) (modelo ?mod) (stock ?s&:(< ?s ?q)))
    =>
    (retract ?o) 
    (printout t "!!! ERROR DE ORDEN !!!" crlf)
    (printout t "   -> No hay stock suficiente para " ?q " " ?mod "." crlf)
    (printout t "   -> Stock disponible: " ?s crlf crlf)
)

;; Avisar cuando el stock esté bajo
(defrule detectar-stock-bajo
    (declare (salience 5))
    (producto (modelo ?mod) (stock ?s&:(< ?s 10) &:(> ?s 0)))
    (not (alerta-stock (descripcion ?d&:(str-index ?mod ?d))))
    =>
    (assert (alerta-stock (descripcion (str-cat "ALERTA: Stock bajo para " ?mod " (Quedan: " ?s ")"))))
)

;; Cliente que compra más de 10 unidades es mayorista
(defrule clasificar-cliente-mayorista
    (orden-procesando (qty ?q&:(> ?q 10)))
    (not (clasificacion-cliente (tipo Mayorista))) 
    =>
    (assert (clasificacion-cliente (tipo Mayorista)))
)

;; Cliente que compra 10 o menos es menudista
(defrule clasificar-cliente-menudista
    (orden-procesando (qty ?q&:(<= ?q 10)))
    (not (clasificacion-cliente (tipo Menudista)))
    =>
    (assert (clasificacion-cliente (tipo Menudista)))
)

;; Aplicar meses sin intereses según promo del banco
(defrule aplicar-msi
    (orden-procesando (marca ?m) (modelo ?mod) (metodo-pago credito) (banco-tarjeta ?b))
    (promo-banco (banco ?b) (marca ?m) (modelo ?mod) (meses-sin-interes ?msi))
    =>
    (assert (oferta-aplicada (descripcion (str-cat "Aplica " ?msi " MSI en " ?m " " ?mod " con " ?b))))
)

;; Recomendar accesorio cuando compre smartphone
(defrule recomendar-accesorio-smartphone
    (orden-procesando (categoria smartphone))
    (promo-accesorio (categoria-trigger smartphone) (accesorio-recomendado ?acc) (descuento ?d))
    (not (recomendacion-promo (descripcion ?desc&:(str-index ?acc ?desc))))
    =>
    (assert (recomendacion-promo (descripcion (str-cat "Por comprar smartphone, ofrece " ?acc " con " (* ?d 100) "% de descuento."))))
)

;; Ofrecer maletín si compra computadora
(defrule recomendar-maletin-computadora
    (orden-procesando (categoria computadora))
    (not (recomendacion-promo (descripcion ?d&:(str-index "maletin" ?d))))
    =>
    (assert (recomendacion-promo (descripcion "Por comprar computadora, ofrece un maletin con 20% de descuento.")))
)

;; Sugerir garantía extendida en compras grandes
(defrule recomendar-garantia-extendida
    (orden-procesando (precio-total ?pt&:(> ?pt 20000.0)))
    (not (recomendacion-promo (descripcion ?d&:(str-index "Garantia" ?d))))
    =>
    (assert (recomendacion-promo (descripcion "Por producto de alto valor, ofrece Garantia Extendida.")))
)

;; Iniciar cálculo de vales cuando cumple condiciones
(defrule disparar-calculo-vales
    (declare (salience -5)) 
    (info-pago (metodo-pago contado)) 
    (exists (orden-procesando (marca apple) (modelo iphone16)))
    (exists (orden-procesando (marca apple) (modelo macbookair)))
    (not (total-para-vales)) 
    =>
    (assert (total-para-vales (monto 0.0))) 
)

;; Ir sumando los montos para calcular el vale
(defrule acumular-monto-para-vales
    (declare (salience -6))
    ?v <- (total-para-vales (monto ?total))
    ?o <- (orden-procesando (precio-total ?pt))
    =>
    (retract ?v ?o) 
    (assert (total-para-vales (monto (+ ?total ?pt))))
)

;; Calcular el monto final del vale
(defrule calcular-vale-final
    (declare (salience -7))
    ?v <- (total-para-vales (monto ?total&:(> ?total 0)))
    (not (orden-procesando)) 
    =>
    (retract ?v)
    (bind ?monto-vale (* (div ?total 1000) 100))
    (if (> ?monto-vale 0) then
        (assert (vale-generado (monto ?monto-vale)))
    )
)

;; Mostrar clasificación del cliente
(defrule imprimir-clasificacion
    (declare (salience -20))
    ?f <- (clasificacion-cliente (tipo ?t))
    =>
    (printout t "--- Clasificacion del Cliente ---" crlf)
    (printout t "   -> Tipo: " ?t crlf crlf)
)

;; Mostrar ofertas que aplican
(defrule imprimir-ofertas
    (declare (salience -20))
    ?f <- (oferta-aplicada (descripcion ?d))
    =>
    (printout t "--- Ofertas que Aplican ---" crlf)
    (printout t "   -> " ?d crlf crlf)
)

;; Mostrar recomendaciones
(defrule imprimir-recomendaciones
    (declare (salience -20))
    ?f <- (recomendacion-promo (descripcion ?d))
    =>
    (printout t "--- Recomendaciones que Aplican ---" crlf)
    (printout t "   -> " ?d crlf crlf)
)

;; Mostrar vales generados
(defrule imprimir-vales
    (declare (salience -20))
    ?f <- (vale-generado (monto ?m))
    =>
    (printout t "--- Vales Generados ---" crlf)
    (printout t "   -> Se genero un vale por $" ?m " pesos." crlf crlf)
)

;; Mostrar alertas de inventario
(defrule imprimir-alerta-stock
    (declare (salience -20))
    ?f <- (alerta-stock (descripcion ?d))
    =>
    (printout t "--- Alerta de Inventario ---" crlf)
    (printout t "   -> " ?d crlf crlf)
)

;; Terminar el proceso
(defrule imprimir-mensaje-final
    (declare (salience -100))
    ?f <- (proceso-iniciado)
    =>
    (retract ?f)
    (printout t ">>> Procesamiento de orden finalizado. <<<" crlf crlf)
)