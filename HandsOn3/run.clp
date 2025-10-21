;; --- run.clp ---
;; Script principal para ejecutar el Sistema de Recomendacion.

;; 1. Cargar las definiciones de datos
(load templates.clp)
(printout t "Plantillas cargadas." crlf)

;; 2. Cargar los hechos iniciales
(load facts.clp)
(printout t "Hechos cargados." crlf)

;; 3. Cargar el motor de inferencia
(load rules.clp)
(printout t "Reglas cargadas." crlf crlf)

;; 4. Preparar la memoria de trabajo con los 'deffacts'
(reset)
(printout t "Sistema reseteado. Iniciando motor de inferencia..." crlf crlf)

;; 5. Ejecutar el sistema
(run)

(printout t crlf "--- Proceso de recomendacion completado ---" crlf)