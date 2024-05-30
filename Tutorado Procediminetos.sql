DELIMITER $$

-- Procedimiento para agregar un grupo de tutorías
CREATE PROCEDURE AgregarGrupoTutorias(
    IN p_nombre_grupo VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_id_tutor INT
)
BEGIN
    INSERT INTO Grupos_Tutorias (nombre_grupo, descripcion, id_tutor)
    VALUES (p_nombre_grupo, p_descripcion, p_id_tutor);
END$$

-- Procedimiento para actualizar un grupo de tutorías
CREATE PROCEDURE ActualizarGrupoTutorias(
    IN p_id_grupo INT,
    IN p_nombre_grupo VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_id_tutor INT
)
BEGIN
    UPDATE Grupos_Tutorias
    SET nombre_grupo = p_nombre_grupo,
        descripcion = p_descripcion,
        id_tutor = p_id_tutor
    WHERE id_grupo = p_id_grupo;
END$$

-- Procedimiento para eliminar un grupo de tutorías
CREATE PROCEDURE EliminarGrupoTutorias(
    IN p_id_grupo INT
)
BEGIN
    DELETE FROM Grupos_Tutorias WHERE id_grupo = p_id_grupo;
END$$

-- Procedimiento para asignar un alumno a un grupo de tutorías
CREATE PROCEDURE AsignarAlumnoGrupo(
    IN p_id_alumno INT,
    IN p_id_grupo INT
)
BEGIN
    DECLARE cantidad_alumnos INT;

    -- Contar la cantidad de alumnos en el grupo
    SELECT COUNT(*) INTO cantidad_alumnos
    FROM Alumnos
    WHERE id_grupo = p_id_grupo;

    -- Verificar si la cantidad de alumnos es menor a 40
    IF cantidad_alumnos < 40 THEN
        -- Asignar el alumno al grupo
        UPDATE Alumnos
        SET id_grupo = p_id_grupo
        WHERE id_alumno = p_id_alumno;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El grupo ya tiene 40 alumnos.';
    END IF;
END$$

-- Procedimiento para eliminar un alumno de un grupo de tutorías
CREATE PROCEDURE EliminarAlumnoGrupo(
    IN p_id_alumno INT
)
BEGIN
    UPDATE Alumnos
    SET id_grupo = NULL
    WHERE id_alumno = p_id_alumno;
END$$

CREATE PROCEDURE VerProfesores()
BEGIN
    SELECT id_profesor, nombre, apellido_P, apellido_M, sexo, fecha_nac, telefono, correo, calle, numero, colonia, cp, departamento
    FROM Profesores;
END$$

CREATE PROCEDURE VerTutores()
BEGIN
    SELECT t.id_tutor,
    p.nombre, p.apellido_P, p.apellido_M, p.sexo, p.fecha_nac, p.telefono, p.correo, p.calle, p.numero, p.colonia, p.cp, p.departamento
    FROM Tutores t
    INNER JOIN Profesores p ON t.id_tutor = p.id_profesor;
END$$

CREATE PROCEDURE VerAlumnos()
BEGIN
    SELECT a.id_alumno,
    CONCAT(a.nombre, ' ', a.apellido_P, ' ', a.apellido_M) AS nombre_completo,
    a.fecha_nac, a.telefono, a.correo, a.calle, a.numero, a.colonia, a.cp, a.departamento, a.carrera, a.semestre, a.horario_no, a.estado_civil,
           g.nombre_grupo AS grupo_tutorias
    FROM Alumnos a
    LEFT JOIN Grupos_Tutorias g ON a.id_grupo = g.id_grupo;
END$$

CREATE PROCEDURE VerGruposTutorias()
BEGIN
    SELECT g.id_grupo, g.nombre_grupo, g.descripcion, p.nombre AS nombre_tutor, p.apellido_P AS apellido_P_tutor, p.apellido_M AS apellido_M_tutor
    FROM Grupos_Tutorias g
    LEFT JOIN Tutores t ON g.id_tutor = t.id_tutor
    LEFT JOIN Profesores p ON t.id_tutor = p.id_profesor;
END$$


CREATE PROCEDURE VerGruposTutoriasID(IN id_tutor INT)
BEGIN
    SELECT g.id_grupo, g.nombre_grupo, g.descripcion, p.nombre AS nombre_tutor, p.apellido_P AS apellido_P_tutor, p.apellido_M AS apellido_M_tutor
    FROM Grupos_Tutorias g
    LEFT JOIN Tutores t ON g.id_tutor = t.id_tutor
    LEFT JOIN Profesores p ON t.id_tutor = p.id_profesor
    WHERE t.id_tutor = id_tutor;
END$$

CREATE PROCEDURE VerReportesTutor()
BEGIN
    SELECT rt.id_reporte, 
           t.id_tutor, 
           p.nombre AS nombre_tutor, 
           p.apellido_P AS apellido_P_tutor, 
           p.apellido_M AS apellido_M_tutor,
           a.id_alumno, 
           a.nombre AS nombre_alumno, 
           a.apellido_P AS apellido_P_alumno, 
           a.apellido_M AS apellido_M_alumno,
           rt.fecha, 
           rt.reporte,
           rt.prom_general
    FROM Reportes_Tutor rt
    INNER JOIN Tutores t ON rt.id_tutor = t.id_tutor
    INNER JOIN Profesores p ON t.id_tutor = p.id_profesor
    INNER JOIN Alumnos a ON rt.id_alumno = a.id_alumno;
END$$

CREATE PROCEDURE VerReportesTutorID(IN tutor_id INT)
BEGIN
    SELECT rt.id_reporte, 
           t.id_tutor, 
           CONCAT(p.nombre, ' ', p.apellido_P, ' ', p.apellido_M) AS nombre_completo_tutor,
           a.id_alumno, 
           CONCAT(a.nombre, ' ', a.apellido_P, ' ', a.apellido_M) AS nombre_completo_alumno,
           rt.fecha, 
           rt.reporte,
           rt.prom_general
    FROM Reportes_Tutor rt
INNER JOIN Alumnos a ON rt.id_alumno = a.id_alumno
    INNER JOIN Grupos_Tutorias gt ON a.id_grupo = gt.id_grupo
    INNER JOIN Tutores t ON gt.id_tutor = t.id_tutor
    INNER JOIN Profesores p ON t.id_tutor = p.id_profesor
    WHERE t.id_tutor = tutor_id;
END$$

call VerReportesTutorID(1);
CREATE PROCEDURE VerReportesAlumnosID(IN alumno_id INT)
BEGIN
    SELECT rt.id_reporte,
           rt.fecha,
           rt.reporte,
           rt.prom_general
    FROM Reportes_Tutor rt
    WHERE rt.id_alumno = alumno_id;
END$$

CREATE PROCEDURE VerAlumnosPorTutor(
    IN p_id_tutor INT
)
BEGIN
    SELECT p_id_tutor AS id_tutor,
			a.id_alumno,
           CONCAT(a.nombre, ' ', a.apellido_P, ' ', a.apellido_M) AS nombre_completo,
           a.telefono,
           a.carrera,
           a.semestre,
           g.nombre_grupo AS grupo_tutorias
    FROM Alumnos a
    INNER JOIN Grupos_Tutorias g ON a.id_grupo = g.id_grupo
    WHERE g.id_tutor = p_id_tutor;
END$$


CREATE PROCEDURE VerUsuarios()
BEGIN
    SELECT u.id_usuario,
           u.codigo_usuario,
           u.tipo_usuario,
			CASE 
               WHEN u.tipo_usuario = 'alumno' THEN u.id_alumno
               WHEN u.tipo_usuario = 'tutor' THEN u.id_tutor
               WHEN u.tipo_usuario = 'administrador' THEN u.id_admin
           END AS id_referencia,
           COALESCE(a.nombre, p.nombre, ad.nombre) AS nombre,
           COALESCE(a.apellido_P, p.apellido_P, ad.apellido) AS apellido,
           COALESCE(a.telefono, p.telefono, ad.telefono) AS telefono
    FROM Usuarios u
    LEFT JOIN Alumnos a ON u.id_alumno = a.id_alumno AND u.tipo_usuario = 'alumno'
    LEFT JOIN Profesores p ON u.id_tutor = p.id_profesor AND u.tipo_usuario = 'tutor'
    LEFT JOIN Administrador ad ON u.id_admin = ad.id_admin AND u.tipo_usuario = 'administrador';
END$$

CREATE PROCEDURE VerAlumnoPorID(
    IN p_id_alumno INT
)
BEGIN
    SELECT a.id_alumno, 
           a.nombre, 
           a.apellido_P, 
           a.apellido_M, 
           a.fecha_nac, 
           a.telefono, 
           a.correo, 
           a.calle, 
           a.numero, 
           a.colonia, 
           a.cp, 
           a.departamento, 
           a.carrera, 
           a.semestre, 
           a.horario_no, 
           a.estado_civil,
           g.nombre_grupo AS grupo_tutorias,
           CONCAT(p.nombre, ' ', p.apellido_P, ' ', p.apellido_M) AS nombre_tutor
    FROM Alumnos a
    LEFT JOIN Grupos_Tutorias g ON a.id_grupo = g.id_grupo
    LEFT JOIN Tutores t ON g.id_tutor = t.id_tutor
    LEFT JOIN Profesores p ON t.id_tutor = p.id_profesor
    WHERE a.id_alumno = p_id_alumno;
END$$
CREATE PROCEDURE VerSesion(
    IN p_codigo_usuario VARCHAR(50)
)
BEGIN
    SELECT u.id_usuario,
		   u.contrasena,
           u.codigo_usuario,
           u.tipo_usuario,
           CASE 
               WHEN u.tipo_usuario = 'alumno' THEN u.id_alumno
               WHEN u.tipo_usuario = 'tutor' THEN u.id_tutor
               WHEN u.tipo_usuario = 'administrador' THEN u.id_admin
           END AS id_referencia,
           COALESCE(a.nombre, p.nombre, ad.nombre) AS nombre,
           COALESCE(a.apellido_P, p.apellido_P, ad.apellido) AS apellido,
           COALESCE(a.telefono, p.telefono, ad.telefono) AS telefono
    FROM Usuarios u
    LEFT JOIN Alumnos a ON u.id_alumno = a.id_alumno AND u.tipo_usuario = 'alumno'
    LEFT JOIN Profesores p ON u.id_tutor = p.id_profesor AND u.tipo_usuario = 'tutor'
    LEFT JOIN Administrador ad ON u.id_admin = ad.id_admin AND u.tipo_usuario = 'administrador'
    WHERE u.codigo_usuario = p_codigo_usuario;
END$$

-- Procedimiento para editar los datos de un alumno
CREATE PROCEDURE EditarAlumno(
    IN p_id_alumno INT,
    IN p_telefono VARCHAR(15),
    IN p_correo VARCHAR(100),
    IN p_calle VARCHAR(100),
    IN p_numero VARCHAR(10),
    IN p_colonia VARCHAR(100),
    IN p_cp VARCHAR(10),
    IN p_departamento VARCHAR(100),
    IN p_estado_civil VARCHAR(20)
)
BEGIN
    UPDATE Alumnos
    SET telefono = p_telefono,
        correo = p_correo,
        calle = p_calle,
        numero = p_numero,
        colonia = p_colonia,
        cp = p_cp,
        departamento = p_departamento,
        estado_civil = p_estado_civil
    WHERE id_alumno = p_id_alumno;
END$$
CREATE PROCEDURE InsertarReporteTutor(
    IN p_id_tutor INT,
    IN p_id_alumno INT,
    IN p_prom_general DECIMAL(3,2),
    IN p_fecha DATE,
    IN p_reporte TEXT
)
BEGIN
    -- Verificar que el tutor exista
    IF (SELECT COUNT(*) FROM Tutores WHERE id_tutor = p_id_tutor) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tutor no existe.';
    END IF;

    -- Verificar que el alumno exista
    IF (SELECT COUNT(*) FROM Alumnos WHERE id_alumno = p_id_alumno) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El alumno no existe.';
    END IF;

    -- Insertar el reporte de tutoría
    INSERT INTO Reportes_Tutor (id_tutor, id_alumno, prom_general, fecha, reporte)
    VALUES (p_id_tutor, p_id_alumno, p_prom_general, p_fecha, p_reporte);
END $$

CREATE PROCEDURE VerProfesoresNoTutores()
BEGIN
    -- Selecciona solo las columnas específicas de la tabla Profesores que no tienen coincidencias en la tabla Tutores
    SELECT p.id_profesor, p.nombre, p.apellido_P, p.apellido_M, p.fecha_nac ,p.sexo, p.correo,telefono 
    FROM Profesores p
    LEFT JOIN Tutores t ON p.id_profesor = t.id_tutor
    WHERE t.id_tutor IS NULL;
END $$

CREATE PROCEDURE AsignarTutor(IN profesor_id INT)
BEGIN
    -- Verificar si el profesor existe en la tabla Profesores
    IF EXISTS (SELECT 1 FROM Profesores WHERE id_profesor = profesor_id) THEN
        -- Verificar si el profesor ya es tutor
        IF NOT EXISTS (SELECT 1 FROM Tutores WHERE id_tutor = profesor_id) THEN
            -- Insertar al profesor en la tabla Tutores
            INSERT INTO Tutores (id_tutor) VALUES (profesor_id);
        ELSE
            -- Mensaje en caso de que el profesor ya sea tutor
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor ya es tutor';
        END IF;
    ELSE
        -- Mensaje en caso de que el profesor no exista
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor no existe';
    END IF;
END $$
CREATE PROCEDURE VerAlumnosSinCuenta()
BEGIN
    SELECT a.id_alumno , CONCAT(a.nombre, ' ', a.apellido_P, ' ', a.apellido_M) AS nombre_completo, a.carrera , a.semestre
    FROM Alumnos a
    LEFT JOIN Usuarios u ON a.id_alumno = u.id_alumno AND u.tipo_usuario = 'alumno'
    WHERE u.id_alumno IS NULL;
END $$


CREATE PROCEDURE CrearUsuario(
    IN p_id INT,
    IN p_rol ENUM('alumno', 'tutor', 'administrador'),
    IN p_codigo_usuario VARCHAR(50),
    IN p_contrasena VARCHAR(100)
)
BEGIN
    DECLARE id_existente INT;
    
    -- Verificar si ya existe un usuario relacionado con el ID proporcionado
    SELECT 
        CASE 
            WHEN p_rol = 'alumno' THEN id_alumno
            WHEN p_rol = 'tutor' THEN id_tutor
            WHEN p_rol = 'administrador' THEN id_admin
        END INTO id_existente
    FROM Usuarios 
    WHERE 
        (tipo_usuario = p_rol) AND
        CASE 
            WHEN p_rol = 'alumno' THEN id_alumno = p_id
            WHEN p_rol = 'tutor' THEN id_tutor = p_id
            WHEN p_rol = 'administrador' THEN id_admin = p_id
        END;
    
    -- Si no existe un usuario relacionado con el ID proporcionado, se inserta el nuevo usuario
    IF id_existente IS NULL THEN
        INSERT INTO Usuarios (codigo_usuario, contrasena, tipo_usuario, id_alumno, id_tutor, id_admin) 
        VALUES (p_codigo_usuario, p_contrasena, p_rol,
                CASE WHEN p_rol = 'alumno' THEN p_id ELSE NULL END,
                CASE WHEN p_rol = 'tutor' THEN p_id ELSE NULL END,
                CASE WHEN p_rol = 'administrador' THEN p_id ELSE NULL END);
        SELECT 'Usuario creado exitosamente';
    ELSE
        SELECT 'El ID proporcionado ya está asociado a otro usuario';
    END IF;
END $$

CREATE PROCEDURE VerTutoresSinCuenta()
BEGIN
    SELECT p.id_profesor AS id_profesor , CONCAT(p.nombre, ' ', p.apellido_P, ' ', p.apellido_M) AS nombre_completo,p.sexo AS sexo , p.correo AS correo
    FROM Profesores p
    JOIN Tutores t ON p.id_profesor = t.id_tutor
    LEFT JOIN Usuarios u ON t.id_tutor = u.id_tutor AND u.tipo_usuario = 'tutor'
    WHERE u.id_tutor IS NULL;
END $$

CREATE PROCEDURE CrearAdministrador (
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_codigo_usuario VARCHAR(50),
    IN p_contrasena VARCHAR(100)
)
BEGIN
    DECLARE last_id INT;

    -- Insertar en la tabla Administrador
    INSERT INTO Administrador (nombre, apellido, telefono)
    VALUES (p_nombre, p_apellido, p_telefono);
    
    -- Obtener el último id_admin insertado
    SET last_id = LAST_INSERT_ID();
    
    -- Insertar en la tabla Usuarios
    INSERT INTO Usuarios (codigo_usuario, contrasena, tipo_usuario, id_admin)
    VALUES (p_codigo_usuario, p_contrasena, 'administrador', last_id);
END $$


CREATE PROCEDURE EditarUsuarioContrasena (
    IN p_id_usuario INT,
    IN p_nuevo_usuario VARCHAR(50),
    IN p_nueva_contrasena VARCHAR(100)
)
BEGIN
    -- Verificar si el usuario existe
    IF EXISTS (SELECT 1 FROM Usuarios WHERE id_usuario = p_id_usuario) THEN
        -- Actualizar el nombre de usuario y la contraseña
        UPDATE Usuarios
        SET codigo_usuario = p_nuevo_usuario,
            contrasena = p_nueva_contrasena
        WHERE id_usuario = p_id_usuario;
    ELSE
        -- Si el usuario no existe, lanzar un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario no encontrado';
    END IF;
END$$
DELIMITER ;


