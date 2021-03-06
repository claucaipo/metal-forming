USE [MetalForming]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarEstadoOrdenVenta]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarEstadoOrdenVenta]
(
	@Id int,
	@Estado varchar(50)
)
AS
BEGIN

SET NOCOUNT ON;

UPDATE dbo.OrdenVenta SET Estado = @Estado WHERE Id = @Id

END


GO
/****** Object:  StoredProcedure [dbo].[ActualizarStockProducto]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarStockProducto]
(
	@IdProducto int,
	@Cantidad int
)
AS
BEGIN

SET NOCOUNT ON;

UPDATE dbo.Producto 
SET Stock = Stock + @Cantidad
WHERE Id = @IdProducto

END


GO
/****** Object:  StoredProcedure [dbo].[InsertarOrdenProduccion]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarOrdenProduccion]
(
	@IdOrdenVenta int,
	@Estado varchar(50),
	@CantidadProducto int
)
AS
BEGIN

SET NOCOUNT ON;

INSERT INTO dbo.OrdenProduccion(Numero, IdOrdenVenta, Estado, CantidadProducto, FechaCreacion)
VALUES('', @IdOrdenVenta, @Estado, @CantidadProducto, GETDATE());

DECLARE @IdOrdeProduccion int = 0;

SELECT @IdOrdeProduccion = SCOPE_IDENTITY();

UPDATE dbo.OrdenProduccion
SET Numero = 'OP' + REPLACE(STR(Id, 6), SPACE(1), '0')
WHERE Id = @IdOrdeProduccion;

SELECT @IdOrdeProduccion;

END



GO
/****** Object:  StoredProcedure [dbo].[InsertarOrdenProduccionMaterial]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarOrdenProduccionMaterial]
(
	@IdOrdenProduccion int,
	@IdMaterial int,
	@Requerido int,
	@Comprar int
)
AS
BEGIN

SET NOCOUNT ON;

INSERT INTO dbo.OrdenProduccionMaterial(IdOrdenProduccion, IdMaterial, Requerido, Comprar)
VALUES(@IdOrdenProduccion, @IdMaterial, @Requerido, @Comprar);

END


GO
/****** Object:  StoredProcedure [dbo].[InsertarOrdenProduccionSecuencia]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarOrdenProduccionSecuencia]
(
	@Secuencia int,
	@IdOrdenProduccion int,
	@IdMaquina int,
	@FechaInicio datetime,
	@FechaFin datetime
)
AS
BEGIN

SET NOCOUNT ON;

INSERT INTO dbo.OrdenProduccionSecuencia(Secuencia, IdOrdenProduccion, IdMaquina, FechaInicio, FechaFin)
VALUES(@Secuencia, @IdOrdenProduccion, @IdMaquina, @FechaInicio, @FechaFin);

END


GO
/****** Object:  StoredProcedure [dbo].[ListarMaquinaPorBusqueda]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarMaquinaPorBusqueda]
(
	@Descripcion varchar(50),
	@Tipo varchar(50),
	@PLD varchar(50),
	@Configuracion varchar(50)
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
Id,
Descripcion,
Tipo,
PLD,
Configuracion,
PorcentajeFalla,
Tiempo
FROM dbo.Maquina 
WHERE Descripcion LIKE '%' + @Descripcion + '%' 
	AND Tipo LIKE '%' + @Tipo + '%' 
	AND PLD LIKE '%' + @PLD + '%' 
	AND Configuracion LIKE '%' + @Configuracion + '%' 

END


GO
/****** Object:  StoredProcedure [dbo].[ListarMaterialPorProducto]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarMaterialPorProducto]
(
	@IdProducto int
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
M.Id,
M.Descripcion,
M.Stock,
M.StockMinimo,
M.Reservado,
PM.Cantidad
FROM dbo.ProductoMaterial AS PM
INNER JOIN dbo.Material AS M ON PM.IdMaterial = M.Id
WHERE PM.IdProducto = @IdProducto

END


GO
/****** Object:  StoredProcedure [dbo].[ListarOrdenProduccion]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarOrdenProduccion]
AS
BEGIN

SET NOCOUNT ON;

SELECT 
OP.Id,
OP.Numero,
OP.IdOrdenVenta,
OP.Estado,
OV.Numero AS NumeroOrdenVenta,
OV.FechaEntrega,
P.Descripcion AS DescripcionProducto
FROM dbo.OrdenProduccion OP
INNER JOIN dbo.OrdenVenta OV ON OP.IdOrdenVenta = OV.Id
INNER JOIN dbo.Producto P ON OV.IdProducto = P.Id

END


GO
/****** Object:  StoredProcedure [dbo].[ListarOrdenProduccionMaterial]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarOrdenProduccionMaterial]
(
	@IdOrdenProduccion int
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
OP.Id,
OP.IdOrdenProduccion,
OP.IdMaterial,
OP.Requerido,
OP.Comprar,
M.Descripcion,
M.Stock,
M.StockMinimo,
M.Reservado
FROM dbo.OrdenProduccionMaterial OP
INNER JOIN dbo.Material M ON OP.IdMaterial = M.Id
WHERE OP.IdOrdenProduccion = @IdOrdenProduccion

END


GO
/****** Object:  StoredProcedure [dbo].[ListarOrdenProduccionSecuencia]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarOrdenProduccionSecuencia]
(
	@IdOrdenProduccion int
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
OP.Id,
OP.Secuencia,
OP.IdMaquina,
OP.FechaInicio,
OP.FechaFin,
M.Descripcion,
M.PorcentajeFalla,
M.Tiempo
FROM dbo.OrdenProduccionSecuencia OP
INNER JOIN dbo.Maquina M ON OP.IdMaquina = M.Id
WHERE OP.IdOrdenProduccion = @IdOrdenProduccion

END


GO
/****** Object:  StoredProcedure [dbo].[ListarOrdenVenta]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListarOrdenVenta]
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


GO
/****** Object:  StoredProcedure [dbo].[ObtenerMaquinaPorID]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ObtenerMaquinaPorID]
(
	@Id int
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
Id,
Descripcion,
Tipo,
PLD,
Configuracion,
Estado,
ReduacionInicio,
ReduacionFin,
CantidadRodillos,
MaximoFrio,
MaximoCaliente,
PorcentajeFalla,
Tiempo
FROM dbo.Maquina 
WHERE Id = @Id

END


GO
/****** Object:  StoredProcedure [dbo].[ObtenerOrdenProduccionPorNumero]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ObtenerOrdenProduccionPorNumero]
(
	@Numero varchar(50)
)
AS
BEGIN

SET NOCOUNT ON;

SELECT 
OP.Id,
OP.Numero,
OP.IdOrdenVenta,
OP.Estado,
OP.CantidadProducto,
OV.Numero AS NumeroOrdenVenta,
OV.Cliente,
OV.FechaEntrega,
OV.Cantidad AS CantidadOrdenVenta,
OV.IdProducto,
P.Descripcion AS DescripcionProducto
FROM dbo.OrdenProduccion OP
INNER JOIN dbo.OrdenVenta OV ON OP.IdOrdenVenta = OV.Id
INNER JOIN dbo.Producto P ON OV.IdProducto = P.Id
WHERE OP.Numero = @Numero

END

GO
/****** Object:  StoredProcedure [dbo].[ObtenerOrdenVentaPorNumero]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerOrdenVentaPorNumero]
(
	@Numero varchar(50)
)
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
P.Descripcion AS DescripcionProducto,
P.Stock AS StockProducto,
P.StockMinimo AS StockMinimoProducto
FROM dbo.OrdenVenta OV
INNER JOIN dbo.Producto P ON OV.IdProducto = P.Id
WHERE OV.Numero = @Numero

END


GO
/****** Object:  Table [dbo].[Maquina]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Maquina](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NULL,
	[Tipo] [varchar](50) NULL,
	[PLD] [varchar](50) NULL,
	[Configuracion] [varchar](50) NULL,
	[Estado] [varchar](50) NULL,
	[ReduacionInicio] [varchar](50) NULL,
	[ReduacionFin] [varchar](50) NULL,
	[CantidadRodillos] [varchar](50) NULL,
	[MaximoFrio] [varchar](50) NULL,
	[MaximoCaliente] [varchar](50) NULL,
	[PorcentajeFalla] [varchar](50) NULL,
	[Tiempo] [varchar](50) NULL,
 CONSTRAINT [PK_Maquina] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Material]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Material](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[Stock] [int] NOT NULL,
	[StockMinimo] [int] NOT NULL,
	[Reservado] [int] NOT NULL,
 CONSTRAINT [PK_Material] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrdenProduccion]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrdenProduccion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](50) NOT NULL,
	[IdOrdenVenta] [int] NOT NULL,
	[Estado] [varchar](50) NOT NULL,
	[CantidadProducto] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
 CONSTRAINT [PK_OrdenProduccion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrdenProduccionMaterial]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenProduccionMaterial](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdOrdenProduccion] [int] NOT NULL,
	[IdMaterial] [int] NOT NULL,
	[Requerido] [int] NOT NULL,
	[Comprar] [int] NOT NULL,
 CONSTRAINT [PK_OrdenProduccionMaterial] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrdenProduccionSecuencia]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenProduccionSecuencia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Secuencia] [int] NOT NULL,
	[IdOrdenProduccion] [int] NOT NULL,
	[IdMaquina] [int] NOT NULL,
	[FechaInicio] [datetime] NOT NULL,
	[FechaFin] [datetime] NOT NULL,
 CONSTRAINT [PK_OrdenProduccionSecuencia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrdenVenta]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrdenVenta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Numero] [varchar](50) NOT NULL,
	[Cliente] [varchar](50) NOT NULL,
	[FechaEntrega] [datetime] NOT NULL,
	[Estado] [varchar](50) NOT NULL,
	[Cantidad] [int] NOT NULL,
	[IdProducto] [int] NOT NULL,
 CONSTRAINT [PK_OrdenVenta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Producto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[Stock] [int] NOT NULL,
	[StockMinimo] [int] NOT NULL,
 CONSTRAINT [PK_Producto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductoMaterial]    Script Date: 11/10/2015 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductoMaterial](
	[IdProducto] [int] NOT NULL,
	[IdMaterial] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
 CONSTRAINT [PK_ProductoMaterial] PRIMARY KEY CLUSTERED 
(
	[IdProducto] ASC,
	[IdMaterial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Maquina] ON 

INSERT [dbo].[Maquina] ([Id], [Descripcion], [Tipo], [PLD], [Configuracion], [Estado], [ReduacionInicio], [ReduacionFin], [CantidadRodillos], [MaximoFrio], [MaximoCaliente], [PorcentajeFalla], [Tiempo]) VALUES (1, N'Maquina 01', N'Laminador', N'PLD01', N'CFG_001', N'Operativo', N'10 mm', N'30 mm', N'3', N'37', N'50', N'45', N'04:00')
INSERT [dbo].[Maquina] ([Id], [Descripcion], [Tipo], [PLD], [Configuracion], [Estado], [ReduacionInicio], [ReduacionFin], [CantidadRodillos], [MaximoFrio], [MaximoCaliente], [PorcentajeFalla], [Tiempo]) VALUES (2, N'Maquina 02', N'Laminador', N'PLD02', N'CFG_002', N'Operativo', N'20 mm', N'40 mm', N'4', N'37', N'50', N'50', N'06:00')
INSERT [dbo].[Maquina] ([Id], [Descripcion], [Tipo], [PLD], [Configuracion], [Estado], [ReduacionInicio], [ReduacionFin], [CantidadRodillos], [MaximoFrio], [MaximoCaliente], [PorcentajeFalla], [Tiempo]) VALUES (3, N'Maquina 03', N'Conformado', N'PLD03', N'CFG_003', N'Operativo', N'30 mm', N'50 mm', N'5', N'38', N'60', N'20', N'08:00')
INSERT [dbo].[Maquina] ([Id], [Descripcion], [Tipo], [PLD], [Configuracion], [Estado], [ReduacionInicio], [ReduacionFin], [CantidadRodillos], [MaximoFrio], [MaximoCaliente], [PorcentajeFalla], [Tiempo]) VALUES (4, N'Maquina 04', N'Cizador', N'PLD04', N'CFG_004', N'Operativo', N'40 mm', N'60 mm', N'6', N'39', N'65', N'30', N'09:00')
SET IDENTITY_INSERT [dbo].[Maquina] OFF
SET IDENTITY_INSERT [dbo].[Material] ON 

INSERT [dbo].[Material] ([Id], [Descripcion], [Stock], [StockMinimo], [Reservado]) VALUES (1, N'Material 01', 1000, 300, 500)
INSERT [dbo].[Material] ([Id], [Descripcion], [Stock], [StockMinimo], [Reservado]) VALUES (2, N'Material 02', 500, 200, 100)
INSERT [dbo].[Material] ([Id], [Descripcion], [Stock], [StockMinimo], [Reservado]) VALUES (3, N'Material 03', 300, 100, 50)
SET IDENTITY_INSERT [dbo].[Material] OFF
SET IDENTITY_INSERT [dbo].[OrdenProduccion] ON 

INSERT [dbo].[OrdenProduccion] ([Id], [Numero], [IdOrdenVenta], [Estado], [CantidadProducto], [FechaCreacion]) VALUES (18, N'OP000018', 1, N'Pendiente', 300, CAST(0x0000A52E00DDF0E7 AS DateTime))
SET IDENTITY_INSERT [dbo].[OrdenProduccion] OFF
SET IDENTITY_INSERT [dbo].[OrdenProduccionMaterial] ON 

INSERT [dbo].[OrdenProduccionMaterial] ([Id], [IdOrdenProduccion], [IdMaterial], [Requerido], [Comprar]) VALUES (25, 18, 1, 10000, 10000)
INSERT [dbo].[OrdenProduccionMaterial] ([Id], [IdOrdenProduccion], [IdMaterial], [Requerido], [Comprar]) VALUES (26, 18, 2, 5000, 5000)
INSERT [dbo].[OrdenProduccionMaterial] ([Id], [IdOrdenProduccion], [IdMaterial], [Requerido], [Comprar]) VALUES (27, 18, 3, 4000, 4000)
SET IDENTITY_INSERT [dbo].[OrdenProduccionMaterial] OFF
SET IDENTITY_INSERT [dbo].[OrdenProduccionSecuencia] ON 

INSERT [dbo].[OrdenProduccionSecuencia] ([Id], [Secuencia], [IdOrdenProduccion], [IdMaquina], [FechaInicio], [FechaFin]) VALUES (15, 1, 18, 1, CAST(0x0000A5320020F580 AS DateTime), CAST(0x0000A5320062E080 AS DateTime))
INSERT [dbo].[OrdenProduccionSecuencia] ([Id], [Secuencia], [IdOrdenProduccion], [IdMaquina], [FechaInicio], [FechaFin]) VALUES (16, 2, 18, 2, CAST(0x0000A53700000000 AS DateTime), CAST(0x0000A5370062E080 AS DateTime))
SET IDENTITY_INSERT [dbo].[OrdenProduccionSecuencia] OFF
SET IDENTITY_INSERT [dbo].[OrdenVenta] ON 

INSERT [dbo].[OrdenVenta] ([Id], [Numero], [Cliente], [FechaEntrega], [Estado], [Cantidad], [IdProducto]) VALUES (1, N'OV0001', N'Cliente 1', CAST(0x0000A53900000000 AS DateTime), N'Programado', 1000, 1)
INSERT [dbo].[OrdenVenta] ([Id], [Numero], [Cliente], [FechaEntrega], [Estado], [Cantidad], [IdProducto]) VALUES (2, N'OV0002', N'Cliente 2', CAST(0x0000A53700000000 AS DateTime), N'Pendiente', 300, 1)
INSERT [dbo].[OrdenVenta] ([Id], [Numero], [Cliente], [FechaEntrega], [Estado], [Cantidad], [IdProducto]) VALUES (3, N'OV0003', N'Cliente 3', CAST(0x0000A53C00000000 AS DateTime), N'Pendiente', 500, 1)
INSERT [dbo].[OrdenVenta] ([Id], [Numero], [Cliente], [FechaEntrega], [Estado], [Cantidad], [IdProducto]) VALUES (4, N'OV0004', N'Cliente 4', CAST(0x0000A54100000000 AS DateTime), N'Pendiente', 600, 1)
SET IDENTITY_INSERT [dbo].[OrdenVenta] OFF
SET IDENTITY_INSERT [dbo].[Producto] ON 

INSERT [dbo].[Producto] ([Id], [Descripcion], [Stock], [StockMinimo]) VALUES (1, N'Producto 01', 1500, 800)
SET IDENTITY_INSERT [dbo].[Producto] OFF
INSERT [dbo].[ProductoMaterial] ([IdProducto], [IdMaterial], [Cantidad]) VALUES (1, 1, 10)
INSERT [dbo].[ProductoMaterial] ([IdProducto], [IdMaterial], [Cantidad]) VALUES (1, 2, 5)
INSERT [dbo].[ProductoMaterial] ([IdProducto], [IdMaterial], [Cantidad]) VALUES (1, 3, 4)
ALTER TABLE [dbo].[OrdenProduccion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenProduccion_OrdenVenta] FOREIGN KEY([IdOrdenVenta])
REFERENCES [dbo].[OrdenVenta] ([Id])
GO
ALTER TABLE [dbo].[OrdenProduccion] CHECK CONSTRAINT [FK_OrdenProduccion_OrdenVenta]
GO
ALTER TABLE [dbo].[OrdenProduccionMaterial]  WITH CHECK ADD  CONSTRAINT [FK_OrdenProduccionMaterial_Material] FOREIGN KEY([IdMaterial])
REFERENCES [dbo].[Material] ([Id])
GO
ALTER TABLE [dbo].[OrdenProduccionMaterial] CHECK CONSTRAINT [FK_OrdenProduccionMaterial_Material]
GO
ALTER TABLE [dbo].[OrdenProduccionMaterial]  WITH CHECK ADD  CONSTRAINT [FK_OrdenProduccionMaterial_OrdenProduccion] FOREIGN KEY([IdOrdenProduccion])
REFERENCES [dbo].[OrdenProduccion] ([Id])
GO
ALTER TABLE [dbo].[OrdenProduccionMaterial] CHECK CONSTRAINT [FK_OrdenProduccionMaterial_OrdenProduccion]
GO
ALTER TABLE [dbo].[OrdenProduccionSecuencia]  WITH CHECK ADD  CONSTRAINT [FK_OrdenProduccionSecuencia_Maquina] FOREIGN KEY([IdMaquina])
REFERENCES [dbo].[Maquina] ([Id])
GO
ALTER TABLE [dbo].[OrdenProduccionSecuencia] CHECK CONSTRAINT [FK_OrdenProduccionSecuencia_Maquina]
GO
ALTER TABLE [dbo].[OrdenProduccionSecuencia]  WITH CHECK ADD  CONSTRAINT [FK_OrdenProduccionSecuencia_OrdenProduccion] FOREIGN KEY([IdOrdenProduccion])
REFERENCES [dbo].[OrdenProduccion] ([Id])
GO
ALTER TABLE [dbo].[OrdenProduccionSecuencia] CHECK CONSTRAINT [FK_OrdenProduccionSecuencia_OrdenProduccion]
GO
ALTER TABLE [dbo].[OrdenVenta]  WITH CHECK ADD  CONSTRAINT [FK_OrdenVenta_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[OrdenVenta] CHECK CONSTRAINT [FK_OrdenVenta_Producto]
GO
ALTER TABLE [dbo].[ProductoMaterial]  WITH CHECK ADD  CONSTRAINT [FK_ProductoMaterial_Material] FOREIGN KEY([IdMaterial])
REFERENCES [dbo].[Material] ([Id])
GO
ALTER TABLE [dbo].[ProductoMaterial] CHECK CONSTRAINT [FK_ProductoMaterial_Material]
GO
ALTER TABLE [dbo].[ProductoMaterial]  WITH CHECK ADD  CONSTRAINT [FK_ProductoMaterial_Producto] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Producto] ([Id])
GO
ALTER TABLE [dbo].[ProductoMaterial] CHECK CONSTRAINT [FK_ProductoMaterial_Producto]
GO
