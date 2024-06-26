-- Profesores
INSERT INTO Profesores (nombre, apellido_P, apellido_M, sexo, fecha_nac, telefono, correo, calle, numero, colonia, cp, departamento)
VALUES
    ('Juan', 'González', 'Pérez', 'M', '1975-08-15', '5544332211', 'juan.gonzalez@example.com', 'Calle Principal', 123, 'Centro', '54123', 'Ciudad de México'),
    ('María', 'López', 'Martínez', 'F', '1980-04-25', '5544221133', 'maria.lopez@example.com', 'Av. Revolución', 456, 'Del Valle', '54321', 'Ciudad de México'),
    ('Carlos', 'Hernández', 'García', 'M', '1978-11-10', '5533112244', 'carlos.hernandez@example.com', 'Calle Robles', 789, 'Las Águilas', '54321', 'Ciudad de México'),
    ('Ana', 'Rodríguez', 'López', 'F', '1982-09-17', '5544332212', 'ana.rodriguez@example.com', 'Calle Segunda', 124, 'Norte', '54124', 'Ciudad de México'),
    ('Luis', 'Martínez', 'Sánchez', 'M', '1976-02-23', '5544332213', 'luis.martinez@example.com', 'Calle Tercera', 125, 'Sur', '54125', 'Ciudad de México'),
    ('Patricia', 'García', 'Ramírez', 'F', '1983-05-14', '5544332214', 'patricia.garcia@example.com', 'Calle Cuarta', 126, 'Este', '54126', 'Ciudad de México'),
    ('Fernando', 'Jiménez', 'Fernández', 'M', '1979-08-19', '5544332215', 'fernando.jimenez@example.com', 'Calle Quinta', 127, 'Oeste', '54127', 'Ciudad de México'),
    ('Laura', 'Gómez', 'Torres', 'F', '1985-11-30', '5544332216', 'laura.gomez@example.com', 'Calle Sexta', 128, 'Centro', '54128', 'Ciudad de México'),
    ('José', 'Díaz', 'Vargas', 'M', '1980-03-25', '5544332217', 'jose.diaz@example.com', 'Calle Séptima', 129, 'Norte', '54129', 'Ciudad de México'),
    ('Mónica', 'Hernández', 'Castillo', 'F', '1977-06-12', '5544332218', 'monica.hernandez@example.com', 'Calle Octava', 130, 'Sur', '54130', 'Ciudad de México'),
    ('Ricardo', 'Pérez', 'Rojas', 'M', '1981-01-04', '5544332219', 'ricardo.perez@example.com', 'Calle Novena', 131, 'Este', '54131', 'Ciudad de México'),
    ('Gabriela', 'Ramírez', 'Morales', 'F', '1984-04-16', '5544332220', 'gabriela.ramirez@example.com', 'Calle Décima', 132, 'Oeste', '54132', 'Ciudad de México'),
    ('Alejandro', 'Torres', 'Medina', 'M', '1975-07-28', '5544332221', 'alejandro.torres@example.com', 'Calle Once', 133, 'Centro', '54133', 'Ciudad de México'),
    ('Sandra', 'Vargas', 'Núñez', 'F', '1982-10-09', '5544332222', 'sandra.vargas@example.com', 'Calle Doce', 134, 'Norte', '54134', 'Ciudad de México'),
    ('Diego', 'Castillo', 'Herrera', 'M', '1978-01-22', '5544332223', 'diego.castillo@example.com', 'Calle Trece', 135, 'Sur', '54135', 'Ciudad de México'),
    ('Beatriz', 'López', 'Pérez', 'F', '1985-05-27', '5544332224', 'beatriz.lopez@example.com', 'Calle Catorce', 136, 'Este', '54136', 'Ciudad de México'),
    ('Héctor', 'González', 'Santos', 'M', '1979-08-03', '5544332225', 'hector.gonzalez@example.com', 'Calle Quince', 137, 'Oeste', '54137', 'Ciudad de México'),
    ('Carmen', 'Martínez', 'Jiménez', 'F', '1983-12-12', '5544332226', 'carmen.martinez@example.com', 'Calle Dieciséis', 138, 'Centro', '54138', 'Ciudad de México'),
    ('Miguel', 'Sánchez', 'Mendoza', 'M', '1981-02-17', '5544332227', 'miguel.sanchez@example.com', 'Calle Diecisiete', 139, 'Norte', '54139', 'Ciudad de México'),
    ('Lucía', 'Pérez', 'Romero', 'F', '1976-06-30', '5544332228', 'lucia.perez@example.com', 'Calle Dieciocho', 140, 'Sur', '54140', 'Ciudad de México'),
    ('Andrés', 'Ramírez', 'González', 'M', '1984-11-05', '5544332229', 'andres.ramirez@example.com', 'Calle Diecinueve', 141, 'Este', '54141', 'Ciudad de México'),
    ('Verónica', 'Gómez', 'López', 'F', '1977-09-23', '5544332230', 'veronica.gomez@example.com', 'Calle Veinte', 142, 'Oeste', '54142', 'Ciudad de México'),
    ('Jorge', 'Hernández', 'Vargas', 'M', '1980-02-14', '5544332231', 'jorge.hernandez@example.com', 'Calle Veintiuno', 143, 'Centro', '54143', 'Ciudad de México');

-- Tutores
INSERT INTO Tutores (id_tutor)
VALUES (1), (2);

-- Grupos de Tutorías
INSERT INTO Grupos_Tutorias (nombre_grupo, descripcion, id_tutor)
VALUES
    ('Grupo 1', 'Grupo para primer semestre de Ingeniería', 1),
    ('Grupo 2', 'Grupo para segundo semestre de Ingeniería', 2),
    ('Grupo 3', 'Grupo para tercer semestre de Ingeniería', 1);

-- Alumnos
INSERT INTO Alumnos (nombre, apellido_P, apellido_M, fecha_nac, telefono, correo, calle, numero, colonia, cp, departamento, carrera, semestre, horario_no, estado_civil, id_grupo)
VALUES
    ('Ana', 'Martínez', 'Sánchez', '2000-03-10', '5511223344', 'ana.martinez@example.com', 'Av. Insurgentes', 111, 'Roma Norte', '55000', 'Ciudad de México', 'Ingeniería en Sistemas', 1, 'A', 'soltero', 1),
    ('Pedro', 'Gómez', 'López', '2001-07-20', '5522334455', 'pedro.gomez@example.com', 'Calle Reforma', 222, 'Juárez', '55100', 'Ciudad de México', 'Ingeniería en Sistemas', 2, 'B', 'soltero', 2),
    ('Laura', 'Hernández', 'Rodríguez', '2000-05-15', '5533445566', 'laura.hernandez@example.com', 'Calle Principal', 333, 'Del Valle', '55200', 'Ciudad de México', 'Ingeniería en Sistemas', 3, 'C', 'casado', 3),
    ('Javier', 'Pérez', 'García', '2001-01-05', '5544556677', 'javier.perez@example.com', 'Av. Chapultepec', 444, 'Condesa', '55300', 'Ciudad de México', 'Ingeniería en Sistemas', 1, 'A', 'soltero', NULL),
	('Carlos', 'Torres', 'Jiménez', '2001-09-18', '5511223345', 'carlos.torres@example.com', 'Calle Secundaria', 101, 'Centro', '54000', 'Ciudad de México', 'Ingeniería en Sistemas', 2, 'B', 'soltero', 1),
    ('María', 'Ruiz', 'González', '2002-02-20', '5522334456', 'maria.ruiz@example.com', 'Av. Universidad', 202, 'Coyoacán', '54100', 'Ciudad de México', 'Ingeniería en Sistemas', 4, 'D', 'casado', 2),
    ('José', 'López', 'Martínez', '2000-11-30', '5533445567', 'jose.lopez@example.com', 'Calle Norte', 303, 'Roma Norte', '54200', 'Ciudad de México', 'Ingeniería en Sistemas', 5, 'E', 'soltero', 3),
    ('Lucía', 'Hernández', 'Vargas', '2001-05-25', '5544556678', 'lucia.hernandez@example.com', 'Av. Sur', 404, 'Juárez', '54300', 'Ciudad de México', 'Ingeniería en Sistemas', 6, 'F', 'casado', 1),
    ('Roberto', 'García', 'Pérez', '2002-08-14', '5555667788', 'roberto.garcia@example.com', 'Calle Este', 505, 'Condesa', '54400', 'Ciudad de México', 'Ingeniería en Sistemas', 1, 'A', 'soltero', 2),
    ('Elena', 'Martínez', 'Hernández', '2001-03-22', '5566778899', 'elena.martinez@example.com', 'Calle Oeste', 606, 'Del Valle', '54500', 'Ciudad de México', 'Ingeniería en Sistemas', 2, 'B', 'casado', 3),
    ('Miguel', 'Rodríguez', 'Sánchez', '2000-12-10', '5577889900', 'miguel.rodriguez@example.com', 'Av. Norte', 707, 'Roma Norte', '54600', 'Ciudad de México', 'Ingeniería en Sistemas', 3, 'C', 'soltero', 1),
    ('Paula', 'González', 'Ruiz', '2002-01-05', '5588990011', 'paula.gonzalez@example.com', 'Av. Sur', 808, 'Coyoacán', '54700', 'Ciudad de México', 'Ingeniería en Sistemas', 4, 'D', 'casado', 2),
    ('Sergio', 'Fernández', 'López', '2001-07-17', '5599001122', 'sergio.fernandez@example.com', 'Calle Este', 909, 'Juárez', '54800', 'Ciudad de México', 'Ingeniería en Sistemas', 5, 'E', 'soltero', 3),
    ('Laura', 'Pérez', 'Martínez', '2000-09-29', '5510112233', 'laura.perez@example.com', 'Calle Oeste', 110, 'Condesa', '54900', 'Ciudad de México', 'Ingeniería en Sistemas', 6, 'F', 'casado', 1),
    ('Andrés', 'García', 'Torres', '2002-11-02', '5520223344', 'andres.garcia@example.com', 'Av. Principal', 121, 'Del Valle', '55001', 'Ciudad de México', 'Ingeniería en Sistemas', 1, 'A', 'soltero', 2),
    ('Natalia', 'Sánchez', 'Rodríguez', '2001-04-18', '5530334455', 'natalia.sanchez@example.com', 'Calle Segunda', 232, 'Roma Norte', '55101', 'Ciudad de México', 'Ingeniería en Sistemas', 2, 'B', 'casado', 3),
    ('Alberto', 'Jiménez', 'González', '2000-10-25', '5540445566', 'alberto.jimenez@example.com', 'Av. Tercera', 343, 'Coyoacán', '55201', 'Ciudad de México', 'Ingeniería en Sistemas', 3, 'C', 'soltero', 1),
    ('Gabriela', 'López', 'Martínez', '2002-06-05', '5550556677', 'gabriela.lopez@example.com', 'Calle Cuarta', 454, 'Juárez', '55301', 'Ciudad de México', 'Ingeniería en Sistemas', 4, 'D', 'casado', 2),
    ('Fernando', 'Hernández', 'Pérez', '2001-12-15', '5560667788', 'fernando.hernandez@example.com', 'Av. Quinta', 565, 'Condesa', '55401', 'Ciudad de México', 'Ingeniería en Sistemas', 5, 'E', 'soltero', 3),
    ('Sofía', 'González', 'Ruiz', '2000-02-22', '5570778899', 'sofia.gonzalez@example.com', 'Calle Sexta', 676, 'Del Valle', '55501', 'Ciudad de México', 'Ingeniería en Sistemas', 6, 'F', 'casado', 1),
    ('Daniel', 'Pérez', 'López', '2002-08-08', '5580889900', 'daniel.perez@example.com', 'Av. Séptima', 787, 'Roma Norte', '55601', 'Ciudad de México', 'Ingeniería en Sistemas', 1, 'A', 'soltero', 2),
    ('Martina', 'García', 'Hernández', '2001-03-30', '5590990011', 'martina.garcia@example.com', 'Calle Octava', 898, 'Coyoacán', '55701', 'Ciudad de México', 'Ingeniería en Sistemas', 2, 'B', 'casado', 3),
    ('Hugo', 'Rodríguez', 'González', '2000-09-19', '5511001122', 'hugo.rodriguez@example.com', 'Av. Novena', 909, 'Juárez', '55801', 'Ciudad de México', 'Ingeniería en Sistemas', 3, 'C', 'soltero', 1),
    ('Marta', 'Fernández', 'Pérez', '2002-11-11', '5521112233', 'marta.fernandez@example.com', 'Calle Décima', 101, 'Condesa', '55901', 'Ciudad de México', 'Ingeniería en Sistemas', 4, 'D', 'casado', 2);
-- Reportes de Tutores
INSERT INTO Reportes_Tutor (fecha, reporte, id_tutor, id_alumno, prom_general)
VALUES
    ('2024-05-25', 'Buen desempeño en las tareas y participación en clase.', 1, 1, 8.50),
    ('2024-05-25', 'Necesita mejorar la entrega de tareas.', 1, 2, 6.75),
    ('2024-05-25', 'Excelente trabajo en equipo.', 2, 3, 9.00),
    ('2024-05-25', 'Buenas notas en los exámenes, puede avanzar al siguiente nivel.', 2, 4, 8.00),
	 ('2024-05-26', 'MAl.', 1, 3, 5.50);

-- Administrador
INSERT INTO Administrador (nombre, apellido, telefono)
VALUES ('Administrador', 'Principal', '5556667788');

-- Usuarios de ejemplo
INSERT INTO Usuarios (codigo_usuario, contrasena, tipo_usuario, id_alumno )
VALUES
    ('anamartinez', 'contrasena123', 'alumno', 1);	
    INSERT INTO Usuarios (codigo_usuario, contrasena, tipo_usuario, id_tutor )
VALUES
    ('juangonzalez', 'contrasena456', 'tutor', 1);
    INSERT INTO Usuarios (codigo_usuario, contrasena, tipo_usuario, id_admin )
VALUES
    ('adminprincipal', 'admin123', 'administrador', 1);
    
