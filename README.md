# sql-select-fundamentals

Este repositorio contiene tres consultas SQL básicas sobre la tabla `sales`, orientadas a practicar el uso correcto de `SELECT`, la selección de columnas específicas y el renombrado con alias (`AS`).

## Estructura del repositorio

```
sql-select-fundamentals/
├── consultas_basicas.sql
└── README.md
```

- `consultas_basicas.sql` → Contiene las tres consultas del ejercicio:
  - **Consulta 1:** exploración general de la tabla `sales` con `SELECT *`.
  - **Consulta 2:** selección de columnas específicas (`customer_id`, `product_id`, `total_amount`).
  - **Consulta 3:** selección de columnas con alias en español usando `snake_case` (`id_cliente`, `id_producto`, `monto_total`).
- `README.md` → Documentación y justificación técnica de las decisiones tomadas.

---

## 1. ¿Por qué es mala práctica usar `SELECT *` en producción?

Aunque `SELECT *` es cómodo para explorar una tabla en desarrollo, en un entorno productivo introduce varios problemas concretos:

### a) Rendimiento

`SELECT *` obliga al motor de base de datos a leer y transmitir **todas** las columnas de la tabla, incluso aquellas que la aplicación no necesita. Esto genera:

- Mayor consumo de memoria y ancho de banda entre el servidor y el cliente.
- Imposibilidad de aprovechar **índices de cobertura** (covering indexes), que permiten resolver una consulta leyendo únicamente el índice sin tocar la tabla.
- Tiempos de respuesta más lentos, especialmente en tablas con columnas de tipo `TEXT`, `BLOB` o `JSON` muy pesadas.

**Ejemplo:** si la tabla `sales` tiene 25 columnas pero mi reporte solo necesita 3, `SELECT *` transfiere 22 columnas innecesarias en cada ejecución. En un dashboard que se refresca cada minuto, ese desperdicio se multiplica.

### b) Mantenibilidad

`SELECT *` acopla la consulta al esquema actual de la tabla. Si mañana alguien agrega, elimina o reordena una columna:

- Los reportes que dependen del orden de columnas se rompen silenciosamente.
- El código de la aplicación puede empezar a recibir datos que no esperaba.
- Se vuelve imposible saber, leyendo la consulta, qué campos realmente se están usando.

Ser explícito con las columnas hace que la intención del código sea evidente y que los cambios de esquema sean detectables.

### c) Seguridad

Al traer todas las columnas, también se traen **campos sensibles** que quizás no deberían salir de la base: emails de clientes, números de tarjeta, direcciones, comisiones internas. Un `SELECT *` en un endpoint público puede filtrar información confidencial sin que nadie lo note hasta que ya es tarde. Nombrar columnas explícitamente actúa como un control de acceso a nivel de consulta.

---

## 2. ¿Por qué son importantes los alias para un stakeholder no técnico?

Los nombres de columnas en una base de datos suelen estar pensados para desarrolladores: usan inglés, abreviaturas y convenciones técnicas (`total_amount`, `cust_id`, `ts_created`). Para alguien del área de finanzas, marketing o dirección, esos nombres son ruido.

Los alias (`AS`) permiten **traducir el modelo técnico al lenguaje del negocio** sin modificar la estructura de la base.

### Ejemplo concreto

Sin alias, una analista de finanzas recibe esto:

```sql
SELECT customer_id, product_id, total_amount
FROM sales;
```

| customer_id | product_id | total_amount |
|-------------|------------|--------------|
| 1023        | 45         | 15000.00     |

Para interpretarlo tiene que preguntar: "¿`total_amount` es el monto bruto, el neto, incluye impuestos, está en pesos o en dólares?"

Con alias en español y `snake_case`:

```sql
SELECT
    customer_id AS id_cliente,
    product_id  AS id_producto,
    total_amount AS monto_total
FROM sales;
```

| id_cliente | id_producto | monto_total |
|------------|-------------|-------------|
| 1023       | 45          | 15000.00    |

Ahora la persona de finanzas lee directamente **"monto total"** y entiende el contenido sin necesidad de traducción ni diccionario técnico. Esto:

- Reduce errores de interpretación en reportes.
- Acelera la toma de decisiones (no hay que ir y volver preguntando).
- Hace que exports a Excel, Power BI o Looker lleguen ya con encabezados legibles.

En resumen: **los alias son la capa de presentación de los datos**. Son gratis, no afectan el rendimiento y transforman una consulta técnica en un reporte listo para el negocio.

---

## Buenas prácticas aplicadas en este repositorio

- Ninguna consulta usa coma después de la última columna antes del `FROM`.
- Los alias usan `snake_case` en español, sin espacios ni caracteres especiales.
- Se prefiere listar columnas explícitamente antes que usar `SELECT *`.
