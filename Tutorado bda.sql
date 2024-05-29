DROP DATABASE IF EXISTS bdescuela;
CREATE DATABASE bdescuela;
USE bdescuela;

CREATE TABLE Profesores (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido_P VARCHAR(255) NOT NULL,
    apellido_M VARCHAR(255) NOT NULL,
    sexo VARCHAR(1) NOT NULL,	
    fecha_nac DATE NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(50),
    calle VARCHAR(255),
    numero INT,
    colonia VARCHAR(255),
    cp VARCHAR(5),
    departamento VARCHAR(255)
);

CREATE TABLE Administrador (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE Tutores (
    id_tutor INT PRIMARY KEY,
    FOREIGN KEY (id_tutor) REFERENCES Profesores(id_profesor)
);

CREATE TABLE Grupos_Tutorias (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_grupo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    id_tutor INT,
    FOREIGN KEY (id_tutor) REFERENCES Tutores(id_tutor)
);

CREATE TABLE Alumnos (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido_P VARCHAR(255) NOT NULL,
    apellido_M VARCHAR(255) NOT NULL,
    fecha_nac DATE NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(50),
    calle VARCHAR(255),
    numero INT,
    colonia VARCHAR(255),
    cp VARCHAR(5),
    departamento VARCHAR(255),
    carrera VARCHAR(255) NOT NULL,
    semestre INT NOT NULL,
    horario_no VARCHAR(1),
    estado_civil ENUM('soltero', 'casado') NOT NULL,
    id_grupo INT,
    FOREIGN KEY (id_grupo) REFERENCES Grupos_Tutorias(id_grupo)
);

CREATE TABLE Reportes_Tutor (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    id_tutor INT,
    id_alumno INT,
    prom_general DECIMAL(3,1) NOT NULL,
    fecha DATE NOT NULL,
    reporte TEXT NOT NULL,
    FOREIGN KEY (id_tutor) REFERENCES Tutores(id_tutor),
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno)
);

CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    codigo_usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    tipo_usuario ENUM('alumno', 'tutor', 'administrador') NOT NULL,
    id_alumno INT,
    id_tutor INT,
    id_admin INT,
    UNIQUE(tipo_usuario, id_alumno),
    UNIQUE(tipo_usuario, id_tutor),
    UNIQUE(tipo_usuario, id_admin),
    FOREIGN KEY (id_alumno) REFERENCES Alumnos(id_alumno) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_tutor) REFERENCES Tutores(id_tutor) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_admin) REFERENCES Administrador(id_admin) ON DELETE CASCADE ON UPDATE CASCADE
);



