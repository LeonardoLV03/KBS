;; --- rules.clp ---
;; Define el motor de inferencia (reglas) para 
;; generar recomendaciones de consumo.

;; --- REGLA DE PRE-PROCESAMIENTO ---
;; Convierte los line-items en hechos 'bought' mas simples 
;; para facilitar el 'pattern matching' en otras reglas.
(defrule derive-bought-item
    ?li <- (line-item (customer-id ?cid) (part-number ?pid))
    =>
    (assert (bought (customer-id ?cid) (part-number ?pid)))
    (retract ?li) ; Evita bucles infinitos
)

;; --- MOTOR DE RECOMENDACION ---

;; Regla 1: Recomendar productos de la MISMA CATEGORIA (Content-Based)
;; "Como compraste [Producto 1], quizas te interese [Producto 2] 
;; de la misma categoria."
(defrule recommend-same-category
    (bought (customer-id ?cid) (part-number ?pid1))
    (product (part-number ?pid1) (category ?cat))
    (product (part-number ?pid2) (name ?pname) (category ?cat) (stock ?s&:(> ?s 0)))
    (test (neq ?pid1 ?pid2)) ; No recomendar el mismo producto
    (not (bought (customer-id ?cid) (part-number ?pid2))) ; Que no lo haya comprado ya
    (not (recommendation (customer-id ?cid) (part-number ?pid2))) ; Que no se haya recomendado ya
    =>
    (assert (recommendation (customer-id ?cid) 
                           (part-number ?pid2)
                           (product-name ?pname)
                           (reason (str-cat "Porque compraste en la categoria " ?cat))))
)

;; Regla 2: Recomendar "Otros tambien compraron" (Collaborative Filtering)
;; "Quienes compraron [Producto X] (como tu), tambien compraron [Producto Y]."
(defrule recommend-also-bought
    ;; Cliente A (?cid1) compro X y Y
    (bought (customer-id ?cid1) (part-number ?pidX))
    (bought (customer-id ?cid1) (part-number ?pidY))
    (test (neq ?pidX ?pidY))
    
    ;; Cliente B (?cid2) compro X...
    (bought (customer-id ?cid2) (part-number ?pidX))
    (test (neq ?cid1 ?cid2)) ; ...y es un cliente diferente
    
    ;; ...pero Cliente B NO ha comprado Y
    (not (bought (customer-id ?cid2) (part-number ?pidY)))
    
    ;; El producto Y existe y tiene stock
    (product (part-number ?pidY) (name ?pname) (stock ?s&:(> ?s 0)))
    
    ;; Y no se lo hemos recomendado ya
    (not (recommendation (customer-id ?cid2) (part-number ?pidY)))
    =>
    (assert (recommendation (customer-id ?cid2)
                           (part-number ?pidY)
                           (product-name ?pname)
                           (reason (str-cat "Quienes compraron " ?pidX " tambien compraron " ?pname))))
)


;; Regla 3: Recomendar basado en INTERESES (Content-Based)
;; "Vemos que te interesa la categoria [Categoria], pero 
;; aun no has comprado [Producto]."
(defrule recommend-from-interest
    ;; El cliente tiene un interes declarado
    (customer (customer-id ?cid) (interests $? ?cat $?))
    
    ;; Existe un producto en esa categoria
    (product (part-number ?pid) (name ?pname) (category ?cat) (stock ?s&:(> ?s 0)))
    
    ;; El cliente NO ha comprado ese producto
    (not (bought (customer-id ?cid) (part-number ?pid)))
    
    ;; Y no se lo hemos recomendado ya
    (not (recommendation (customer-id ?cid) (part-number ?pid)))
    =>
    (assert (recommendation (customer-id ?cid)
                           (part-number ?pid)
                           (product-name ?pname)
                           (reason (str-cat "Vimos que te interesa la categoria " ?cat))))
)


;; --- REGLA DE SALIDA ---
;; Imprime las recomendaciones generadas en la consola.
;; Se ejecuta al final gracias a su baja 'salience'.
(defrule display-recommendations
    (declare (salience -10)) ; Prioridad baja, se ejecuta al final
    ?r <- (recommendation (customer-id ?cid) 
                         (part-number ?pid) 
                         (product-name ?pname) 
                         (reason ?reason))
    =>
    (printout t "===========================================" crlf)
    (printout t "💡 RECOMENDACION para Cliente " ?cid ":" crlf)
    (printout t "   -> Producto: " ?pname " (ID: " ?pid ")" crlf)
    (printout t "   -> Razon: " ?reason crlf)
    (printout t "===========================================" crlf crlf)
    ;; Simplemente borra o comenta la linea (retract ?r)
)