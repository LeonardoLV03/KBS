;; templates.clp
;; Definicion de estructuras de datos

(deftemplate producto
    (slot marca (type SYMBOL))
    (slot modelo (type SYMBOL))
    (slot categoria (type SYMBOL)) 
    (slot precio (type FLOAT))
    (slot stock (type INTEGER))
)

(deftemplate promo-banco
    (slot banco (type SYMBOL))
    (slot marca (type SYMBOL))
    (slot modelo (type SYMBOL))
    (slot meses-sin-interes (type INTEGER))
)

(deftemplate promo-accesorio
    (slot categoria-trigger (type SYMBOL))
    (slot accesorio-recomendado (type STRING))
    (slot descuento (type FLOAT))
)

(deftemplate tarjeta-credito
    (slot id (type SYMBOL)) 
    (slot banco (type SYMBOL))
    (slot grupo (type SYMBOL)) 
    (slot exp-date (type STRING))
)

(deftemplate orden
    (slot marca (type SYMBOL))
    (slot modelo (type SYMBOL))
    (slot qty (type INTEGER))
    (slot metodo-pago (type SYMBOL)) 
    (slot tarjeta-id (type SYMBOL) (default nil))
)

(deftemplate info-pago
    (slot metodo-pago (type SYMBOL))
)

(deftemplate orden-procesando
    (slot marca (type SYMBOL))
    (slot modelo (type SYMBOL))
    (slot categoria (type SYMBOL))
    (slot qty (type INTEGER))
    (slot metodo-pago (type SYMBOL))
    (slot banco-tarjeta (type SYMBOL)) 
    (slot precio-total (type FLOAT))
)

(deftemplate clasificacion-cliente
    (slot tipo (type SYMBOL))
)

(deftemplate oferta-aplicada
    (slot descripcion (type STRING))
)

(deftemplate recomendacion-promo
    (slot descripcion (type STRING))
)

(deftemplate total-para-vales
    (slot monto (type FLOAT) (default 0.0))
)

(deftemplate vale-generado
    (slot monto (type FLOAT))
)

;; para las alertas de inventario
(deftemplate alerta-stock
    (slot descripcion (type STRING))
)

(deftemplate proceso-iniciado)