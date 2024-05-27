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


// Método para la autenticación sin encriptado
app.post('/auth', (req, res) => {
    const user = req.body.user;
    const pass = req.body.pass;

    if (user && pass) {
        connection.query('SELECT * FROM Usuarios WHERE codigo_usuario = ?', [user], (error, results, fields) => {
            if (results.length == 0 || results[0].contrasena !== pass) {    
                res.render('login', {
                    alert: true,
                    alertTitle: "Error",
                    alertMessage: "USUARIO y/o PASSWORD incorrectas",
                    alertIcon: 'error',
                    showConfirmButton: true,
                    timer: false,
                    ruta: 'login'
                });

                // Mensaje simple y poco vistoso
                // res.send('Incorrect Username and/or Password!');                
            } else {         
                // Creamos una var de session y le asignamos true si INICIO SESSION       
                req.session.loggedin = true;                
                req.session.name = results[0].codigo_usuario;
                req.session.rol = results[0].tipo_usuario;
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
    connection.query('Call VerAlumnos()', (error, results) => {
        if (error) {
            throw error;
        } else {
            res.render('alumnos', {
                login: true,
                name: req.session.name,
                rol: req.session.rol,
                results: results[0]
            });
        }
    });
});

//grupos
app.get('/grupos',authMiddleware,(req,res)=>{
    
    connection.query('Call VerGruposTutorias()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('grupos', { 
				login: true,
                name: req.session.name,
                results: results[0] });
        }
    });
    
});
//profesores
app.get('/profesores',authMiddleware,(req,res)=>{
    
    connection.query('Call VerProfesores()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('profesores', { 
				login: true,
                name: req.session.name,
                results: results[0] });
        }
    });
    
});
//reporte
app.get('/reportes',authMiddleware,(req,res)=>{
    
    connection.query('Call VerReportesTutor()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('reportes', { login: true,
                name: req.session.name,
                results: results[0]
			 });
        }
    });
    
});
//tutores
app.get('/tutores',authMiddleware,(req,res)=>{
    
    connection.query('Call VerTutores()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('tutores', { 
				login: true,
                name: req.session.name,
                results: results[0] });
        }
    });
    
});
//usuarios
app.get('/usuarios', authMiddleware, (req, res) => {
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
});
//crear registros
app.get('/create',(req,res)=>{
    
    res.render('create');
    
});


app.listen(3000, (req, res)=>{
    console.log('SERVER RUNNING IN http://localhost:3000');
});