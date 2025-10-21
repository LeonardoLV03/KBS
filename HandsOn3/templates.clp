;; --- templates.clp ---
;; Define las estructuras de datos (plantillas) 
;; para el sistema de recomendacion del mercado.

(deftemplate customer
    (slot customer-id (type STRING))
    (slot name (type STRING))
    (multislot interests (type STRING)) ; Intereses del cliente
)

(deftemplate product
    (slot part-number (type STRING))
    (slot name (type STRING))
    (slot category (type STRING))
    (slot price (type FLOAT))
    (slot stock (type INTEGER) (default 1))
)

;; Usamos line-item para representar compras historicas
(deftemplate line-item
    (slot order-number (type INTEGER))
    (slot customer-id (type STRING))
    (slot part-number (type STRING))
)

;; Plantilla para un hecho "limpio" que indica una compra
(deftemplate bought
    (slot customer-id (type STRING))
    (slot part-number (type STRING))
)

;; Plantilla para almacenar las recomendaciones generadas
(deftemplate recommendation
    (slot customer-id (type STRING))
    (slot part-number (type STRING))
    (slot product-name (type STRING))
    (slot reason (type STRING)) ; Por que recomendamos esto?
)