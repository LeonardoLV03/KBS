;; Archivo: facts.clp
;; Descripcion: Contiene los datos iniciales del sistema.

(deffacts initial-data
    ;; Lista de productos
    (product (name USBdw) (category storage) (part-number 1234) (price 199.99))
    (product (name Amplifier) (category electronics) (part-number 2341) (price 399.99))
    (product (name "Speakers") (category electronics) (part-number 2342) (price 150.00)) ;; <-- PRODUCTO NUEVO
    (product (name "Rubber duck") (category mechanics) (part-number 3412) (price 99.99))

    ;; Lista de clientes
    (customer (customer-id 101) (name joe) (address bla bla bla) (phone 3313073905))
    (customer (customer-id 102) (name mary) (address bla bla bla) (phone 333222345))
    (customer (customer-id 103) (name bob) (address bla bla bla) (phone 331567890))

    ;; Lista de ordenes
    (order (order-number 300) (customer-id 102))
    (order (order-number 301) (customer-id 103))

    ;; Lista de items en cada orden
    (line-item (order-number 300) (customer-id 102) (part-number 1234))
    (line-item (order-number 301) (customer-id 103) (part-number 2341) (quantity 10))
)