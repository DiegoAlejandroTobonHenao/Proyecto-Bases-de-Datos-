--Todas las reservas que se convirtieron en alquiler
SELECT * 
FROM reserva r JOIN estado_reserva er ON r.estado_id = er.estado_reserva_id 
WHERE er.estado = 'Confirmada';

--Clientes con mas de 4 facturas
SELECT cliente_id, COUNT(*) cant
FROM factura GROUP BY cliente_id
HAVING COUNT(*) > 4;

--Valor total que pagó el cliente con mas facturas
SELECT SUM(p.precio)
FROM pagos p JOIN factura f ON p.pago_id = f.pago_id
            JOIN clientes c ON f.cliente_id = c.cliente_id
WHERE c.cliente_id IN (SELECT cliente_id FROM factura GROUP BY cliente_id 
HAVING COUNT(*) IN (SELECT MAX(factura_id) FROM factura GROUP BY cliente_id));

--Servicio mas solicitado en la habitacion mas reservada
SELECT DISTINCT s.descripcion AS servicio, h.habitacion_id
FROM servicios s JOIN registro_servicio rs ON s.servicio_id = rs.servicio_id
JOIN habitacion h ON rs.habitacion_id = h.habitacion_id
WHERE h.habitacion_id = (SELECT habitacion_id 
                        FROM (SELECT habitacion_id, COUNT(*) FROM registro_servicio GROUP BY habitacion_id ORDER BY COUNT(*) DESC) 
                        WHERE ROWNUM = 1)
AND s.servicio_id = (SELECT servicio_id 
                     FROM (SELECT servicio_id, COUNT(*) FROM registro_servicio GROUP BY servicio_id ORDER BY COUNT(*) DESC) 
                     WHERE ROWNUM = 1);

--Nombre y salario del empleado que prestó el servicio más solicitado
SELECT DISTINCT e.nombre, e.salario
FROM empleado e JOIN registro_servicio rs ON e.empleado_id = rs.empleado_id
WHERE rs.servicio_id = (SELECT servicio_id 
                        FROM (SELECT servicio_id, COUNT(*) FROM registro_servicio GROUP BY servicio_id ORDER BY COUNT(*) DESC) 
                        WHERE ROWNUM = 1)

