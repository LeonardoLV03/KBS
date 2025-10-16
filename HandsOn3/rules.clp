;; Archivo: rules.clp
;; Descripcion: Contiene la logica de inferencia y el sistema de recomendacion.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REGLAS DE ANÁLISIS DE COMPORTAMIENTO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule find-inactive-customers
    (customer (customer-id ?id) (name ?name))
    (not (order (customer-id ?id)))
    =>
    (printout t "[INFO] " ?name " no ha realizado ninguna compra." crlf)
)

(defrule report-customer-purchases
    (customer (customer-id ?id) (name ?c-name))
    (line-item (customer-id ?id) (part-number ?p-num) (quantity ?qty))
    (product (part-number ?p-num) (name ?p-name))
    =>
    (printout t "[PURCHASE] " ?c-name " compro " ?qty " unidad(es) de '" ?p-name "'." crlf)
)

(defrule find-bulk-buyers
    (customer (customer-id ?id) (name ?c-name))
    (line-item (customer-id ?id) (part-number ?p-num) (quantity ?qty&:(> ?qty 5)))
    (product (part-number ?p-num) (name ?p-name))
    =>
    (printout t "[ALERT] " ?c-name " es un comprador de alto volumen (compro " ?qty " de '" ?p-name "')." crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REGLAS DE ACCIÓN Y RECOMENDACIÓN (RECOMMENDER SYSTEM)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule action-contact-inactive-customer
    (customer (customer-id ?cid) (name ?name) (phone ?phone))
    (not (order (customer-id ?cid)))
    =>
    (assert (promo-contact name ?name phone ?phone message "¡Hola! Tienes un 25% de descuento en tu proxima compra."))
    (printout t "[ACTION] Enviar promo a " ?name " al telefono " ?phone "." crlf)
)

(defrule recommend-similar-category-products
    (line-item (customer-id ?c-id) (part-number ?p1-num))
    (customer (customer-id ?c-id) (name ?c-name))
    (product (part-number ?p1-num) (category ?cat))
    (product (part-number ?p2-num&~?p1-num) (name ?p2-name) (category ?cat))
    (not (line-item (customer-id ?c-id) (part-number ?p2-num)))
    =>
    (assert (recommendation customer-name ?c-name product-name ?p2-name))
    (printout t "[RECOMMENDATION] Para " ?c-name ": Ya que te gusto la categoria '" 
              ?cat "', podria interesarte el producto '" ?p-name "'." crlf)
)