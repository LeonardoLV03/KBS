;; --- run.clp ---

(load "templates.clp")
(printout t "Plantillas cargadas." crlf)
(load "facts.clp")
(printout t "Hechos (Productos, Tarjetas y Promos) cargados." crlf)
(load "rules.clp")
(printout t "Reglas cargadas." crlf crlf)

;; --- SIMULACION 1: iPhone 16 con Banamex (ID: "banamex-oro") ---
(printout t "------------------------------------------------" crlf)
(printout t "Simulacion 1: Cliente compra iPhone 16 con ID 'banamex-oro'" crlf)
(reset) 

(assert (orden (marca apple) (modelo iphone16) (qty 1) (metodo-pago credito) (tarjeta-id banamex-oro)))
(run)
(printout t "------------------------------------------------" crlf crlf)

;; --- SIMULACION 2: Samsung Note 21 con Liverpool (ID: "liverpool-visa") ---
(printout t "------------------------------------------------" crlf)
(printout t "Simulacion 2: Cliente compra Samsung Note 21 con ID 'liverpool-visa'" crlf)
(reset) 

(assert (orden (marca samsung) (modelo note21) (qty 30) (metodo-pago credito) (tarjeta-id liverpool-visa)))
(run)
(printout t "------------------------------------------------" crlf crlf)

;; --- SIMULACION 3: Compra de Contado (Req. 3) ---
(printout t "------------------------------------------------" crlf)
(printout t "Simulacion 3: Cliente compra MacBook Air y iPhone 16 de contado" crlf)
(reset) 
(assert (info-pago (metodo-pago contado)))
(assert (orden (marca apple) (modelo iphone16) (qty 1) (metodo-pago contado) (tarjeta-id nil)))
(assert (orden (marca apple) (modelo macbookair) (qty 1) (metodo-pago contado) (tarjeta-id nil)))
(run)
(printout t "------------------------------------------------" crlf crlf)

;; --- SIMULACION 4: Prueba de Tarjeta Vencida (ID: "bbva-visa") ---
(printout t "------------------------------------------------" crlf)
(printout t "Simulacion 4: Cliente intenta comprar con tarjeta vencida 'bbva-visa'" crlf)
(reset) 

(assert (orden (marca apple) (modelo iphone16) (qty 1) (metodo-pago credito) (tarjeta-id bbva-visa)))
(run)
(printout t "------------------------------------------------" crlf crlf)