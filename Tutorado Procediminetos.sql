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
    SELECT t.id_tutor, p.nombre, p.apellido_P, p.apellido_M, p.sexo, p.fecha_nac, p.telefono, p.correo, p.calle, p.numero, p.colonia, p.cp, p.departamento
    FROM Tutores t
    INNER JOIN Profesores p ON t.id_tutor = p.id_profesor;
END$$

CREATE PROCEDURE VerAlumnos()
BEGIN
    SELECT a.id_alumno, a.nombre, a.apellido_P, a.apellido_M, a.fecha_nac, a.telefono, a.correo, a.calle, a.numero, a.colonia, a.cp, a.departamento, a.carrera, a.semestre, a.horario_no, a.estado_civil,
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
    INNER JOIN Tutores t ON rt.id_tutor = t.id_tutor
    INNER JOIN Profesores p ON t.id_tutor = p.id_profesor
    INNER JOIN Alumnos a ON rt.id_alumno = a.id_alumno
    WHERE t.id_tutor = tutor_id;
END$$

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

DELIMITER ;