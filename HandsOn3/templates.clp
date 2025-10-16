;; Archivo: templates.clp
;; Descripcion: Define las plantillas para los hechos del sistema.

(deftemplate customer
   (slot customer-id)
   (multislot name)        ;; <-- Este es un multislot
   (multislot address)
   (slot phone)
)

(deftemplate product
   (slot part-number)
   (slot name)
   (slot category)
   (slot price)
)

(deftemplate order
   (slot order-number)
   (slot customer-id)
)

(deftemplate line-item
   (slot order-number)
   (slot part-number)
   (slot customer-id)
   (slot quantity (default 1))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CORRECCIÓN: Cambiado de 'slot' a 'multislot' para que coincida con 'customer'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftemplate promo-contact
    (multislot name)        ;; <-- CORREGIDO
    (slot phone)
    (slot message)
)

(deftemplate recommendation
    (multislot customer-name) ;; <-- CORREGIDO
    (slot product-name)
)