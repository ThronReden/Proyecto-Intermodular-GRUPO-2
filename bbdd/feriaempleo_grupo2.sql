
create database if not exists feriaempleo_grupo2;
use feriaempleo_grupo2;

create table if not exists usuarios(
	id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    
	CONSTRAINT chk_email CHECK (Email LIKE '%@%'),
    CONSTRAINT chk_nombre CHECK (CHAR_LENGTH(Nombre) >= 2),
    CONSTRAINT chk_contrasena CHECK (CHAR_LENGTH(Contrasena) >= 8
    AND Contrasena REGEXP '[A-Z]')
	
);

CREATE TABLE IF NOT EXISTS centros (
    id_centro INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    cuenta_instagram VARCHAR(50),
    cuenta_tiktok VARCHAR(50)
);

create table if not exists visitantes(
	id_visitante INT auto_increment PRIMARY KEY,
    usuario_id INT NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    
    tipo_visitante ENUM('VISITANTE', 'JURADO')
        NOT NULL DEFAULT 'VISITANTE',
        
    
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
	ON UPDATE CASCADE,
    CONSTRAINT uq_visitante_usuario UNIQUE (usuario_id)
);


CREATE TABLE if not exists empresas (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    centro_id INT NOT NULL,
    descripcion VARCHAR(1000), -- opcional
    telefono VARCHAR(20),
    logo_dir VARCHAR(255),
    video_dir VARCHAR(255),
    enlace_meet VARCHAR(500),

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
    CONSTRAINT uq_empresa_usuario UNIQUE (usuario_id),
    CONSTRAINT fk_empresa_centro
    FOREIGN KEY (centro_id) REFERENCES centros(id_centro)
    ON UPDATE CASCADE
);




CREATE TABLE if not exists categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    identificador ENUM('PITCH', 'BEHIND', 'SPOT', 'SOCIO') NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    hashtag VARCHAR(50) NOT NULL,
    tipo_evaluacion ENUM('METRICAS', 'JURADO') NOT NULL
);

INSERT IGNORE INTO categorias (identificador, nombre, hashtag, tipo_evaluacion)
VALUES
('PITCH', 'Elevator Pitch Comercial', '#PitchLSBM2027', 'METRICAS'),
('BEHIND', 'Behind the Scenes', '#BehindLSBM2027', 'JURADO'),
('SPOT', 'Spot Comercial', '#SpotLSBM2027', 'JURADO'),
('SOCIO', 'Recomienda a tu socio', '#SOCIOLSBM2027', 'JURADO');

CREATE TABLE if not exists participaciones (
    id_participacion INT AUTO_INCREMENT PRIMARY KEY,
    empresa_id INT NOT NULL,
    categoria_id INT NOT NULL,
     empresa_recomendada_id INT NULL, -- solo para SOCIO

    CONSTRAINT uq_empresa_categoria
        UNIQUE (empresa_id, categoria_id),

    FOREIGN KEY (empresa_id)
        REFERENCES empresas(id_empresa)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (categoria_id)
        REFERENCES categorias(id_categoria)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	
     FOREIGN KEY (empresa_recomendada_id)
        REFERENCES empresas(id_empresa)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE if not exists publicaciones (
    id_publicacion INT AUTO_INCREMENT PRIMARY KEY,
    participacion_id INT NOT NULL,
    plataforma ENUM('INSTAGRAM', 'TIKTOK') NOT NULL,
    url_video VARCHAR(500) NOT NULL,
    compartidos INT NOT NULL DEFAULT 0,
	me_gusta INT NOT NULL DEFAULT 0,
	guardados INT NOT NULL DEFAULT 0,
    

    FOREIGN KEY (participacion_id)
        REFERENCES participaciones(id_participacion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT uq_participacion_plataforma
        UNIQUE (participacion_id, plataforma),

    CHECK (compartidos >= 0),
    CHECK (me_gusta >= 0),
    CHECK (guardados >= 0)
);

CREATE TABLE if not exists evaluaciones (
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    participacion_id INT NOT NULL,
    visitante_id INT NOT NULL,

    nota_mensaje DECIMAL(4,2) NOT NULL,
    nota_creatividad DECIMAL(4,2) NOT NULL,
    nota_audiovisual DECIMAL(4,2) NOT NULL,
    nota_final DECIMAL(4,2)
        GENERATED ALWAYS AS (
            nota_mensaje * 0.4 + nota_creatividad * 0.4 + nota_audiovisual * 0.2
        ) STORED,
    

    CONSTRAINT uq_evaluador_participacion
        UNIQUE (participacion_id, visitante_id),

    FOREIGN KEY (participacion_id)
        REFERENCES participaciones(id_participacion)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (visitante_id)
        REFERENCES visitantes(id_visitante)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (nota_mensaje BETWEEN 0 AND 10),
    CHECK (nota_creatividad BETWEEN 0 AND 10),
    CHECK (nota_audiovisual BETWEEN 0 AND 10)
);

