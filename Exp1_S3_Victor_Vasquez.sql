--CASO 1
-- LISTA EL NOMBRE DE CADA PRODUCTO AGRUPADO POR CATEGORÍA. ORDENA LOS RESULTADOS POR PRECIO DE MAYOR A MENOR.
SELECT UPPER(categoria) as categoria, UPPER(nombre) as nombre, TO_CHAR(precio, '$99999999') as precio
FROM Productos
ORDER BY categoria, precio DESC;

-- CALCULA EL PROMEDIO DE VENTAS MENSUALES (EN CANTIDAD DE PRODUCTOS) Y MUESTRA EL MES Y AÑO CON MAYORES VENTAS.
SELECT TO_CHAR(fecha, 'MM-YYYY') AS mes_anno,
       SUM(cantidad) AS total_ventas_del_mes,
       ROUND(AVG(SUM(cantidad)) OVER (), 2) AS promedio_por_mes
FROM Ventas
GROUP BY TO_CHAR(fecha, 'MM-YYYY')
ORDER BY total_ventas_del_mes DESC
FETCH FIRST 1 ROWS ONLY;

-- ENCUENTRA EL ID DEL CLIENTE QUE HA GASTADO MÁS DINERO EN COMPRAS DURANTE EL ÚLTIMO AÑO. ASEGÚRATE DE CONSIDERAR CLIENTES QUE SE REGISTRARON HACE MENOS DE UN AÑO.
SELECT c.cliente_id,
       UPPER(c.nombre) as nombre_cliente,
       SUM(v.cantidad * p.precio) AS gastado
FROM Ventas v
JOIN Productos p ON v.producto_id = p.producto_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
WHERE v.fecha BETWEEN ADD_MONTHS(SYSDATE, -12) AND SYSDATE
  AND c.fecha_registro >= ADD_MONTHS(SYSDATE, -12)
GROUP BY c.cliente_id, c.nombre
ORDER BY gastado DESC
FETCH FIRST 1 ROWS ONLY;

-- CASO 2
-- DETERMINA EL SALARIO PROMEDIO, EL SALARIO MÁXIMO Y EL SALARIO MÍNIMO POR DEPARTAMENTO.
SELECT departamento,
       TO_CHAR(AVG(salario), '$99999999') AS sueldo_promedio,
       TO_CHAR(MAX(salario), '$99999999') AS sueldo_mayor,
       TO_CHAR(MIN(salario), '$99999999') AS sueldo_menor
FROM Empleados
GROUP BY departamento;

-- UTILIZANDO FUNCIONES DE GRUPO, ENCUENTRA EL SALARIO MÁS ALTO EN CADA DEPARTAMENTO.
SELECT departamento,
       TO_CHAR(MAX(salario), '$99999999') AS sueldo_mayor
FROM Empleados
GROUP BY departamento;

-- CALCULA LA ANTIGÜEDAD EN AÑOS DE CADA EMPLEADO Y MUESTRA AQUELLOS CON MÁS DE 10 AÑOS EN LA EMPRESA.
SELECT empleado_id,
       nombre,
       departamento,
       TRUNC(ROUND(MONTHS_BETWEEN(SYSDATE, fecha_contratacion)) / 12) AS annos_antiguedad
FROM Empleados
WHERE TRUNC(ROUND(MONTHS_BETWEEN(SYSDATE, fecha_contratacion)) / 12) >= 10;