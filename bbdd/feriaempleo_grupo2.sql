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
    AND Contraseña REGEXP '[A-Z]')
	
);

create table if not exists visitantes(
	id_visitante INT auto_increment PRIMARY KEY,
    usuario_id INT NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);


CREATE TABLE if not exists empresas (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    descripcion VARCHAR(1000), -- opcional
    telefono VARCHAR(20),
    logo_dir VARCHAR(255),
    video_dir VARCHAR(255),
    enlace_meet VARCHAR(500),

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);