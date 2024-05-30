// 1 - Invocamos a Express
const express = require('express');
const app = express();

//2 - Para poder capturar los datos del formulario (sin urlencoded nos devuelve "undefined")
app.use(express.urlencoded({extended:false}));
app.use(express.json());//además le decimos a express que vamos a usar json

//3- Invocamos a dotenv
const dotenv = require('dotenv');
dotenv.config({ path: './env/.env'});

//4 -seteamos el directorio de assets
app.use('/resources',express.static('public'));
app.use('/resources', express.static(__dirname + '/public'));

//5 - Establecemos el motor de plantillas
app.set('view engine','ejs');

//6 -Invocamos a bcrypt
const bcrypt = require('bcryptjs');

//7- variables de session
const session = require('express-session');
app.use(session({
	secret: 'secret',
	resave: true,
	saveUninitialized: true
}));


// 8 - Invocamos a la conexion de la DB
const connection = require('./database/db');

//9 - establecemos las rutas
	app.get('/login',(req, res)=>{
		res.render('login');
	})

	app.get('/register',(req, res)=>{
		res.render('register');
	})


// Método para la autenticación 
app.post('/auth', (req, res) => {
    const user = req.body.user;
    const pass = req.body.pass;

    if (user && pass) {
        connection.query('CALL VerSesion(?)', [user], function(error, results, fields) {
            if ( results[0][0].contrasena !== pass) {    
                res.send(results[0].contrasena);

                // Mensaje simple y poco vistoso
                // res.send('Incorrect Username and/or Password!');                
            } else {         
                // Creamos una var de session y le asignamos true si INICIO SESSION       
                req.session.loggedin = true;                
                req.session.name = results[0][0].codigo_usuario;
                req.session.rol = results[0][0].tipo_usuario;
                req.session.idref = results[0][0].id_referencia;
                res.render('login', {
                    alert: true,
                    alertTitle: "Conexión exitosa",
                    alertMessage: "¡LOGIN CORRECTO!",
                    alertIcon: 'success',
                    showConfirmButton: false,
                    timer: 1500,
                    ruta: ''
                });                    
            }            
            res.end();
        });
    } else {    
        res.send('Please enter user and Password!');
        res.end();
    }
});

//12 - Método para controlar que está auth en todas las páginas
// Middleware de autenticación
function authMiddleware(req, res, next) {
    if (req.session.loggedin) {
        next();
    } else {
        res.render('index', {
            login: false,
            name: 'Debe iniciar sesión',
        });
    }
}
app.get('/', authMiddleware, (req, res) => {
    res.render('index', {
        login: true,
        name: req.session.name,
        rol: req.session.rol
    });
});


//función para limpiar la caché luego del logout
app.use(function(req, res, next) {
    if (!req.user)
        res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate');
    next();
});

 //Logout
//Destruye la sesión.
app.get('/logout', function (req, res) {
	req.session.destroy(() => {
	  res.redirect('/') // siempre se ejecutará después de que se destruya la sesión
	})
});

//rutas pagina
//alumnos
app.get('/alumnos', authMiddleware, (req, res) => {
    let query;
    let params = []; // Array para almacenar los parámetros de la consulta

    // Filtrando por campos si están presentes en la consulta
    const { nombre, carrera, semestre } = req.query;

    if (req.session.rol == 'tutor') {
        query = 'Call VerAlumnosPorTutor(?)';
        params = [req.session.idref]; // Agregar el idref del tutor a los parámetros
    } else if (req.session.rol == 'administrador') {
        query = 'Call VerAlumnos()';
        // No se necesitan parámetros adicionales para esta consulta, params permanece vacío
    }

    if (req.session.rol !== 'alumno') {
        // Ejecutar la consulta inicial
        connection.query(query, params, (error, results) => {
            if (error) {
                throw error;
            } else {
                let alumnos = results[0];

                // Aplicar filtros en el servidor después de obtener los resultados
                if (nombre) {
                    alumnos = alumnos.filter(alumno => alumno.nombre_completo.toLowerCase().includes(nombre.toLowerCase()));
                }
                if (carrera) {
                    alumnos = alumnos.filter(alumno => alumno.carrera.toLowerCase().includes(carrera.toLowerCase()));
                }
                if (semestre) {
                    alumnos = alumnos.filter(alumno => alumno.semestre == semestre);
                }

                // Renderizar la vista con los resultados filtrados
                res.render('Alumnos', {
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,
                    results: alumnos
                });
            }
        });
    } else {
        res.render('Noautorizado', {
            login: true,
            name: req.session.name,
            rol: req.session.rol
        });
    }
});


//grupos
app.get('/grupos', authMiddleware, (req, res) => {
    let query;
    let params = []; // Array para almacenar los parámetros de la consulta
    if(req.session.rol == 'tutor') {
        query = 'Call VerGruposTutoriasID(?)';
        params = [req.session.idref]; // Agregar el idref del alumno a los parámetros
    }else if(req.session.rol == 'administrador') {
        query = 'Call VerGruposTutorias()';
        // No se necesitan parámetros adicionales para esta consulta, params permanece vacío
    }
    if (req.session.rol !== 'alumno') {
        // Ejecutar la consulta con la query y los params
        connection.query(query, params, (error, results) => {
        if (error) {
            throw error;
        } else {
            // Renderizar la vista reportes con los resultados obtenidos
            res.render('grupos', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,
                results: results[0]
            });
        }
    });
    } else {res.render('Noautorizado',{login: true,
        name: req.session.name,
        rol: req.session.rol}) }
    
});
//profesores
app.get('/profesores',authMiddleware,(req,res)=>{
    if (req.session.rol == 'administrador'){
        connection.query('Call VerProfesores()',(error,results)=>{
            if(error){
                throw error;
            }else{
                res.render('profesores', { 
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,  
                    results: results[0] 
                });
            }
        });
    }else {
            res.render('Noautorizado',{
                login: true,
                name: req.session.name,
                rol: req.session.rol}) 
    } 
});

//reporte
app.get('/reportes', authMiddleware, (req, res) => {
    let query;
    let params = []; // Array para almacenar los parámetros de la consulta
    if (req.session.rol == 'alumno') {
        query = 'Call VerReportesAlumnosID(?)';
        params = [req.session.idref]; // Agregar el idref del alumno a los parámetros
    } else if(req.session.rol == 'tutor') {
        query = 'Call VerReportesTutorID(?)';
        params = [req.session.idref]; // Agregar el idref del alumno a los parámetros
    }else if(req.session.rol == 'administrador') {
        query = 'Call VerReportesTutor()';
        // No se necesitan parámetros adicionales para esta consulta, params permanece vacío
    }
    // Ejecutar la consulta con la query y los params
    connection.query(query, params, (error, results) => {
        if (error) {
            throw error;
        } else {
            // Renderizar la vista reportes con los resultados obtenidos
            res.render('reportes', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,
                results: results[0]
            });
        }
    });
});

//tutores
app.get('/tutores',authMiddleware,(req,res)=>{
    
    if(req.session.rol == 'administrador'){
        connection.query('Call VerTutores()',(error,results)=>{
            if(error){
                throw error;
            }else{
                res.render('tutores', { 
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,  
                    sitio:0,  
                    results: results[0] });
            }
        });
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
    
});
//usuarios
app.get('/usuarios', authMiddleware, (req, res) => {
   if (req.session.rol == 'administrador'){
    connection.query('Call VerUsuarios()', (error, results) => {
        if (error) {
            throw error;
        } else {
            res.render('Usuarios', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,
                results: results[0]
            });
        }
    });
    }else {
        res.render('Noautorizado',{
            login: true,
            name: req.session.name,
            rol: req.session.rol}) 
        } 
});
//reportecreate
app.get('/reporteCreate', authMiddleware, (req, res) => {
    const alumnoId = null;
    if(req.session.rol == 'tutor'){
        res.render('ReporteCreate', {
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,
                    idref:req.session.idref,
                    idalum: alumnoId
                }); 
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
                
});
app.get('/reporteCreate/:id', authMiddleware, (req, res) => {
    const alumnoId = req.params.id;
    if(req.session.rol == 'tutor'){
        res.render('ReporteCreate', {
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,
                    idref:req.session.idref,
                    idalum: alumnoId
                }); 
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }

});
// Ruta para crear reporte
app.post('/reporteCreate',authMiddleware, (req, res) => {
    const { id_tutor,id_alumno,prom_general,fecha,reporte } = req.body;

    const sql = `CALL InsertarReporteTutor( ?, ?, ?, ?, ?)`;

    connection.query(sql, [id_tutor,id_alumno,prom_general,fecha,reporte], (err, result) => {
        if (err) throw err;
        res.redirect('/reportes'); // Redirige a la ruta deseada después de editar
    });
});

//infoalumnos ===
app.get('/infoAlumnos', authMiddleware, (req, res) => {
    connection.query('Call VerAlumnoPorID(?)',[req.session.idref], (error, results) => {
        if (error) {
            throw error;
        } else {
            res.render('Alumnoinfo', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,               
                results: results[0]
            });
        }
    });
});
//alumnosver
app.get('/alumno/:id', authMiddleware, (req, res) => {

    if (req.session.rol !== 'alumno') {
        const alumnoId = req.params.id;
        const query = 'CALL VerAlumnoPorID(?)';
        const params = [alumnoId];
        // Ejecutar la consulta con la query y los params
        connection.query(query, params, (error, results) => {
        if (error) {
            throw error;
        } else {
            // Renderizar la vista reportes con los resultados obtenidos
            res.render('Alumnoinfo', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,
                results: results[0]
            });
        }
    });
    } else {res.render('Noautorizado',{login: true,
        name: req.session.name,
        rol: req.session.rol}) }
    
});

//Edit_infoalumnos
app.get('/editar-alumno/:id', authMiddleware, (req, res) => {
    const alumnoId = req.params.id;
    const params = [alumnoId];
    if (alumnoId==req.session.idref && req.session.rol == 'alumno') {
    connection.query('Call VerAlumnoPorID(?)',[params], (error, results) => {
        if (error) {
            throw error;
        } else {
            res.render('alumnoeditar', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,               
                results: results[0]
            });
        }
    });
    } else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }

});
// Ruta para editar los datos de un alumno
app.post('/editar-alumno/:id_alumno',authMiddleware, (req, res) => {
    const id_alumno = req.params.id_alumno;
    const { telefono, correo, calle, numero, colonia, cp, departamento, estadoCivil } = req.body;

    const sql = `CALL EditarAlumno( ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    connection.query(sql, [id_alumno,telefono, correo, calle, numero, colonia, cp, departamento, estadoCivil], (err, result) => {
        if (err) throw err;
        res.redirect('/infoAlumnos'); // Redirige a la ruta deseada después de editar
    });
});

//crear registros
app.get('/create',(req,res)=>{
    
    res.render('create');
    
});
//tutorCreate
app.get('/tutorCreate',authMiddleware,(req,res)=>{
    
    if(req.session.rol == 'administrador'){
        connection.query('Call VerProfesoresNoTutores()',(error,results)=>{
            if(error){
                throw error;
            }else{
                res.render('tutores', { 
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,
                    sitio:1,  
                    results: results[0] });
            }
        });
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
    
});
app.get('/tutorCreate/:id',authMiddleware,(req,res)=>{
    
    if(req.session.rol == 'administrador'){
        const profesorId = req.params.id;
        const query = 'CALL AsignarTutor(?)';
        const params = [profesorId];
        connection.query(query, params, (error, results) => {
            if (error) {
                // Gestión de errores SQL
                console.error('Error al asignar tutor:', error);
                if (error.sqlState === '45000') {
                    // Mensaje personalizado para errores específicos
                    res.status(400).send(`Error: ${error.sqlMessage}`);
                } else {
                    // Mensaje general para otros errores
                    res.status(500).send('Ocurrió un error al asignar el tutor. Por favor, intenta de nuevo.');
                }
            }else{
                res.redirect('/tutores');
            }
        });
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
    
});

//UsuarioCreate
app.get('/UsuarioCreate',authMiddleware,(req,res)=>{  
    if(req.session.rol == 'administrador'){          
                res.render('rolseleccion', { 
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol
                })
}else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
    
});
app.get('/UsuarioCreateAlumnos',authMiddleware,(req,res)=>{  
    if(req.session.rol == 'administrador'){
        connection.query('Call VerAlumnosSinCuenta()',(error,results)=>{
            if(error){
                throw error;
            }else{
                res.render('plantillas/alumnostablec', { 
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,
                    sitio:1,  
                    results: results[0] });
            }
        });
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
    
});
app.get('/UsuarioCreateTutor',authMiddleware,(req,res)=>{  
    if(req.session.rol == 'administrador'){
        connection.query('Call VerTutoresSinCuenta()',(error,results)=>{
            if(error){
                throw error;
            }else{
                res.render('plantillas/tutortablec', { 
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,
                    sitio:1,  
                    results: results[0] });
            }
        });
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
});
app.get('/UsuarioCreateAdmin',authMiddleware,(req,res)=>{  
    if(req.session.rol == 'administrador'){          
                res.render('admincreate', { 
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol
                })
}else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
    
});

app.listen(3000, (req, res)=>{
    console.log('SERVER RUNNING IN http://localhost:3000');
});

//UsuarioCreate
app.get('/UsuarioCreate/:id/:rol', authMiddleware, (req, res) => {
    const alumnoId = req.params.id;//idref
    const roluser=req.params.rol
    if(req.session.rol == 'administrador'){
        res.render('UsuarioCreate', {
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,
                    idref:req.session.idref,
                    iduser: alumnoId,
                    roluserq:roluser
                }); 
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }

});
// Ruta para crear cuenta
app.post('/UsuarioCreate',authMiddleware, (req, res) => {
    const id_alumno = req.params.id_alumno;
    const { IDref, rolnewusuario, Usuario, Contrasena} = req.body;

    const sql = `CALL CrearUsuario( ?, ?, ?, ?)`;

    connection.query(sql, [IDref, rolnewusuario, Usuario, Contrasena], (err, result) => {
        if (err) throw err;
        res.redirect('/usuarios'); // Redirige a la ruta deseada después de editar
    });
});
// Ruta para editar ususario
app.get('/editarUsuario/:id/:user', authMiddleware, (req, res) => {
    const usuarioid = req.params.id;
    const params = [usuarioid];
    if ( req.session.rol == 'administrador') {     
            res.render('editarusuario', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,      
                usuarioid:usuarioid,
                user: req.params.user      
            });
        
    
    } else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }

});
//editarusuario
app.post('/editusuario',authMiddleware, (req, res) => {
   
    const { ID_Usuario,Usuario, Contrasena} = req.body;

    const sql = `CALL EditarUsuarioContrasena( ?, ?, ?)`;

    connection.query(sql, [ID_Usuario, Usuario, Contrasena], (error, result) => {
        if (error) {
            // Gestión de errores SQL
            console.error('Error al editar:', error);
            if (error.sqlState === '45000') {
                // Mensaje personalizado para errores específicos
                res.status(400).send(`Error: ${error.sqlMessage}`);
            } else {
                // Mensaje general para otros errores
                res.status(500).send('Ocurrió un error . Por favor, intenta de nuevo.');
            }
        }else{
             res.redirect('/usuarios'); // Redirige a la ruta deseada después de editar
        }
       
    });
});
//usuarui admid
app.post('/UsuarioCreateAdmin',authMiddleware, (req, res) => {
    const { Nombre, Apellidos, Telefono, Usuario,Contrasena} = req.body;

    const sql = `CALL CrearAdministrador( ?, ?, ?, ?,?)`;

    connection.query(sql, [Nombre, Apellidos, Telefono, Usuario,Contrasena], (err, result) => {
        if (err) throw err;
        res.redirect('/usuarios'); // Redirige a la ruta deseada después de editar
    });
});

//grupo seleccion tutor
app.get('/selectutor',authMiddleware,(req,res)=>{  
    if(req.session.rol == 'administrador'){
        connection.query('Call VerTutores()',(error,results)=>{
            if(error){
                throw error;
            }else{
                res.render('selecytutorgrupoc', { 
                    login: true,
                    name: req.session.name,
                    rol: req.session.rol,    
                    results: results[0] });
            }
        });
    }else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
    
});
//grupo creacion nombre desc
app.get('/GrupoSelect/:id',authMiddleware,(req,res)=>{
    
    if(req.session.rol == 'administrador'){
        const tutorId = req.params.id;   
            res.render('grupocreate', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,      
                tutorId:tutorId    
            });
        
    
    } else{
        res.render('Noautorizado',{login: true,
            name: req.session.name,
            rol: req.session.rol}) 
    }
});
//crear grupo
app.post('/GrupoCreate',authMiddleware, (req, res) => {
    const { ID_tutor, Nombre_Grupo, Descripcion} = req.body;

    const sql = `CALL AgregarGrupoTutorias( ?, ?, ?)`;

    connection.query(sql, [ Nombre_Grupo, Descripcion,ID_tutor], (err, result) => {
        if (err) throw err;
        res.redirect('/grupos'); // Redirige a la ruta deseada después de editar
    });
});