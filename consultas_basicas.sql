-- ══════════════════════════════════════════
-- TechStore — Consultas Básicas SELECT
-- Autor: Manuela Caro Villada
-- Fecha: 28/07/2026
-- ══════════════════════════════════════════

-- Consulta 1: Exploración general de la tabla sales
SELECT * FROM sales;
-- exploración inicial: cuando todavía no conocemos la estructura de `sales` y
-- queremos ver qué columnas existen, sus tipos de dato y una muestra de valores.
-- También sirve para pruebas rápidas en un entorno local o para debugging puntual.
--
-- NO conviene usarlo en producción por tres razones:
--   1) Rendimiento: transfiere columnas que la aplicación no necesita, impide
--      aprovechar índices de cobertura y aumenta el consumo de memoria y red.
--   2) Mantenibilidad: si mañana se agrega, elimina o reordena una columna,
--      los reportes y el código que dependen del resultado se rompen en silencio.
--   3) Seguridad: puede exponer campos sensibles (emails, datos de pago, montos
--      internos) que nunca deberían salir de la base hacia capas superiores.

-- Consulta 2: Selección de columnas específicas para finanzas
SELECT customer_id, product_id, total_amount FROM sales;

-- Consulta 3: Selección con alias en español para stakeholders
SELECT order_date AS fecha_pedido, product_name AS nombre_producto, quantity AS cantidad_unidades FROM sales;
