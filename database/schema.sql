CREATE DATABASE IF NOT EXISTS gestion_flota CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestion_flota;

CREATE TABLE empresa (
  id_empresa INT AUTO_INCREMENT PRIMARY KEY,
  razon_social VARCHAR(150) NOT NULL,
  ruc VARCHAR(11) NOT NULL UNIQUE
);

CREATE TABLE unidad_minera (
  id_unidad_minera INT AUTO_INCREMENT PRIMARY KEY,
  id_empresa INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  UNIQUE (id_empresa, nombre),
  FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE area (
  id_area INT AUTO_INCREMENT PRIMARY KEY,
  id_unidad_minera INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  UNIQUE (id_unidad_minera, nombre),
  FOREIGN KEY (id_unidad_minera) REFERENCES unidad_minera(id_unidad_minera)
);

CREATE TABLE tipo_vehiculo (
  id_tipo_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  categoria VARCHAR(80) NOT NULL,
  unidad_medicion ENUM('KM','HORAS') NOT NULL
);

CREATE TABLE vehiculo (
  id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
  id_tipo_vehiculo INT NOT NULL,
  id_area INT,
  codigo_interno VARCHAR(50) NOT NULL UNIQUE,
  placa VARCHAR(20) UNIQUE,
  kilometraje DECIMAL(12,2) NOT NULL DEFAULT 0,
  horometro DECIMAL(12,2) NOT NULL DEFAULT 0,
  estado ENUM('DISPONIBLE','ASIGNADO','ALQUILADO','EN_MANTENIMIENTO','FUERA_DE_SERVICIO','DADO_DE_BAJA') NOT NULL DEFAULT 'DISPONIBLE',
  FOREIGN KEY (id_tipo_vehiculo) REFERENCES tipo_vehiculo(id_tipo_vehiculo),
  FOREIGN KEY (id_area) REFERENCES area(id_area)
);

CREATE TABLE conductor (
  id_conductor INT AUTO_INCREMENT PRIMARY KEY,
  dni VARCHAR(20) NOT NULL UNIQUE,
  nombre VARCHAR(150) NOT NULL,
  licencia VARCHAR(30) NOT NULL UNIQUE,
  vencimiento_licencia DATE NOT NULL
);

CREATE TABLE asignacion (
  id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo INT NOT NULL,
  id_conductor INT NOT NULL,
  id_area INT NOT NULL,
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME,
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor),
  FOREIGN KEY (id_area) REFERENCES area(id_area),
  CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

CREATE TABLE alquiler (
  id_alquiler INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo INT NOT NULL,
  id_conductor INT NOT NULL,
  fecha_inicio DATETIME NOT NULL,
  fecha_fin DATETIME,
  destino VARCHAR(200) NOT NULL,
  motivo VARCHAR(200),
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor),
  CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

CREATE TABLE tipo_mantenimiento (
  id_tipo_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL UNIQUE,
  es_preventivo BOOLEAN NOT NULL,
  frecuencia_km INT,
  frecuencia_horas INT,
  frecuencia_dias INT
);

CREATE TABLE mantenimiento (
  id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo INT NOT NULL,
  id_tipo_mantenimiento INT NOT NULL,
  fecha DATE NOT NULL,
  costo DECIMAL(12,2) NOT NULL DEFAULT 0,
  estado VARCHAR(40) NOT NULL,
  proxima_fecha DATE,
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_tipo_mantenimiento) REFERENCES tipo_mantenimiento(id_tipo_mantenimiento),
  CHECK (costo >= 0)
);

CREATE TABLE tipo_documento (
  id_tipo_documento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  requiere_vencimiento BOOLEAN NOT NULL,
  dias_alerta INT NOT NULL DEFAULT 0
);

CREATE TABLE documento_vehiculo (
  id_documento INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo INT NOT NULL,
  id_tipo_documento INT NOT NULL,
  fecha_vencimiento DATE,
  estado VARCHAR(30) NOT NULL,
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento)
);

CREATE TABLE rol (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  descripcion VARCHAR(200)
);

CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  id_rol INT NOT NULL,
  nombre_usuario VARCHAR(80) NOT NULL UNIQUE,
  nombre VARCHAR(150) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

CREATE TABLE inspeccion (
  id_inspeccion INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo INT NOT NULL,
  id_usuario_inspector INT NOT NULL,
  fecha DATETIME NOT NULL,
  resultado ENUM('APTO','APTO_CON_OBSERVACIONES','NO_APTO') NOT NULL,
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_usuario_inspector) REFERENCES usuario(id_usuario)
);

CREATE TABLE detalle_inspeccion (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_inspeccion INT NOT NULL,
  item VARCHAR(150) NOT NULL,
  conforme BOOLEAN NOT NULL,
  critico BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (id_inspeccion) REFERENCES inspeccion(id_inspeccion) ON DELETE CASCADE
);

CREATE TABLE combustible (
  id_combustible INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo INT NOT NULL,
  id_usuario_responsable INT NOT NULL,
  fecha DATETIME NOT NULL,
  cantidad DECIMAL(10,2) NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  costo_total DECIMAL(12,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
  lectura DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_usuario_responsable) REFERENCES usuario(id_usuario),
  CHECK (cantidad > 0 AND precio_unitario >= 0)
);

CREATE TABLE incidente (
  id_incidente INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo INT NOT NULL,
  id_conductor INT NOT NULL,
  fecha DATETIME NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  descripcion TEXT NOT NULL,
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor)
);

CREATE TABLE historial_vehiculo (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_vehiculo INT NOT NULL,
  id_usuario INT,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  tipo_evento VARCHAR(80) NOT NULL,
  descripcion TEXT NOT NULL,
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE INDEX idx_vehiculo_estado ON vehiculo(estado);
CREATE INDEX idx_conductor_venc_lic ON conductor(vencimiento_licencia);
CREATE INDEX idx_doc_vencimiento ON documento_vehiculo(fecha_vencimiento);
CREATE INDEX idx_mant_proxima_fecha ON mantenimiento(proxima_fecha);
CREATE INDEX idx_hist_veh_fecha ON historial_vehiculo(id_vehiculo, fecha);
