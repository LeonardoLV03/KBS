;; --- facts.clp ---
;; Define los hechos iniciales
;; sobre productos, tarjetas y promociones.

(deffacts catalogo-y-promociones
    
    ;; --- Catalogo de Productos ---
    (producto (marca apple) (modelo iphone16) (categoria smartphone) (precio 27000.0) (stock 50))
    (producto (marca apple) (modelo macbookpro) (categoria computadora) (precio 47000.0) (stock 30))
    (producto (marca samsung) (modelo note21) (categoria smartphone) (precio 22000.0) (stock 40))
    (producto (marca apple) (modelo macbookair) (categoria computadora) (precio 25000.0) (stock 25))

    ;; --- Catalogo de Tarjetas Conocidas ---    
    (tarjeta-credito (id banamex-oro) (banco banamex) (grupo mastercard) (exp-date "10-26"))
    (tarjeta-credito (id liverpool-visa) (banco liverpool) (grupo visa) (exp-date "12-25"))
    (tarjeta-credito (id bbva-visa) (banco bbva) (grupo visa) (exp-date "01-23")) ; 

    ;; --- Catalogo de Promociones de Bancos ---
    (promo-banco (banco banamex) (marca apple) (modelo iphone16) (meses-sin-interes 24))
    (promo-banco (banco liverpool) (marca samsung) (modelo note21) (meses-sin-interes 12))
    
    ;; --- Promocion de Accesorios ---
    (promo-accesorio (categoria-trigger smartphone) 
                     (accesorio-recomendado "funda y mica") 
                     (descuento 0.15))
)