;; --- facts.clp ---
;; Define los hechos iniciales (conocimiento base) 
;; sobre clientes, productos y compras.

(deffacts initial-market-data
    
    ;; --- Catalogo de Clientes ---
    (customer (customer-id "C101") (name "Ana Garcia") (interests "photography" "electronics"))
    (customer (customer-id "C102") (name "Bruno Diaz") (interests "audio" "computing"))
    (customer (customer-id "C103") (name "Carla Solis") (interests "photography" "gadgets"))

    ;; --- Catalogo de Productos ---
    (product (part-number "P-01") (name "Camara DSLR") (category "photography") (price 599.99) (stock 10))
    (product (part-number "P-02") (name "Lente 50mm") (category "photography") (price 179.99) (stock 20))
    (product (part-number "P-03") (name "Tripode Pro") (category "photography") (price 89.99) (stock 15))
    (product (part-number "A-01") (name "Audifonos Hi-Fi") (category "audio") (price 249.99) (stock 30))
    (product (part-number "A-02") (name "Amplificador de Tubo") (category "audio") (price 499.99) (stock 5))
    (product (part-number "C-01") (name "Teclado Mecanico") (category "computing") (price 120.00) (stock 25))
    
    ;; --- Conductas de Consumo (Ordenes) ---
    
    ;; Ana (C101) compro una Camara y un Lente
    (line-item (order-number 1) (customer-id "C101") (part-number "P-01"))
    (line-item (order-number 1) (customer-id "C101") (part-number "P-02"))
    
    ;; Bruno (C102) compro unos Audifonos
    (line-item (order-number 2) (customer-id "C102") (part-number "A-01"))
    
    ;; Carla (C103) compro la misma Camara que Ana
    (line-item (order-number 3) (customer-id "C103") (part-number "P-01"))
)