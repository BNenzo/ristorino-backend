USE ristorino;

------------------------------------------------------------ DROPS ------------------------------------------------------------ 

DROP TABLE IF EXISTS preferencias_reservas_restaurantes;
DROP TABLE IF EXISTS clicks_contenidos_restaurantes;
DROP TABLE IF EXISTS reservas_restaurantes;
DROP TABLE IF EXISTS zonas_turnos_sucursales_restaurantes;
DROP TABLE IF EXISTS idiomas_zonas_suc_restaurantes;
DROP TABLE IF EXISTS turnos_sucursales_restaurantes;
DROP TABLE IF EXISTS zonas_sucursales_restaurantes;
DROP TABLE IF EXISTS contenidos_restaurantes; 
DROP TABLE IF EXISTS preferencias_restaurantes;
DROP TABLE IF EXISTS preferencias_clientes;
DROP TABLE IF EXISTS idiomas_dominio_cat_preferencias; 
DROP TABLE IF EXISTS idiomas_categorias_preferencias;
DROP TABLE IF EXISTS idiomas_estados;
DROP TABLE IF EXISTS configuracion_restaurantes;
DROP TABLE IF EXISTS sucursales_restaurantes;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS localidades;
DROP TABLE IF EXISTS dominio_categorias_preferencias;
DROP TABLE IF EXISTS categorias_preferencias;
DROP TABLE IF EXISTS atributos;
DROP TABLE IF EXISTS estados_reservas;
DROP TABLE IF EXISTS idiomas;
DROP TABLE IF EXISTS provincias;
DROP TABLE IF EXISTS restaurantes;
DROP TABLE IF EXISTS costos;


------------------------------------------------------------ COSTOS ------------------------------------------------------------ 

CREATE TABLE costos (
    tipo_costo VARCHAR(50) NOT NULL,
    fecha_ini_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL
    PRIMARY KEY (tipo_costo, fecha_ini_vigencia)
);

INSERT INTO costos (tipo_costo, fecha_ini_vigencia, fecha_fin_vigencia, monto)
VALUES
('click', '2026-01-01', '2027-01-01', 2000),
('reserva', '2026-01-01', '2027-01-01', 3000),
('contenido', '2026-01-01', '2027-01-01', 5000);



------------------------------------------------------------ CATEGORIAS_PREFERENCIAS ------------------------------------------------------------ 

CREATE TABLE categorias_preferencias (
    cod_categoria VARCHAR(30) PRIMARY KEY,
    nom_categoria VARCHAR(100) NOT NULL
);

INSERT INTO categorias_preferencias (cod_categoria, nom_categoria) VALUES
('tc', 'Tipo de cocina'),
('ea', 'Especialidad alimentaria'),
('est', 'Estilo'),
('cp', 'Categoria Precio');

------------------------------------------------------------ DOMINIO_CATEGORIAS_PREFERENCIAS ------------------------------------------------------------ 

CREATE TABLE dominio_categorias_preferencias (
    cod_categoria VARCHAR(30) NOT NULL,
    nro_valor_dominio INT NOT NULL,
    nom_valor_dominio VARCHAR(100) NOT NULL,
    PRIMARY KEY (cod_categoria, nro_valor_dominio),
    FOREIGN KEY (cod_categoria) REFERENCES categorias_preferencias(cod_categoria)
);

INSERT INTO dominio_categorias_preferencias (cod_categoria, nro_valor_dominio, nom_valor_dominio) VALUES

-- =========================
-- Tipo de cocina (tc)
-- =========================
('tc', 1, 'Italiana'),
('tc', 2, 'Mexicana'),
('tc', 3, 'Española'),
('tc', 4, 'Francesa'),
('tc', 5, 'Japonesa'),
('tc', 6, 'China'),
('tc', 7, 'Tailandesa'),
('tc', 8, 'India'),
('tc', 9, 'Mediterránea'),
('tc', 10, 'Argentina'),
('tc', 11, 'Peruana'),
('tc', 12, 'Árabe / Medio Oriente'),
('tc', 13, 'Americana'),
('tc', 14, 'Fusión'),
('tc', 15, 'Internacional'),

-- =========================
-- Especialidades alimentarias (ea)
-- =========================
('ea', 1, 'Vegetariana'),
('ea', 2, 'Vegana'),
('ea', 3, 'Sin gluten / Celíaco'),
('ea', 4, 'Sin lactosa'),
('ea', 5, 'Baja en calorías'),
('ea', 6, 'Orgánica'),
('ea', 7, 'Diabéticos (sin azúcar añadida)'),

-- =========================
-- Estilos (est)
-- =========================
('est', 1, 'Gourmet'),
('est', 2, 'Casual'),
('est', 3, 'Comida rápida / Fast food'),
('est', 4, 'Buffet libre'),
('est', 5, 'Bistró'),
('est', 6, 'Food truck'),
('est', 7, 'Restaurante tradicional'),
('est', 8, 'Bar / Tapas'),
('est', 9, 'Cafetería'),
('est', 10, 'Delivery'),
('est', 11, 'Fine dining'),

-- =========================
-- Categorías de precios (pre)
-- =========================
('cp', 1, 'Económico/Bajo'),
('cp', 2, 'Medio'),
('cp', 3, 'Alto/Premium'),
('cp', 4, 'De lujo');



------------------------------------------------------------ RESTAURANTES ------------------------------------------------------------ 
CREATE TABLE restaurantes (
    nro_restaurante INT PRIMARY KEY,
    razon_social VARCHAR(150) NOT NULL,
    cuit CHAR(11) UNIQUE NOT NULL,
    icono_src VARCHAR(300) NOT NULL,
);

INSERT INTO restaurantes VALUES (1, 'La Bella Pizza', '30717101975', 'https://pedidosya.dhmedia.io/image/pedidosya/restaurants/0758a0aa-51df-40f6-88b1-8cfe1fe1fb4e.jpg?quality=100');
INSERT INTO restaurantes VALUES (2, 'Perukai', '20999999222', 'https://pedidosya.dhmedia.io/image/pedidosya/restaurants/sabores-del-peru.jpg?quality=100');
-- INSERT INTO restaurantes VALUES (3, 'La Fabrica Burger', '30999999333', 'https://pedidosya.dhmedia.io/image/pedidosya/restaurants/eb900313-c34b-4e09-98ff-51f934b209f7.jpg?quality=100');
-- INSERT INTO restaurantes VALUES (4, 'Sabores del Norte', '40999999444');


------------------------------------------------------------ ATRIBUTOS ------------------------------------------------------------ 

CREATE TABLE atributos (
    cod_atributo VARCHAR(30) PRIMARY KEY,
    nom_atributo VARCHAR(100) NOT NULL,
    tipo_dato VARCHAR(20) NOT NULL  -- 'int','decimal','bool','string','json','date','time'
);

INSERT INTO atributos (cod_atributo, nom_atributo, tipo_dato) VALUES
('api_base','apiBase','string'),
('service_name','serviceName','string'),
('port_name','portName','string'),
('namespace','namespace','string'),
('backend_type', 'backendType', 'string'),
('prefix', 'prefix', 'string'),
('soap_username', 'soapUsername', 'string'),
('soap_password', 'soapPassword', 'string'),
('rest_secret_key', 'restSecretKey', 'string');

------------------------------------------------------------ CONFIGURACION_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE configuracion_restaurantes (
    nro_restaurante INT NOT NULL,
    cod_atributo VARCHAR(30) NOT NULL,
    valor VARCHAR(255) NOT NULL,
    PRIMARY KEY (nro_restaurante, cod_atributo),
    FOREIGN KEY (nro_restaurante) REFERENCES restaurantes(nro_restaurante),
    FOREIGN KEY (cod_atributo) REFERENCES atributos(cod_atributo)
);

INSERT INTO configuracion_restaurantes (nro_restaurante, cod_atributo, valor) VALUES
(1, 'api_base', 'http://localhost:8086/api/v1/la-bella-pizza'),
(1, 'backend_type', 'REST'),
(1, 'prefix', 'LBP'),
(1, 'rest_secret_key', 'Ristorino2024SecretKeyDAS12345!!'),
(2, 'api_base', 'http://localhost:8087/services/perukai.wsdl'),
(2, 'service_name', 'PerukaiWSPortService'),
(2, 'port_name', 'PerukaiWSPortSoap11'),
(2, 'namespace', 'http://services.perukai.das.ubp.edu.ar/'),
(2, 'backend_type', 'SOAP'),
(2, 'prefix', 'PK'),
(2, 'soap_username','usr_admin'),
(2, 'soap_password','pwd_admin');

------------------------------------------------------------ PROVINCIAS ------------------------------------------------------------ 
CREATE TABLE provincias (
    cod_provincia CHAR(5) PRIMARY KEY,
    nom_provincia VARCHAR(100) NOT NULL
);

INSERT INTO provincias (cod_provincia, nom_provincia) VALUES
('BSAS','Buenos Aires'),
('CAT','Catamarca'),
('CHA','Chaco'),
('CHU','Chubut'),
('CBA','Córdoba'),
('COR','Corrientes'),
('ER','Entre Ríos'),
('FOR','Formosa'),
('JUJ','Jujuy'),
('LP','La Pampa'),
('LR','La Rioja'),
('MEN','Mendoza'),
('MIS','Misiones'),
('NEU','Neuquén'),
('RN','Río Negro'),
('SAL','Salta'),
('SJ','San Juan'),
('SL','San Luis'),
('SC','Santa Cruz'),
('SF','Santa Fe'),
('SE','Santiago del Estero'),
('TF','Tierra del Fuego'),
('TUC','Tucumán'),
('CABA','Ciudad Autónoma de Buenos Aires');

------------------------------------------------------------ LOCALIDADES ------------------------------------------------------------ 
CREATE TABLE localidades (
    nro_localidad INT PRIMARY KEY,
    nom_localidad VARCHAR(100) NOT NULL,
    cod_provincia CHAR(5) NOT NULL,
    FOREIGN KEY (cod_provincia) REFERENCES provincias(cod_provincia)
);

INSERT INTO localidades (nro_localidad, nom_localidad, cod_provincia) VALUES
(1,'Córdoba Capital','CBA'),(2,'Villa Carlos Paz','CBA'),(3,'Río Cuarto','CBA'),
(4,'Villa María','CBA'),(5,'Alta Gracia','CBA'),(6,'Jesús María','CBA'),
(7,'La Falda','CBA'),(8,'Cosquín','CBA'),(9,'Río Tercero','CBA'),(10,'San Francisco','CBA');

------------------------------------------------------------ CLIENTES ------------------------------------------------------------ 

CREATE TABLE clientes (
    nro_cliente INT IDENTITY(1,1) PRIMARY KEY,
    apellido VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    dni INT,
    clave VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE NOT NULL,
    telefonos VARCHAR(50),
    nro_localidad INT NOT NULL,
    habilitado BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (nro_localidad) REFERENCES localidades(nro_localidad)
);

------------------------------------------------------------ PREFERENCIAS_CLIENTES ------------------------------------------------------------ 

CREATE TABLE preferencias_clientes (
    nro_cliente INT NOT NULL,
    cod_categoria VARCHAR(30) NOT NULL,
    nro_valor_dominio INT NOT NULL,
    observaciones VARCHAR(255),
    PRIMARY KEY (nro_cliente, cod_categoria, nro_valor_dominio),
    FOREIGN KEY (nro_cliente) REFERENCES clientes(nro_cliente),
    FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES dominio_categorias_preferencias(cod_categoria, nro_valor_dominio)
);

------------------------------------------------------------ ESTADOS_RESERVAS ------------------------------------------------------------ 

CREATE TABLE estados_reservas (
    cod_estado VARCHAR(30) PRIMARY KEY,
    nom_estado VARCHAR(100) NOT NULL
);

INSERT INTO estados_reservas (cod_estado, nom_estado) VALUES
('PEN','Pendiente'),('CONF','Confirmada'),('CAN','Cancelada'),('COMP','Completada');

------------------------------------------------------------ IDIOMAS ------------------------------------------------------------ 

CREATE TABLE idiomas (
    nro_idioma INT PRIMARY KEY,
    nom_idioma VARCHAR(100) NOT NULL,
    cod_idioma VARCHAR(10) UNIQUE NOT NULL
);

INSERT INTO idiomas (nro_idioma, nom_idioma, cod_idioma) VALUES
(1,'Español','es'),(2,'Inglés','en');

------------------------------------------------------------ IDIOMAS_ESTADOS ------------------------------------------------------------ 

CREATE TABLE idiomas_estados (
    cod_estado VARCHAR(30) NOT NULL,
    nro_idioma INT NOT NULL,
    estado VARCHAR(100) NOT NULL,
    PRIMARY KEY (cod_estado, nro_idioma),
    FOREIGN KEY (cod_estado) REFERENCES estados_reservas(cod_estado),
    FOREIGN KEY (nro_idioma) REFERENCES idiomas(nro_idioma)
);

INSERT INTO idiomas_estados (cod_estado, nro_idioma, estado) VALUES
('PEN',1,'Pendiente'),
('PEN',2,'Pending'),

('CONF',1,'Confirmada'),
('CONF',2,'Confirmed'),

('CAN',1,'Cancelada'),
('CAN',2,'Canceled'),

('COMP',1,'Completada'),
('COMP',2,'Completed');

------------------------------------------------------------ IDIOMAS_DOMINIO_CAT_PREFERENCIAS ------------------------------------------------------------ 

CREATE TABLE idiomas_dominio_cat_preferencias (
    cod_categoria VARCHAR(30) NOT NULL,
    nro_valor_dominio INT NOT NULL,
    nro_idioma INT NOT NULL,
    valor_dominio VARCHAR(100) NOT NULL,
    desc_valor_dominio VARCHAR(255),
    PRIMARY KEY (cod_categoria, nro_valor_dominio, nro_idioma),
    FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES dominio_categorias_preferencias(cod_categoria, nro_valor_dominio),
    FOREIGN KEY (nro_idioma) REFERENCES idiomas(nro_idioma)
);


INSERT INTO idiomas_dominio_cat_preferencias
(cod_categoria, nro_valor_dominio, nro_idioma, valor_dominio, desc_valor_dominio) VALUES

-- =========================
-- Tipo de cocina (tc)
-- =========================
('tc',1,1,'Italiana',NULL),
('tc',1,2,'Italian',NULL),

('tc',2,1,'Mexicana',NULL),
('tc',2,2,'Mexican',NULL),

('tc',3,1,'Española',NULL),
('tc',3,2,'Spanish',NULL),

('tc',4,1,'Francesa',NULL),
('tc',4,2,'French',NULL),

('tc',5,1,'Japonesa',NULL),
('tc',5,2,'Japanese',NULL),

('tc',6,1,'China',NULL),
('tc',6,2,'Chinese',NULL),

('tc',7,1,'Tailandesa',NULL),
('tc',7,2,'Thai',NULL),

('tc',8,1,'India',NULL),
('tc',8,2,'Indian',NULL),

('tc',9,1,'Mediterránea',NULL),
('tc',9,2,'Mediterranean',NULL),

('tc',10,1,'Argentina',NULL),
('tc',10,2,'Argentinian',NULL),

('tc',11,1,'Peruana',NULL),
('tc',11,2,'Peruvian',NULL),

('tc',12,1,'Árabe / Medio Oriente',NULL),
('tc',12,2,'Arab / Middle Eastern',NULL),

('tc',13,1,'Americana',NULL),
('tc',13,2,'American',NULL),

('tc',14,1,'Fusión',NULL),
('tc',14,2,'Fusion',NULL),

('tc',15,1,'Internacional',NULL),
('tc',15,2,'International',NULL),

-- =========================
-- Especialidades alimentarias (ea)
-- =========================
('ea',1,1,'Vegetariana',NULL),
('ea',1,2,'Vegetarian',NULL),

('ea',2,1,'Vegana',NULL),
('ea',2,2,'Vegan',NULL),

('ea',3,1,'Sin gluten / Celíaco',NULL),
('ea',3,2,'Gluten-free / Celiac',NULL),

('ea',4,1,'Sin lactosa',NULL),
('ea',4,2,'Lactose-free',NULL),

('ea',5,1,'Baja en calorías',NULL),
('ea',5,2,'Low-calorie',NULL),

('ea',6,1,'Orgánica',NULL),
('ea',6,2,'Organic',NULL),

('ea',7,1,'Diabéticos (sin azúcar añadida)',NULL),
('ea',7,2,'Diabetic-friendly (no added sugar)',NULL),

-- =========================
-- Estilos (est)
-- =========================
('est',1,1,'Gourmet',NULL),
('est',1,2,'Gourmet',NULL),

('est',2,1,'Casual',NULL),
('est',2,2,'Casual',NULL),

('est',3,1,'Comida rápida / Fast food',NULL),
('est',3,2,'Fast food',NULL),

('est',4,1,'Buffet libre',NULL),
('est',4,2,'All-you-can-eat buffet',NULL),

('est',5,1,'Bistró',NULL),
('est',5,2,'Bistro',NULL),

('est',6,1,'Food truck',NULL),
('est',6,2,'Food truck',NULL),

('est',7,1,'Restaurante tradicional',NULL),
('est',7,2,'Traditional restaurant',NULL),

('est',8,1,'Bar / Tapas',NULL),
('est',8,2,'Bar / Tapas',NULL),

('est',9,1,'Cafetería',NULL),
('est',9,2,'Cafe',NULL),

('est',10,1,'Delivery',NULL),
('est',10,2,'Delivery',NULL),

('est',11,1,'Fine dining',NULL),
('est',11,2,'Fine dining',NULL),

-- =========================
-- Categorías de precios (cp)
-- =========================
('cp',1,1,'Económico/Bajo',NULL),
('cp',1,2,'Budget / Low',NULL),

('cp',2,1,'Medio',NULL),
('cp',2,2,'Mid-range',NULL),

('cp',3,1,'Alto/Premium',NULL),
('cp',3,2,'High / Premium',NULL),

('cp',4,1,'De lujo',NULL),
('cp',4,2,'Luxury',NULL);



------------------------------------------------------------ IDIOMAS_CATEGORIAS_PREFERENCIAS ------------------------------------------------------------ 

CREATE TABLE idiomas_categorias_preferencias (
    cod_categoria VARCHAR(30) NOT NULL,
    nro_idioma INT NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    desc_categoria VARCHAR(255),
    PRIMARY KEY (cod_categoria, nro_idioma),
    FOREIGN KEY (cod_categoria) REFERENCES categorias_preferencias(cod_categoria),
    FOREIGN KEY (nro_idioma) REFERENCES idiomas(nro_idioma)
);

INSERT INTO idiomas_categorias_preferencias
(cod_categoria, nro_idioma, categoria, desc_categoria) VALUES
-- Tipo de cocina
('tc',1,'Tipo de cocina','Clasifica el tipo de cocina del restaurante'),
('tc',2,'Type of cuisine','Classifies the type of cuisine of the restaurant'),

-- Especialidades alimentarias
('ea',1,'Especialidades alimentarias','Indica si el restaurante ofrece opciones según preferencias o restricciones alimentarias'),
('ea',2,'Dietary options','Indicates whether the restaurant offers options for dietary preferences or restrictions'),

-- Estilos
('est',1,'Estilo','Describe el estilo o formato del restaurante (casual, gourmet, etc.)'),
('est',2,'Style','Describes the restaurant style or format (casual, gourmet, etc.)'),

-- Categorías de precios
('cp',1,'Categoría de precios','Estima el nivel de gasto en el restaurante (barato, medio, caro, etc.)'),
('cp',2,'Price range','Estimates the expected spending level at the restaurant (low, medium, high, etc.)');



------------------------------------------------------------ SUCURSALES_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE sucursales_restaurantes (
    nro_restaurante INT NOT NULL,
    nro_sucursal INT NOT NULL,
    nom_sucursal VARCHAR(100) NOT NULL,
    calle VARCHAR(100) NOT NULL,
    nro_calle INT NULL,
    barrio VARCHAR(100) NULL,
    nro_localidad INT NOT NULL,
    cod_postal VARCHAR(10) NULL,
    telefonos VARCHAR(50) NULL,
    total_comensales INT NULL,
    min_tolerancia_reserva INT NULL,
    cod_sucursal_restaurante  VARCHAR(30) NOT NULL,
    PRIMARY KEY (nro_restaurante, nro_sucursal),
    FOREIGN KEY (nro_restaurante) REFERENCES restaurantes(nro_restaurante),
    FOREIGN KEY (nro_localidad) REFERENCES localidades(nro_localidad),
);

INSERT INTO sucursales_restaurantes VALUES
(1,1,'La Bella Pizza Alta Córdoba','Juan Antonio Lavalleja',2344,'Alta Córdoba',1,'5001','03512317731',50,15,'LBP-001'),
(1,2,'La Bella Pizza General Paz','Jacinto Ríos',170,'General Paz',1,'5004','03515388931',30,12,'LBP-002'),

(2,1,'Perukai Nueva Córdoba','Hipólito Yrigoyen',500,'Nueva Córdoba',1,'5000','0351-4000001',50,10,'PK-001'),
(2,2,'Perukai Güemes','Belgrano',700,'Güemes',1,'5000','0351-4000002',45,10,'PK-002');

-- Restaurante 3, descomentar despues
-- (3,1,'La Fabrica Burger Cerro','Rafael Nuñez',4000,'Cerro de las Rosas',1,'5004','03515377931',60,10,'LFB-001');



------------------------------------------------------------ ZONAS_SUCURSALES_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE zonas_sucursales_restaurantes (
    nro_restaurante INT NOT NULL,
    nro_sucursal INT NOT NULL,
    cod_zona VARCHAR(15) NOT NULL,
    desc_zona VARCHAR(100),
    cant_comensales INT NOT NULL,
    permite_menores INT NOT NULL,
    habilitada INT NOT NULL,
    PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona),
    FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES sucursales_restaurantes (nro_restaurante, nro_sucursal)
);

INSERT INTO zonas_sucursales_restaurantes VALUES
(1,1,'barra','Zona para aperitivos y comidas rápidas',10,0,1),
(1,1,'salon','Zona principal con servicio de mesa',20,1,1),
(1,1,'patio','Zona exterior con servicio de mesa y area para fumadores',20,1,1),
(1,2,'barra','Zona para aperitivos y comidas rápidas',10,0,1),
(1,2,'salon','Zona principal con servicio de mesa',10,1,1),
(1,2,'patio','Zona exterior con servicio de mesa y area para fumadores',10,1,1),

(2,1,'barra','Zona para aperitivos y comidas rápidas',10,0,1),
(2,1,'salon','Zona principal con servicio de mesa',20,1,1),
(2,1,'patio','Zona exterior con servicio de mesa y area para fumadores',20,1,1),
(2,2,'barra','Zona para aperitivos y comidas rápidas',5,0,1),
(2,2,'salon','Zona principal con servicio de mesa',20,1,1),
(2,2,'patio','Zona exterior con servicio de mesa y area para fumadores',20,1,1);




------------------------------------------------------------ TURNOS_SUCURSALES_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE turnos_sucursales_restaurantes (
    nro_restaurante INT NOT NULL,
    nro_sucursal INT NOT NULL,
    hora_desde TIME NOT NULL,
    hora_hasta TIME NOT NULL,
    habilitado BIT NOT NULL DEFAULT 1,
    PRIMARY KEY (nro_restaurante, nro_sucursal, hora_desde),
    FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES sucursales_restaurantes(nro_restaurante, nro_sucursal)
);

INSERT INTO turnos_sucursales_restaurantes
(nro_restaurante, nro_sucursal, hora_desde, hora_hasta, habilitado) VALUES
(1,1,'12:00','13:00',1),
(1,1,'13:00','14:00',1),
(1,1,'15:00','16:00',1),
(1,1,'20:00','21:00',1),
(1,1,'21:00','22:00',1),
(1,1,'22:00','23:00',1),

(1,2,'12:00','13:00',1),
(1,2,'20:00','21:00',0),

(2,1,'13:00','14:00',1),
(2,1,'21:00','22:00',1),

(2,2,'12:00','14:00',1),
(2,2,'20:00','22:30',1);

-- (3,1,'12:00','13:30',1),
-- (3,1,'13:30','14:30',1),
-- (3,1,'20:00','21:30',1),
-- (3,1,'21:30','22:30',1);

------------------------------------------------------------ ZONAS_TURNOS_SUCURSALES_RESTAURANTES ------------------------------------------------------------ 

-- Podemos llenarla despues
CREATE TABLE zonas_turnos_sucursales_restaurantes (
    nro_restaurante INT NOT NULL,
    nro_sucursal INT NOT NULL,
    cod_zona VARCHAR(15) NOT NULL,
    hora_desde TIME NOT NULL,
    permite_menores INT NOT NULL DEFAULT 1,
    PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona, hora_desde),
    FOREIGN KEY (nro_restaurante, nro_sucursal, hora_desde)
        REFERENCES turnos_sucursales_restaurantes (nro_restaurante, nro_sucursal, hora_desde),
    FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES zonas_sucursales_restaurantes (nro_restaurante, nro_sucursal, cod_zona)
);

INSERT INTO zonas_turnos_sucursales_restaurantes VALUES
(1,1,'barra','12:00',0),
(1,1,'barra','13:00',0),
(1,1,'barra','15:00',0),
(1,1,'barra','20:00',0),
(1,1,'barra','21:00',0),
(1,1,'barra','22:00',0),

(1,1,'salon','12:00',1),
(1,1,'salon','13:00',1),
(1,1,'salon','15:00',1),
(1,1,'salon','20:00',1),
(1,1,'salon','21:00',1),
(1,1,'salon','22:00',1),

(1,1,'patio','12:00',1),
(1,1,'patio','13:00',1),
(1,1,'patio','15:00',1),
(1,1,'patio','20:00',1),
(1,1,'patio','21:00',1),
(1,1,'patio','22:00',1),

(1,2,'barra','12:00',0),
(1,2,'barra','20:00',0),

(1,2,'salon','12:00',1),
(1,2,'salon','20:00',1),

(1,2,'patio','12:00',1),
(1,2,'patio','20:00',1),

(2,1,'barra','13:00',0),
(2,1,'barra','21:00',0),

(2,1,'salon','13:00',1),
(2,1,'salon','21:00',1),

(2,1,'patio','13:00',1),
(2,1,'patio','21:00',1),

(2,2,'barra','12:00',0),
(2,2,'barra','20:00',0),

(2,2,'salon','12:00',0),
(2,2,'salon','20:00',0),

(2,2,'patio','12:00',0),
(2,2,'patio','20:00',0);

------------------------------------------------------------ IDIOMAS_ZONAS_SUC_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE idiomas_zonas_suc_restaurantes (
    nro_restaurante INT NOT NULL,
    nro_sucursal INT NOT NULL,
    cod_zona VARCHAR(15) NOT NULL,
    nro_idioma INT NOT NULL,
    zona VARCHAR(100) NOT NULL,
    desc_zona VARCHAR(255),
    PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona, nro_idioma),
    FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES zonas_sucursales_restaurantes (nro_restaurante, nro_sucursal, cod_zona),
    FOREIGN KEY (nro_idioma) REFERENCES idiomas(nro_idioma)
);


INSERT INTO idiomas_zonas_suc_restaurantes
(nro_restaurante, nro_sucursal, cod_zona, nro_idioma, zona, desc_zona) VALUES
(1,1,'barra',1,'Barra','Zona para aperitivos y comidas rápidas'),
(1,1,'salon',1,'Salon','Zona principal con servicio de mesa'),
(1,1,'patio',1,'Patio','Zona exterior con servicio de mesa y area para fumadores'),
(1,1,'barra',2,'Bar','Area for appetizers and quick meals'),
(1,1,'salon',2,'Main dining area','Main dining area with table service'),
(1,1,'patio',2,'Outdoor dining area','Outdoor area with table service and smoking area'),

(1,2,'barra',1,'Barra','Zona para aperitivos y comidas rápidas'),
(1,2,'salon',1,'Salon','Zona principal con servicio de mesa'),
(1,2,'patio',1,'Patio','Zona exterior con servicio de mesa y area para fumadores'),
(1,2,'barra',2,'Bar','Area for appetizers and quick meals'),
(1,2,'salon',2,'Main dining area','Main dining area with table service'),
(1,2,'patio',2,'Outdoor dining area','Outdoor area with table service and smoking area'),

(2,1,'barra',1,'Barra','Zona para aperitivos y comidas rápidas'),
(2,1,'salon',1,'Salon','Zona principal con servicio de mesa'),
(2,1,'patio',1,'Patio','Zona exterior con servicio de mesa y area para fumadores'),
(2,1,'barra',2,'Bar','Area for appetizers and quick meals'),
(2,1,'salon',2,'Main dining area','Main dining area with table service'),
(2,1,'patio',2,'Outdoor dining area','Outdoor area with table service and smoking area'),

(2,2,'barra',1,'Barra','Zona para aperitivos y comidas rápidas'),
(2,2,'salon',1,'Salon','Zona principal con servicio de mesa'),
(2,2,'patio',1,'Patio','Zona exterior con servicio de mesa y area para fumadores'),
(2,2,'barra',2,'Bar','Area for appetizers and quick meals'),
(2,2,'salon',2,'Main dining area','Main dining area with table service'),
(2,2,'patio',2,'Outdoor dining area','Outdoor area with table service and smoking area');

------------------------------------------------------------ PREFERENCIAS_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE preferencias_restaurantes (
    nro_restaurante INT NOT NULL,
    cod_categoria VARCHAR(30) NOT NULL,
    nro_valor_dominio INT NOT NULL,
    nro_preferencia INT NOT NULL,
    observaciones VARCHAR(255),
    nro_sucursal INT NULL,
    PRIMARY KEY (nro_restaurante, cod_categoria, nro_valor_dominio, nro_preferencia),
    FOREIGN KEY (nro_restaurante) REFERENCES restaurantes(nro_restaurante),
    FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES dominio_categorias_preferencias(cod_categoria, nro_valor_dominio),
    FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES sucursales_restaurantes(nro_restaurante, nro_sucursal)
);

INSERT INTO preferencias_restaurantes
(nro_restaurante, nro_sucursal,cod_categoria, nro_valor_dominio, nro_preferencia, observaciones) VALUES
(1,1,'tc',1,1,'Especializada en pizzas'),
(1,1,'cp',1,2,'Costo medio'),
(1,1,'est',2,3,'Casual'),
(1,1,'est',3,4,'Comida Rapida'),
(1,1,'ea',1,5,'Vegetariana'),
(1,1,'ea',3,6,'Celiacos'),

(1,2,'tc',1,7,'Especializada en pizzas'),
(1,2,'cp',1,8,'Costo medio'),
(1,2,'est',2,9,'Casual'),
(1,2,'est',3,10,'Comida Rapida'),
(1,2,'ea',1,11,'Vegetariana'),
(1,2,'ea',3,12,'Celiacos'),

(2,1,'tc',11,13,'Especializada en ceviche'),
(2,1,'ea',1,14,'Vegetariana'),
(2,1,'est',1,15,'Gourmet'),
(2,1,'cp',3,16,'Alto/Premium'),


(2,2,'tc',11,17,'Especializada en ceviche'),
(2,2,'ea',1,18,'Vegetariana'),
(2,2,'est',1,19,'Gourmet'),
(2,2,'cp',3,20,'Alto/Premium');


-- (3,1, 'tc',13,21,'Especializada en hamburguesas'),
-- (3,1, 'tc',13,22,'Focus on burgers');


------------------------------------------------------------ CONTENIDOS_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE contenidos_restaurantes (
    nro_restaurante INT NOT NULL,
    nro_idioma INT NOT NULL,
    nro_contenido INT NOT NULL,
    nro_sucursal INT NULL,
    contenido_promocional NVARCHAR(255),
    imagen_promocional VARCHAR(255),
    contenido_a_publicar NVARCHAR(MAX) NOT NULL,
    fecha_ini_vigencia DATE NOT NULL,
    fecha_fin_vigencia DATE NOT NULL,
    costo_click DECIMAL(10,2) NOT NULL DEFAULT 0,
    cod_contenido_restaurante VARCHAR(255), -- LBP-1-1 {nroSucursal}-{nroContenido}
    
    PRIMARY KEY (nro_restaurante, nro_contenido, nro_idioma),
    FOREIGN KEY (nro_restaurante) REFERENCES restaurantes (nro_restaurante),
    FOREIGN KEY (nro_idioma) REFERENCES idiomas (nro_idioma),
    FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES sucursales_restaurantes (nro_restaurante, nro_sucursal)
);

------------------------------------------------------------ CLICKS_CONTENIDOS_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE clicks_contenidos_restaurantes (
    nro_restaurante INT NOT NULL,
    nro_idioma INT NOT NULL,
    nro_contenido INT NOT NULL,
    nro_click INT NOT NULL,
    fecha_hora_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nro_cliente INT,
    costo_click DECIMAL(10,2) NOT NULL,
    notificado BIT DEFAULT 0,
    cod_contenido_restaurante VARCHAR(255),
    PRIMARY KEY (nro_restaurante, nro_idioma, nro_contenido, nro_click),
    FOREIGN KEY (nro_restaurante, nro_contenido, nro_idioma)
    REFERENCES contenidos_restaurantes(nro_restaurante, nro_contenido, nro_idioma),
    FOREIGN KEY (nro_cliente)
        REFERENCES clientes(nro_cliente)
);

------------------------------------------------------------ RESERVAS_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE reservas_restaurantes (
    nro_cliente INT NOT NULL,
    nro_reserva INT NOT NULL,
    fecha_hora_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_reserva DATE NOT NULL,
    nro_restaurante INT NOT NULL,
    nro_sucursal INT NOT NULL,
    cod_zona VARCHAR(15) NOT NULL,
    hora_reserva TIME NOT NULL,
    cant_adultos INT NOT NULL,
    cant_menores INT NOT NULL,
    cod_estado VARCHAR(30) NOT NULL,
    fecha_cancelacion DATE,
    costo_reserva DECIMAL(10,2),
    cod_reserva_sucursal VARCHAR(50) NOT NULL,
    PRIMARY KEY (nro_cliente, nro_reserva),
    FOREIGN KEY (nro_cliente) REFERENCES clientes(nro_cliente),
    FOREIGN KEY (nro_restaurante, nro_sucursal) REFERENCES sucursales_restaurantes(nro_restaurante, nro_sucursal),
    FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona) REFERENCES zonas_sucursales_restaurantes(nro_restaurante, nro_sucursal, cod_zona),
    FOREIGN KEY (nro_restaurante, nro_sucursal, hora_reserva) REFERENCES turnos_sucursales_restaurantes(nro_restaurante, nro_sucursal, hora_desde),
    FOREIGN KEY (cod_estado) REFERENCES estados_reservas(cod_estado)
);


------------------------------------------------------------ PREFERENCIAS_RESERVAS_RESTAURANTES ------------------------------------------------------------ 

CREATE TABLE preferencias_reservas_restaurantes (
    nro_cliente INT NOT NULL,
    nro_reserva INT NOT NULL,
    nro_restaurante INT NOT NULL,
    cod_categoria VARCHAR(30) NOT NULL,
    nro_valor_dominio INT NOT NULL,
    nro_preferencia INT NOT NULL,
    observaciones VARCHAR(255),
    PRIMARY KEY (
        nro_cliente, nro_reserva,
        nro_restaurante, cod_categoria, nro_valor_dominio, nro_preferencia
    ),
    FOREIGN KEY (nro_cliente, nro_reserva)
        REFERENCES reservas_restaurantes (nro_cliente, nro_reserva),
    FOREIGN KEY (nro_restaurante, cod_categoria, nro_valor_dominio, nro_preferencia)
        REFERENCES preferencias_restaurantes (nro_restaurante, cod_categoria, nro_valor_dominio, nro_preferencia)
);

IF OBJECT_ID('sp_get_provincias', 'P') IS NOT NULL
    DROP PROCEDURE sp_get_provincias;
GO

CREATE OR ALTER PROCEDURE sp_get_provincias
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        cod_provincia, 
        nom_provincia
    FROM provincias
    ORDER BY nom_provincia;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_promociones_contenidos
    @nro_restaurante INT = NULL,   -- filtro opcional
    @nro_sucursal    INT = NULL,   -- filtro opcional
    @nro_idioma      INT = NULL,   -- filtro opcional
    @solo_vigentes   BIT = 1,      -- 1 = solo vigentes
    @fecha_ref       DATE = NULL   -- si es NULL se usa GETDATE()
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha_ref IS NULL
        SET @fecha_ref = CONVERT(date, GETDATE());

    SELECT
        cr.nro_restaurante,
        r.razon_social,
        r.cuit,
        cr.nro_sucursal,
        sr.nom_sucursal,
        sr.calle,
        sr.nro_calle,
        sr.barrio,
        l.nom_localidad,
        p.nom_provincia,

        cr.nro_contenido,
        cr.nro_idioma,
        cr.cod_contenido_restaurante,
        cr.contenido_promocional,
        cr.imagen_promocional,
        cr.contenido_a_publicar,
        cr.fecha_ini_vigencia,
        cr.fecha_fin_vigencia,
        cr.costo_click,

        ISNULL(clk.total_clicks, 0)    AS total_clicks,
        ISNULL(clk.total_costo, 0.00)  AS total_costo_clicks,
        clk.ultima_interaccion
    FROM contenidos_restaurantes AS cr
    INNER JOIN restaurantes AS r
        ON r.nro_restaurante = cr.nro_restaurante
    LEFT JOIN sucursales_restaurantes AS sr
        ON sr.nro_restaurante = cr.nro_restaurante
       AND sr.nro_sucursal    = cr.nro_sucursal
    LEFT JOIN localidades AS l
        ON l.nro_localidad = sr.nro_localidad
    LEFT JOIN provincias AS p
        ON p.cod_provincia = l.cod_provincia
    LEFT JOIN (
        SELECT
            nro_restaurante,
            nro_idioma,
            nro_contenido,
            COUNT(*)                 AS total_clicks,
            SUM(costo_click)         AS total_costo,
            MAX(fecha_hora_registro) AS ultima_interaccion
        FROM clicks_contenidos_restaurantes
        GROUP BY nro_restaurante, nro_idioma, nro_contenido
    ) AS clk
        ON clk.nro_restaurante = cr.nro_restaurante
       AND clk.nro_idioma      = cr.nro_idioma
       AND clk.nro_contenido   = cr.nro_contenido
    WHERE
        (@nro_restaurante IS NULL OR cr.nro_restaurante = @nro_restaurante)
        AND (@nro_sucursal  IS NULL OR cr.nro_sucursal  = @nro_sucursal)
        AND (@nro_idioma    IS NULL OR cr.nro_idioma    = @nro_idioma)   -- NUEVO
        AND (
            @solo_vigentes = 0
            OR (@fecha_ref BETWEEN cr.fecha_ini_vigencia AND cr.fecha_fin_vigencia)
        )
    ORDER BY
        r.razon_social,
        sr.nom_sucursal,
        cr.fecha_ini_vigencia DESC,
        cr.nro_contenido;
END
GO


IF OBJECT_ID('dbo.sp_registrar_click_contenido', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_registrar_click_contenido;
GO

CREATE OR ALTER PROCEDURE dbo.sp_registrar_click_contenido
    @nro_restaurante       INT,
    @nro_idioma            INT,
    @nro_contenido         INT,
    @nro_cliente           INT = NULL,
    @costo_click           DECIMAL(10,2),
    @cod_contenido_restaurante VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;
        DECLARE @nro_click INT;

        -- 1) Validaciones básicas
        IF NOT EXISTS (
            SELECT 1
            FROM contenidos_restaurantes
            WHERE nro_restaurante = @nro_restaurante
              AND nro_idioma      = @nro_idioma
              AND nro_contenido   = @nro_contenido
        )
            THROW 50000, 'Contenido inexistente para los parámetros enviados.', 1;

        -- 2) Obtener nro_click siguiente con bloqueo para concurrencia
        SELECT
            @nro_click = ISNULL(MAX(ccr.nro_click), 0) + 1
        FROM clicks_contenidos_restaurantes AS ccr WITH (UPDLOCK, HOLDLOCK)
        WHERE ccr.nro_restaurante = @nro_restaurante
          AND ccr.nro_idioma      = @nro_idioma
          AND ccr.nro_contenido   = @nro_contenido;

        -- 3) Insertar
        INSERT INTO clicks_contenidos_restaurantes
            (nro_restaurante, nro_idioma, nro_contenido, nro_click,
             fecha_hora_registro, nro_cliente, costo_click, notificado, cod_contenido_restaurante)
        VALUES
            (@nro_restaurante, @nro_idioma, @nro_contenido, @nro_click,
             DEFAULT, @nro_cliente, @costo_click, 0, @cod_contenido_restaurante);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE(),
                @ErrSev INT = ERROR_SEVERITY(),
                @ErrSta INT = ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSev, @ErrSta);
    END CATCH
END
GO

-- DECLARE @nro_click INT;

-- Caso simple: usa costo del contenido y fecha actual, sin validar vigencia
-- EXEC dbo.sp_registrar_click_contenido
--      @nro_restaurante = 1,
--      @nro_idioma      = 1,
--      @nro_contenido   = 2,
--      @nro_cliente     = 1,
--      @costo_click     = NULL,
--      @fecha_hora_registro = NULL,
--      @validar_vigencia = 0,
--      @nro_click = @nro_click OUTPUT;

-- SELECT @nro_click AS nro_click_insertado;


-- SELECT * from clicks_contenidos_restaurantes;

IF OBJECT_ID('dbo.sp_get_clicks_no_notificados', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_get_clicks_no_notificados;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_clicks_no_notificados
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        nro_restaurante,
        nro_idioma,
        nro_contenido,
        nro_click,
        fecha_hora_registro,
        nro_cliente,
        costo_click,
        notificado,
        cod_contenido_restaurante
    FROM dbo.clicks_contenidos_restaurantes
    WHERE notificado = 0
    ORDER BY fecha_hora_registro DESC;
END
GO
-- EXEC dbo.sp_get_clicks_no_notificados;




IF OBJECT_ID('dbo.sp_set_click_notificado', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_set_click_notificado;
GO

CREATE OR ALTER PROCEDURE dbo.sp_set_click_notificado
    @nro_restaurante INT,
    @nro_idioma      INT,
    @nro_contenido   INT,
    @nro_click       INT,
    @notificado      BIT = 1          -- opcional: 1 por defecto
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE ccr WITH (ROWLOCK)
        SET notificado = @notificado
        FROM dbo.clicks_contenidos_restaurantes AS ccr
        WHERE ccr.nro_restaurante = @nro_restaurante
          AND ccr.nro_idioma      = @nro_idioma
          AND ccr.nro_contenido   = @nro_contenido
          AND ccr.nro_click       = @nro_click;

        IF @@ROWCOUNT = 0
            THROW 50010, 'No existe el registro con las claves provistas.', 1;

        SELECT  -- devuelve el estado final
            nro_restaurante, nro_idioma, nro_contenido, nro_click,
            fecha_hora_registro, nro_cliente, costo_click, notificado
        FROM dbo.clicks_contenidos_restaurantes
        WHERE nro_restaurante = @nro_restaurante
          AND nro_idioma      = @nro_idioma
          AND nro_contenido   = @nro_contenido
          AND nro_click       = @nro_click;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(),
                @ErrSev INT=ERROR_SEVERITY(),
                @ErrSta INT=ERROR_STATE();
        RAISERROR(@ErrMsg, @ErrSev, @ErrSta);
    END CATCH
END
GO

--datos de restaurante
IF OBJECT_ID('dbo.sp_get_datos_restaurante', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_get_datos_restaurante;
GO

CREATE PROCEDURE dbo.sp_get_datos_restaurante
    @nro_restaurante INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        razon_social AS nombre_restaurante,
        cuit
    FROM restaurantes
    WHERE nro_restaurante = @nro_restaurante;
END;
GO

--sucursales de restaurante
IF OBJECT_ID('dbo.sp_get_sucursales_restaurante', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_get_sucursales_restaurante;
GO

CREATE PROCEDURE sp_get_sucursales_restaurante
    @nro_restaurante INT
AS
BEGIN
    SELECT 
        sr.nro_sucursal AS nroSucursal,
        sr.nom_sucursal AS nombreSucursal,
        (sr.calle + ' ' + COALESCE(CAST(sr.nro_calle AS VARCHAR), '') 
         + ' ' + COALESCE(sr.barrio, '') 
         + ' ' + COALESCE(sr.cod_postal, '')) AS direccionCompleta,
        sr.telefonos,
        l.nom_localidad AS localidad,
        p.nom_provincia AS provincia
    FROM sucursales_restaurantes sr
    JOIN localidades l ON sr.nro_localidad = l.nro_localidad
    JOIN provincias p ON l.cod_provincia = p.cod_provincia
    WHERE sr.nro_restaurante = @nro_restaurante;
END
GO

--preferencias restaurante
IF OBJECT_ID('dbo.sp_get_preferencias_restaurante', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_get_preferencias_restaurante;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_preferencias_restaurante
    @nro_restaurante INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        pr.nro_restaurante,
        pr.cod_categoria,
        cp.nom_categoria,
        pr.nro_valor_dominio,
        dcp.nom_valor_dominio,
        pr.nro_preferencia,
        pr.observaciones,
        pr.nro_sucursal     -- puede venir NULL si aplica global
    FROM dbo.preferencias_restaurantes AS pr
    INNER JOIN dbo.dominio_categorias_preferencias AS dcp
        ON dcp.cod_categoria      = pr.cod_categoria
       AND dcp.nro_valor_dominio  = pr.nro_valor_dominio
    INNER JOIN dbo.categorias_preferencias AS cp
        ON cp.cod_categoria = pr.cod_categoria
    WHERE pr.nro_restaurante = @nro_restaurante
    ORDER BY
        pr.cod_categoria,
        pr.nro_preferencia,
        pr.nro_valor_dominio;
END
GO

-- Ejemplo de uso:
-- EXEC dbo.sp_get_preferencias_restaurante @nro_restaurante = 1;



-- EXEC dbo.sp_set_click_notificado
--     @nro_restaurante = 1,
--     @nro_idioma      = 1,
--     @nro_contenido   = 2,
--     @nro_click       = 1,   -- clave
--     @notificado      = 0;   -- opcional

-- SELECT ROUTINE_CATALOG, ROUTINE_SCHEMA, ROUTINE_NAME
-- FROM INFORMATION_SCHEMA.ROUTINES
-- WHERE ROUTINE_TYPE='PROCEDURE'
--   AND ROUTINE_CATALOG='ristorino'
--   AND ROUTINE_SCHEMA='dbo'
--   AND ROUTINE_NAME='sp_set_click_notificado';

-- PROCEDIMIENTO PARA INSERTAR UN NUEVO CLIENTE
IF OBJECT_ID('dbo.sp_insert_cliente', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_insert_cliente;
GO

CREATE OR ALTER PROCEDURE dbo.sp_insert_cliente
    @nro_cliente    INT,
    @apellido       VARCHAR(100),
    @nombre         VARCHAR(100),
    @clave          VARCHAR(100),
    @correo         VARCHAR(150),
    @telefonos      VARCHAR(50),
    @nro_localidad  INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF EXISTS (SELECT 1 FROM dbo.clientes WHERE correo = @correo)
            THROW 50001, 'El correo ya está registrado', 1;

        INSERT INTO dbo.clientes (
            nro_cliente,
            apellido,
            nombre,
            clave,
            correo,
            telefonos,
            nro_localidad,
            habilitado
        )
        VALUES (
            @nro_cliente,
            @apellido,
            @nombre,
            @clave,
            @correo,
            @telefonos,
            @nro_localidad,
            1
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO


CREATE OR ALTER PROCEDURE sp_get_configuration_by_restaurant_id
    @nro_restaurante INT
AS
BEGIN

    SELECT *
    FROM configuracion_restaurantes
    WHERE nro_restaurante = @nro_restaurante;
END;
GO


-- SELECT * from clicks_contenidos_restaurantes;

CREATE OR ALTER PROCEDURE sp_get_restaurantes_id
AS
BEGIN
    SET NOCOUNT ON;

    SELECT nro_restaurante
    FROM restaurantes
    WHERE nro_restaurante IN (1, 2);
END
GO

--INSERTAR CONTENIDOS NO PUBLICADOS OBTENIDOS DE LOS RESTAURANTES
CREATE OR ALTER PROCEDURE sp_insert_contenido_restaurante
(
  @nro_restaurante INT,
  @nro_idioma INT,
  @nro_contenido INT,
  @nro_sucursal INT = NULL,
  @contenido_promocional NVARCHAR(255) NULL,
  @imagen_promocional VARCHAR(255),
  @contenido_a_publicar NVARCHAR(MAX),
  @fecha_ini_vigencia DATE,
  @fecha_fin_vigencia DATE,
  @costo_click DECIMAL(10,2),
  @cod_contenido_restaurante VARCHAR(255)
)
AS
BEGIN
  INSERT INTO contenidos_restaurantes (
    nro_restaurante,
    nro_idioma,
    nro_contenido,
    nro_sucursal,
    contenido_promocional,
    imagen_promocional,
    contenido_a_publicar,
    fecha_ini_vigencia,
    fecha_fin_vigencia,
    costo_click,
    cod_contenido_restaurante
  )
  VALUES (
    @nro_restaurante,
    @nro_idioma,
    @nro_contenido,
    @nro_sucursal,
    @contenido_promocional,
    @imagen_promocional,
    @contenido_a_publicar,
    @fecha_ini_vigencia,
    @fecha_fin_vigencia,
    @costo_click,
    @cod_contenido_restaurante
  );
END
GO



IF OBJECT_ID('dbo.sp_get_contenidos_sin_contenido_IA', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_get_contenidos_sin_contenido_IA;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_contenidos_sin_contenido_IA
AS
BEGIN
SELECT * FROM contenidos_restaurantes;
    SELECT *
    FROM dbo.contenidos_restaurantes AS cr
    WHERE cr.contenido_promocional IS NULL
END
GO

IF OBJECT_ID('dbo.sp_get_idiomas', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_get_idiomas;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_idiomas
AS
BEGIN
    SELECT * FROM dbo.idiomas;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_insertar_o_actualizar_contenido_generado_con_ia
(
    @nro_restaurante INT,
    @nro_idioma INT,
    @nro_contenido INT,
    @nro_sucursal INT = NULL,
    @contenido_promocional NVARCHAR(255) = NULL,
    @imagen_promocional VARCHAR(255) = NULL,
    @contenido_a_publicar NVARCHAR(MAX),
    @fecha_ini_vigencia DATE,
    @fecha_fin_vigencia DATE,
    @costo_click DECIMAL(10,2) = 0,
    @cod_contenido_restaurante VARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        UPDATE dbo.contenidos_restaurantes
        SET
            nro_sucursal              = @nro_sucursal,
            contenido_promocional     = @contenido_promocional,
            imagen_promocional        = @imagen_promocional,
            contenido_a_publicar      = @contenido_a_publicar,
            fecha_ini_vigencia        = @fecha_ini_vigencia,
            fecha_fin_vigencia        = @fecha_fin_vigencia,
            costo_click               = @costo_click,
            cod_contenido_restaurante = @cod_contenido_restaurante
        WHERE
            nro_restaurante = @nro_restaurante
            AND nro_contenido = @nro_contenido
            AND nro_idioma = @nro_idioma;

        IF @@ROWCOUNT = 0
        BEGIN
            INSERT INTO dbo.contenidos_restaurantes
            (
                nro_restaurante, nro_idioma, nro_contenido, nro_sucursal,
                contenido_promocional, imagen_promocional, contenido_a_publicar,
                fecha_ini_vigencia, fecha_fin_vigencia, costo_click,
                cod_contenido_restaurante
            )
            VALUES
            (
                @nro_restaurante, @nro_idioma, @nro_contenido, @nro_sucursal,
                @contenido_promocional, @imagen_promocional, @contenido_a_publicar,
                @fecha_ini_vigencia, @fecha_fin_vigencia, @costo_click,
                @cod_contenido_restaurante
            );
        END

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

-- GET TODOS LOS RESTAURANTES
IF OBJECT_ID('dbo.sp_obtener_restaurantes', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_obtener_restaurantes;
GO
CREATE OR ALTER PROCEDURE dbo.sp_obtener_restaurantes
AS
BEGIN
    SELECT * FROM dbo.restaurantes;
END
GO

-- GET SUCURSALES DE UN RESTAURANTE (POR NRO_RESTAURANTE)
CREATE OR ALTER PROCEDURE dbo.sp_obtener_sucursales_por_nro_restaurante
(
    @nro_restaurante INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        sr.*,
        zsr.cod_zona,
        zsr.permite_menores,
        zsr.habilitada
    FROM dbo.sucursales_restaurantes AS sr
    INNER JOIN dbo.zonas_sucursales_restaurantes AS zsr
        ON zsr.nro_restaurante = sr.nro_restaurante
       AND zsr.nro_sucursal    = sr.nro_sucursal
    WHERE sr.nro_restaurante = @nro_restaurante;
END
GO


-- GET DISPONIBILIDAD DE TURNOS (POR NRO_RESTAURANTE, SUCURSAL Y FECHA)
IF OBJECT_ID('dbo.sp_obtener_disponibilidad_de_turnos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_obtener_disponibilidad_de_turnos;
GO
CREATE OR ALTER PROCEDURE dbo.sp_obtener_disponibilidad_de_turnos
(
    @nro_restaurante INT,
    @nro_sucursal INT,
    @fecha_a_reservar DATE
)
AS
BEGIN
SELECT
        tsr.nro_restaurante,
        tsr.nro_sucursal,
        @fecha_a_reservar AS fecha_reserva,
        tsr.hora_desde AS hora_reserva,
        tsr.hora_hasta,
        COALESCE(SUM(rr.cant_adultos + rr.cant_menores), 0) AS cantidad_reservada,
        (sr.total_comensales - COALESCE(SUM(rr.cant_adultos + rr.cant_menores), 0)) AS cupo_disponible,
        sr.total_comensales,
        tsr.habilitado AS turno_habilitado,
        CASE
            WHEN tsr.habilitado = 1
             AND COALESCE(SUM(rr.cant_adultos + rr.cant_menores), 0) >= sr.total_comensales
                THEN 1
            ELSE 0
        END AS turno_cerrado
    FROM turnos_sucursales_restaurantes tsr
    JOIN sucursales_restaurantes sr
      ON sr.nro_restaurante = tsr.nro_restaurante
     AND sr.nro_sucursal    = tsr.nro_sucursal
    LEFT JOIN reservas_restaurantes rr
      ON rr.nro_restaurante = tsr.nro_restaurante
     AND rr.nro_sucursal    = tsr.nro_sucursal
     AND rr.fecha_reserva   = @fecha_a_reservar
     AND rr.hora_reserva    = tsr.hora_desde
     AND rr.cod_estado IN ('PEN', 'CONF') 
    WHERE tsr.nro_restaurante = @nro_restaurante
      AND tsr.nro_sucursal    = @nro_sucursal
    GROUP BY
        tsr.nro_restaurante,
        tsr.nro_sucursal,
        tsr.hora_desde,
        tsr.hora_hasta,
        sr.total_comensales,
        tsr.habilitado
    ORDER BY tsr.hora_desde;
END
GO

IF OBJECT_ID('dbo.sp_get_reservas_por_cliente', 'P') IS NOT NULL
DROP PROCEDURE dbo.sp_get_reservas_por_cliente;
GO


CREATE OR ALTER PROCEDURE dbo.sp_get_reservas_por_cliente
(
@nro_cliente INT,
@nro_idioma INT,
@fecha_reserva DATE = NULL,
@estados_csv NVARCHAR(200) = NULL
)
AS
BEGIN
SET NOCOUNT ON;


/* Validaciones básicas */
IF NOT EXISTS (SELECT 1 FROM dbo.clientes WHERE nro_cliente = @nro_cliente)
THROW 50020, 'El cliente no existe.', 1;


IF NOT EXISTS (SELECT 1 FROM dbo.idiomas WHERE nro_idioma = @nro_idioma)
THROW 50021, 'El idioma no existe.', 1;


SELECT
rr.nro_cliente,
rr.nro_reserva,
rr.fecha_reserva,
rr.nro_restaurante,
r.razon_social,
r.icono_src,
rr.nro_sucursal,
sr.nom_sucursal,
sr.calle,
sr.nro_calle,
sr.barrio,
sr.cod_postal,
sr.telefonos AS telefonos_sucursal,
rr.cod_zona,
rr.hora_reserva,
rr.cant_adultos,
rr.cant_menores,
rr.cod_estado,
ie.estado AS estado, -- traducido según @nro_idioma
rr.fecha_cancelacion,
rr.costo_reserva,
rr.cod_reserva_sucursal
FROM dbo.reservas_restaurantes AS rr
INNER JOIN dbo.restaurantes AS r
ON r.nro_restaurante = rr.nro_restaurante
INNER JOIN dbo.sucursales_restaurantes AS sr
ON sr.nro_restaurante = rr.nro_restaurante
AND sr.nro_sucursal = rr.nro_sucursal
INNER JOIN dbo.idiomas_estados AS ie
ON ie.cod_estado = rr.cod_estado
AND ie.nro_idioma = @nro_idioma
WHERE rr.nro_cliente = @nro_cliente
AND (@fecha_reserva IS NULL OR rr.fecha_reserva = @fecha_reserva)
AND (
@estados_csv IS NULL OR LTRIM(RTRIM(@estados_csv)) = ''
OR rr.cod_estado IN (
SELECT LTRIM(RTRIM(value))
FROM STRING_SPLIT(@estados_csv, ',')
WHERE LTRIM(RTRIM(value)) <> ''
)
)
ORDER BY
rr.fecha_reserva DESC,
rr.hora_reserva DESC,
rr.nro_reserva DESC;
END
GO



IF OBJECT_ID('dbo.sp_get_estados_reserva_por_idioma', 'P') IS NOT NULL
DROP PROCEDURE dbo.sp_get_estados_reserva_por_idioma;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_estados_reserva_por_idioma 
(
@nro_idioma INT
)
AS
BEGIN   
    SELECT ie.cod_estado, ie.estado FROM idiomas_estados ie WHERE @nro_idioma = ie.nro_idioma
END
GO

--INSERT DE UN TURNO PEDIDO POR EL USUARIO, PARA UNA SUCURSAL DE UN RESTAURANTE
CREATE OR ALTER PROCEDURE dbo.sp_insertar_turno_sucursal
  @nro_restaurante INT,
  @nro_sucursal INT,
  @cod_zona CHAR(5),
  @hora_reserva TIME,
  @cant_adultos INT,
  @cant_menores INT,
  @cod_estado VARCHAR(30),
  @costo_reserva DECIMAL(10,2),
  @cod_reserva_sucursal VARCHAR(50),
  @nro_cliente INT,
  @fecha_reserva DATE
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @nro_reserva INT;

  /* 1️⃣ Generar nro_reserva (correlativo por cliente) */
  SELECT 
    @nro_reserva = ISNULL(MAX(nro_reserva), 0) + 1
  FROM reservas_restaurantes
  WHERE nro_cliente = @nro_cliente;

  /* 2️⃣ Insertar reserva */
  INSERT INTO reservas_restaurantes (
    nro_cliente,
    nro_reserva,
    fecha_reserva,
    nro_restaurante,
    nro_sucursal,
    cod_zona,
    hora_reserva,
    cant_adultos,
    cant_menores,
    cod_estado,
    fecha_cancelacion,
    costo_reserva,
    cod_reserva_sucursal
  )
  VALUES (
    @nro_cliente,
    @nro_reserva,
    @fecha_reserva,
    @nro_restaurante,
    @nro_sucursal,
    @cod_zona,
    @hora_reserva,
    @cant_adultos,
    @cant_menores,
    @cod_estado,
    NULL,
    @costo_reserva,
    @cod_reserva_sucursal
  );
END;
GO

-------------------------
-- OBTENER CLIENTE POR ID
-------------------------
CREATE OR ALTER PROCEDURE sp_get_cliente_por_id
  @nro_cliente INT
AS
BEGIN
  SET NOCOUNT ON;

  SELECT
    nro_cliente,
    apellido,
    nombre,
    clave,
    correo,
    telefonos,
    nro_localidad,
    habilitado
  FROM clientes
  WHERE nro_cliente = @nro_cliente;
END;
GO

-- OBTENER LA RESERVA DE UN CLIENTE
CREATE OR ALTER PROCEDURE dbo.sp_get_reserva_cliente
  @nro_reserva INT,
  @nro_cliente INT
AS
BEGIN
  SET NOCOUNT ON;

  SELECT
      rr.nro_reserva,
      rr.nro_restaurante,
      r.razon_social,
      rr.nro_sucursal,
      sr.nom_sucursal,
      rr.hora_reserva,
      rr.cod_estado,
      rr.fecha_reserva,
      rr.cant_adultos,
      rr.cod_reserva_sucursal,
      rr.cant_menores
  FROM dbo.reservas_restaurantes AS rr
  INNER JOIN dbo.restaurantes AS r
      ON r.nro_restaurante = rr.nro_restaurante
  INNER JOIN dbo.sucursales_restaurantes AS sr
      ON sr.nro_restaurante = rr.nro_restaurante
     AND sr.nro_sucursal    = rr.nro_sucursal
  WHERE rr.nro_reserva = @nro_reserva
    AND rr.nro_cliente = @nro_cliente;
END;
GO

-- ACTUALIZAR LA RESERVA DE UN CLIENTE
CREATE OR ALTER PROCEDURE dbo.sp_actualizar_reserva_cliente
  @nro_reserva   INT,
  @nro_cliente   INT,
  @cant_adultos  INT,
  @cant_menores  INT,
  @fecha_reserva DATE,
  @fecha_cancelacion DATE,
  @hora_reserva  TIME,
  @cod_estado VARCHAR(30) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    BEGIN TRAN;
    -- Update
    UPDATE rr
      SET   rr.cant_adultos  = COALESCE(@cant_adultos,  rr.cant_adultos),
        rr.fecha_reserva = COALESCE(@fecha_reserva, rr.fecha_reserva),
        rr.hora_reserva  = COALESCE(@hora_reserva,  rr.hora_reserva),
        rr.fecha_cancelacion = COALESCE(@fecha_cancelacion,  rr.fecha_cancelacion),
        rr.cod_estado = COALESCE(@cod_estado,  rr.cod_estado),
        rr.cant_menores = COALESCE(@cant_menores, rr.cant_menores)
    FROM dbo.reservas_restaurantes AS rr
    WHERE rr.nro_cliente = @nro_cliente
      AND rr.nro_reserva = @nro_reserva;

    IF @@ROWCOUNT = 0
      THROW 50033, 'No existe la reserva para ese cliente/nro_reserva.', 1;

    COMMIT TRAN;
  END TRY
  BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    THROW;
  END CATCH
END;
GO

-- OBTENER CLIENTE POR EMAIL
CREATE OR ALTER PROCEDURE dbo.sp_obtener_cliente_por_email 
(
    @email VARCHAR(150)
)
AS
BEGIN   
    SELECT c.correo, c.apellido, c.nombre, c.nro_cliente from clientes c where c.correo = @email;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_validar_login_cliente
    @correo VARCHAR(150),
    @clave  VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.clientes
        WHERE correo = @correo
          AND clave  = @clave
          AND habilitado = 1
    )
    THROW 50040, 'Usuario o clave inválidos.', 1;
    
END;
GO

CREATE OR ALTER PROCEDURE sp_crear_reserva_restaurante
  @nro_cliente INT,
  @fecha_reserva DATE,
  @nro_restaurante INT,
  @nro_sucursal INT,
  @hora_reserva TIME,
  @cant_adultos INT,
  @cant_menores INT,
  @cod_estado VARCHAR(30),
  @costo_reserva DECIMAL(10,2),
  @cod_reserva_sucursal VARCHAR(50),
  @cod_zona VARCHAR(15)
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @nro_reserva INT;

  /* 1️⃣ Generar nro_reserva (correlativo por cliente) */
  SELECT 
    @nro_reserva = ISNULL(MAX(nro_reserva), 0) + 1
  FROM reservas_restaurantes
  WHERE nro_cliente = @nro_cliente;

  /* 2️⃣ Insertar reserva */
  INSERT INTO reservas_restaurantes (
    nro_cliente,
    nro_reserva,
    fecha_reserva,
    nro_restaurante,
    nro_sucursal,
    cod_zona,
    hora_reserva,
    cant_adultos,
    cant_menores,
    cod_estado,
    fecha_cancelacion,
    costo_reserva,
    cod_reserva_sucursal
  )
  VALUES (
    @nro_cliente,
    @nro_reserva,
    @fecha_reserva,
    @nro_restaurante,
    @nro_sucursal,
    @cod_zona,
    @hora_reserva,
    @cant_adultos,
    @cant_menores,
    @cod_estado,
    NULL,
    @costo_reserva,
    @cod_reserva_sucursal
  );
END;
GO

--------------------------------------------
-- REGISTRAR CLIENTE E INSERTAR PREFERENCIAS
--------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_registrar_cliente
 @apellido            VARCHAR(100),
 @nombre              VARCHAR(100),
 @dni                 INT,
 @clave               VARCHAR(100),
 @correo              VARCHAR(150),
 @telefonos           VARCHAR(50),
 @nro_localidad       INT,
 @preferencias        VARCHAR(1000)  -- pares "cod_categoria:nro_valor_dominio" separados por coma, ej: "tc:1,ea:2,est:5"
AS
BEGIN
 SET NOCOUNT ON;


 BEGIN TRY


   -- Validar correo único
   IF EXISTS (
     SELECT 1
     FROM clientes
     WHERE correo = @correo
   )
   BEGIN
     SELECT
       0 AS success,
       'El correo ya se encuentra registrado' AS message;
     RETURN;
   END


   -- Insertar cliente
   INSERT INTO clientes (
     apellido,
     nombre,
     dni,
     clave,
     correo,
     telefonos,
     nro_localidad
   )
   VALUES (
     @apellido,
     @nombre,
     @dni,
     @clave,
     @correo,
     @telefonos,
     @nro_localidad
   );


   DECLARE @nro_cliente INT;
   SET @nro_cliente = SCOPE_IDENTITY();


   -- Insertar preferencias SOLO si vienen datos
   IF @preferencias IS NOT NULL AND LEN(@preferencias) > 0
   BEGIN
     INSERT INTO preferencias_clientes (
       nro_cliente,
       cod_categoria,
       nro_valor_dominio,
       observaciones
     )
     SELECT
       @nro_cliente,
       LEFT(value, CHARINDEX(':', value) - 1),
       CAST(SUBSTRING(value, CHARINDEX(':', value) + 1, LEN(value)) AS INT),
       NULL
     FROM STRING_SPLIT(@preferencias, ',');
   END


   SELECT
     1 AS success,
     @nro_cliente AS nro_cliente;


 END TRY
 BEGIN CATCH
   SELECT
     0 AS success,
     ERROR_MESSAGE() AS message;
 END CATCH


END;
GO






----------------------
-- OBTENER LOCALIDADES
----------------------
CREATE OR ALTER PROCEDURE dbo.sp_get_localidades
AS
BEGIN
   SET NOCOUNT ON;


   SELECT
       nro_localidad,
       nom_localidad,
       cod_provincia
   FROM localidades
   ORDER BY nom_localidad;
END;
GO


-----------------------
-- OBTENER PREFERENCIAS
-----------------------
CREATE OR ALTER PROCEDURE dbo.sp_get_preferencias_gastronomicas
AS
BEGIN
   SET NOCOUNT ON;


   SELECT
       cod_categoria,
       nro_valor_dominio,
       nom_valor_dominio
   FROM dominio_categorias_preferencias
   ORDER BY nom_valor_dominio;
END;
GO

IF OBJECT_ID('dbo.sp_get_contenidos_restaurante_por_sucursal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_get_contenidos_restaurante_por_sucursal;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_contenidos_restaurante_por_sucursal
    @nro_restaurante INT,          -- restaurante a consultar (obligatorio)
    @nro_idioma      INT = NULL,   -- filtro opcional
    @solo_vigentes   BIT = 1,      -- 1 = solo vigentes
    @fecha_ref       DATE = NULL,  -- si NULL usa GETDATE()
    @incluir_global  BIT = 1       -- 1 = incluye contenidos con nro_sucursal NULL en cada sucursal
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha_ref IS NULL
        SET @fecha_ref = CONVERT(date, GETDATE());

    ;WITH base AS (
        SELECT
            cr.nro_restaurante,
            cr.nro_sucursal,
            cr.nro_idioma,
            cr.nro_contenido,
            cr.cod_contenido_restaurante,
            cr.contenido_promocional,
            cr.imagen_promocional,
            cr.contenido_a_publicar,
            cr.fecha_ini_vigencia,
            cr.fecha_fin_vigencia,
            cr.costo_click
        FROM dbo.contenidos_restaurantes cr
        WHERE cr.nro_restaurante = @nro_restaurante
          AND (@nro_idioma IS NULL OR cr.nro_idioma = @nro_idioma)
          AND (
                @solo_vigentes = 0
                OR (@fecha_ref BETWEEN cr.fecha_ini_vigencia AND cr.fecha_fin_vigencia)
              )
    )
    SELECT
        r.nro_restaurante,
        r.razon_social,
        r.cuit,

        sr.nro_sucursal,
        sr.nom_sucursal,
        sr.calle,
        sr.nro_calle,
        sr.barrio,
        sr.cod_postal,
        sr.telefonos,
        l.nom_localidad,
        p.nom_provincia,

        b.nro_contenido,
        b.nro_idioma,
        b.cod_contenido_restaurante,
        b.contenido_promocional,
        b.imagen_promocional,
        b.contenido_a_publicar,
        b.fecha_ini_vigencia,
        b.fecha_fin_vigencia,
        b.costo_click,

        ISNULL(clk.total_clicks, 0)   AS total_clicks,
        ISNULL(clk.total_costo, 0.00) AS total_costo_clicks,
        clk.ultima_interaccion,

        CASE WHEN b.nro_sucursal IS NULL THEN 1 ELSE 0 END AS es_global
    FROM dbo.restaurantes r
    INNER JOIN dbo.sucursales_restaurantes sr
        ON sr.nro_restaurante = r.nro_restaurante
    LEFT JOIN dbo.localidades l
        ON l.nro_localidad = sr.nro_localidad
    LEFT JOIN dbo.provincias p
        ON p.cod_provincia = l.cod_provincia
    INNER JOIN base b
        ON b.nro_restaurante = sr.nro_restaurante
       AND (
             b.nro_sucursal = sr.nro_sucursal
             OR (@incluir_global = 1 AND b.nro_sucursal IS NULL)
           )
    LEFT JOIN (
        SELECT
            nro_restaurante,
            nro_idioma,
            nro_contenido,
            COUNT(*)                 AS total_clicks,
            SUM(costo_click)         AS total_costo,
            MAX(fecha_hora_registro) AS ultima_interaccion
        FROM dbo.clicks_contenidos_restaurantes
        GROUP BY nro_restaurante, nro_idioma, nro_contenido
    ) clk
        ON clk.nro_restaurante = b.nro_restaurante
       AND clk.nro_idioma      = b.nro_idioma
       AND clk.nro_contenido   = b.nro_contenido
    WHERE r.nro_restaurante = @nro_restaurante
    ORDER BY
        sr.nro_sucursal,
        es_global,                       -- primero contenidos por sucursal (0) y luego globales (1) o al revés si querés
        b.fecha_ini_vigencia DESC,
        b.nro_contenido;
END
GO


-- OBTENER CLIENTE POR EMAIL PARA PROCESO DE LOGIN
CREATE OR ALTER PROCEDURE dbo.sp_obtener_cliente_por_email_para_login
(
   @email VARCHAR(150)
)
AS
BEGIN  
   SELECT c.correo, c.nro_cliente, c.clave from clientes c where c.correo = @email;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_get_restaurantes_tags_flat
  @nro_idioma INT = 1
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH pref AS (
    SELECT
      pr.nro_restaurante,
      pr.nro_sucursal,
      idcp.valor_dominio
    FROM dbo.preferencias_restaurantes pr
    INNER JOIN dbo.idiomas_dominio_cat_preferencias idcp
      ON idcp.cod_categoria = pr.cod_categoria
     AND idcp.nro_valor_dominio = pr.nro_valor_dominio
     AND idcp.nro_idioma = @nro_idioma
    WHERE pr.nro_sucursal IS NOT NULL                     
  ),
  dedup AS (
    SELECT DISTINCT
      nro_restaurante,
      nro_sucursal,
      LTRIM(RTRIM(valor_dominio)) AS tag
    FROM pref
    WHERE valor_dominio IS NOT NULL
      AND LTRIM(RTRIM(valor_dominio)) <> ''
  )
  SELECT
    CAST(d.nro_restaurante AS varchar(10)) + '-' + CAST(d.nro_sucursal AS varchar(10)) AS id,
    STRING_AGG(d.tag, '|') WITHIN GROUP (ORDER BY d.tag) AS tags
  FROM dedup d
  GROUP BY d.nro_restaurante, d.nro_sucursal
  ORDER BY d.nro_restaurante, d.nro_sucursal;
END
GO


IF OBJECT_ID('dbo.sp_get_preferencias_cliente_tags_flat', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_get_preferencias_cliente_tags_flat;
GO

CREATE OR ALTER PROCEDURE dbo.sp_get_preferencias_cliente_tags_flat
  @nro_cliente INT,
  @nro_idioma  INT = 1
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH pref AS (
    SELECT
      idcp.valor_dominio
    FROM dbo.preferencias_clientes pc
    INNER JOIN dbo.idiomas_dominio_cat_preferencias idcp
      ON idcp.cod_categoria     = pc.cod_categoria
     AND idcp.nro_valor_dominio = pc.nro_valor_dominio
     AND idcp.nro_idioma        = @nro_idioma
    WHERE pc.nro_cliente = @nro_cliente
  ),
  dedup AS (
    SELECT DISTINCT
      LTRIM(RTRIM(valor_dominio)) AS tag
    FROM pref
    WHERE valor_dominio IS NOT NULL
      AND LTRIM(RTRIM(valor_dominio)) <> ''
  )
  SELECT
    STRING_AGG(tag, '|') WITHIN GROUP (ORDER BY tag) AS tags
  FROM dedup;
END
GO

-- Ejemplo de uso:
-- EXEC dbo.sp_get_preferencias_cliente_tags_flat @nro_cliente = 1, @nro_idioma = 1;


CREATE OR ALTER PROCEDURE dbo.sp_get_promociones_por_lista
    @json          NVARCHAR(MAX),
    @solo_vigentes BIT = 1,
    @fecha_ref     DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha_ref IS NULL
        SET @fecha_ref = CONVERT(date, GETDATE());

    ;WITH items AS (
        SELECT DISTINCT
            j.nroRestaurante AS nro_restaurante,
            j.nroContenido   AS nro_contenido,
            j.nroIdioma      AS nro_idioma
        FROM OPENJSON(@json)
        WITH (
            nroRestaurante INT '$.nroRestaurante',
            nroContenido   INT '$.nroContenido',
            nroIdioma      INT '$.nroIdioma'
        ) AS j
        WHERE j.nroRestaurante IS NOT NULL
          AND j.nroContenido   IS NOT NULL
          AND j.nroIdioma      IS NOT NULL
    ),
    clk AS (
        SELECT
            nro_restaurante,
            nro_idioma,
            nro_contenido,
            COUNT(*)                 AS total_clicks,
            SUM(costo_click)         AS total_costo,
            MAX(fecha_hora_registro) AS ultima_interaccion
        FROM dbo.clicks_contenidos_restaurantes
        GROUP BY nro_restaurante, nro_idioma, nro_contenido
    )
    SELECT
        cr.nro_restaurante,
        r.razon_social,
        r.cuit,
        cr.nro_sucursal,
        sr.nom_sucursal,
        sr.calle,
        sr.nro_calle,
        sr.barrio,
        l.nom_localidad,
        p.nom_provincia,

        cr.nro_contenido,
        cr.nro_idioma,
        cr.cod_contenido_restaurante,
        cr.contenido_promocional,
        cr.imagen_promocional,
        cr.contenido_a_publicar,
        cr.fecha_ini_vigencia,
        cr.fecha_fin_vigencia,
        cr.costo_click,

        ISNULL(c.total_clicks, 0)    AS total_clicks,
        ISNULL(c.total_costo, 0.00)  AS total_costo_clicks,
        c.ultima_interaccion
    FROM items i
    INNER JOIN dbo.contenidos_restaurantes cr
        ON cr.nro_restaurante = i.nro_restaurante
       AND cr.nro_contenido   = i.nro_contenido
       AND cr.nro_idioma      = i.nro_idioma
    INNER JOIN dbo.restaurantes r
        ON r.nro_restaurante = cr.nro_restaurante
    LEFT JOIN dbo.sucursales_restaurantes sr
        ON sr.nro_restaurante = cr.nro_restaurante
       AND sr.nro_sucursal    = cr.nro_sucursal
    LEFT JOIN dbo.localidades l
        ON l.nro_localidad = sr.nro_localidad
    LEFT JOIN dbo.provincias p
        ON p.cod_provincia = l.cod_provincia
    LEFT JOIN clk c
        ON c.nro_restaurante = cr.nro_restaurante
       AND c.nro_idioma      = cr.nro_idioma
       AND c.nro_contenido   = cr.nro_contenido
    WHERE
        @solo_vigentes = 0
        OR (@fecha_ref BETWEEN cr.fecha_ini_vigencia AND cr.fecha_fin_vigencia)
    ORDER BY
        r.razon_social,
        sr.nom_sucursal,
        cr.fecha_ini_vigencia DESC,
        cr.nro_contenido;
END
GO


CREATE OR ALTER PROCEDURE dbo.sp_obtener_costo_por_tipo
(
    @tipo_costo VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT monto
    FROM dbo.costos
    WHERE tipo_costo = @tipo_costo
      AND CAST(GETDATE() AS DATE) >= fecha_ini_vigencia
      AND CAST(GETDATE() AS DATE) < fecha_fin_vigencia;
END
GO

CREATE OR ALTER PROCEDURE sp_obtener_sucursales_form_reservas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        sr.nro_restaurante,
        sr.nro_sucursal,
        sr.nom_sucursal
    FROM sucursales_restaurantes sr;
END;
GO

CREATE OR ALTER PROCEDURE sp_obtener_zonas_restaurantes_form_reservas
    @nro_idioma INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        zsr.nro_restaurante,
        zsr.nro_sucursal,
        zsr.cod_zona,
        zsr.permite_menores,
        zsr.habilitada,
        izsr.zona
    FROM zonas_sucursales_restaurantes zsr
    INNER JOIN idiomas_zonas_suc_restaurantes izsr
        ON zsr.nro_restaurante = izsr.nro_restaurante
        AND zsr.nro_sucursal = izsr.nro_sucursal
        AND zsr.cod_zona = izsr.cod_zona
    WHERE izsr.nro_idioma = @nro_idioma
    ORDER BY 
        zsr.nro_restaurante,
        zsr.nro_sucursal,
        zsr.cod_zona;
END;
GO
CREATE OR ALTER PROCEDURE dbo.sp_obtener_disponibilidad_por_zona
    @nro_restaurante INT,
    @nro_sucursal    INT,
    @fecha_reserva   DATE,
    @cod_zona        VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        zts.nro_restaurante,
        zts.nro_sucursal,
        zts.cod_zona,
        zsuc.cant_comensales,
        zsuc.permite_menores,
        zts.hora_desde,
        tsr.hora_hasta,
        tsr.habilitado,

        ISNULL(SUM(rr.cant_adultos + rr.cant_menores), 0)        AS cantidad_reservada,
        zsuc.cant_comensales
            - ISNULL(SUM(rr.cant_adultos + rr.cant_menores), 0)  AS cupo_disponible

    FROM dbo.zonas_turnos_sucursales_restaurantes AS zts

    INNER JOIN dbo.zonas_sucursales_restaurantes AS zsuc
        ON  zsuc.nro_restaurante = zts.nro_restaurante
        AND zsuc.nro_sucursal    = zts.nro_sucursal
        AND zsuc.cod_zona        = zts.cod_zona

    INNER JOIN dbo.turnos_sucursales_restaurantes AS tsr
        ON  tsr.nro_restaurante = zts.nro_restaurante
        AND tsr.nro_sucursal    = zts.nro_sucursal
        AND tsr.hora_desde      = zts.hora_desde

    LEFT JOIN dbo.reservas_restaurantes AS rr
        ON  rr.nro_restaurante = zts.nro_restaurante
        AND rr.nro_sucursal    = zts.nro_sucursal
        AND rr.cod_zona        = zts.cod_zona
        AND rr.hora_reserva    = zts.hora_desde
        AND rr.fecha_reserva   = @fecha_reserva
        AND rr.cod_estado      IN ('PEN', 'CONF')

    WHERE
        zts.nro_restaurante = @nro_restaurante
        AND zts.nro_sucursal = @nro_sucursal
        AND zts.cod_zona     = @cod_zona
        AND tsr.habilitado   = 1
        AND zsuc.habilitada  = 1

    GROUP BY
        zts.nro_restaurante,
        zts.nro_sucursal,
        zts.cod_zona,
        zsuc.cant_comensales,
        zsuc.permite_menores,
        zsuc.habilitada,
        zts.hora_desde,
        tsr.hora_hasta,
        tsr.habilitado,
        zts.permite_menores

    ORDER BY
        zts.hora_desde;
END
GO

select * from contenidos_restaurantes

select * from clicks_contenidos_restaurantes

