﻿CREATE PROCEDURE [dbo].[ListarOrdenVenta]
AS
BEGIN

SET NOCOUNT ON;

SELECT 
OV.Id,
OV.Numero,
OV.Cliente,
OV.FechaEntrega,
OV.Estado,
OV.Cantidad,
OV.IdProducto,
P.Descripcion AS DescripcionProducto
FROM dbo.OrdenVenta OV
INNER JOIN dbo.Producto P ON OV.IdProducto = P.Id

END
