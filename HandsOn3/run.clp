;; Archivo: run.clp
;; Descripcion: Carga todos los componentes del sistema y lo ejecuta.

;; 1. Cargar las plantillas (la estructura de los datos)
(load templates.clp)
(printout t "Templates cargados." crlf)

;; 2. Cargar los hechos iniciales (los datos)
(load facts.clp)
(printout t "Hechos cargados." crlf)

;; 3. Cargar las reglas (la logica)
(load rules.clp)
(printout t "Reglas cargadas." crlf crlf)

;; 4. Preparar la memoria de trabajo con los hechos iniciales
(reset)

;; 5. Ejecutar el motor de inferencia
(run)