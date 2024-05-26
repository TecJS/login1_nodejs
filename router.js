const express = require('express');
const router= express();

router.get('/contacto',(req,res)=>{
    res.send('Esto es Contacto');
}); 
//ver registros
const conexion=require('./database/db');
router.get('/',(req,res)=>{
    
    conexion.query('Call VerTutores()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('index', { results: results[0] });
        }
    });
    
});
//alumnos
router.get('/alumnos',(req,res)=>{
    
    conexion.query('Call VerAlumnos()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('Alumnos', { results: results[0] });
        }
    });
    
});
//profesores
router.get('/alumnos',(req,res)=>{
    
    conexion.query('Call VerProfesores()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('profesores', { results: results[0] });
        }
    });
    
});
//grupos
router.get('/grupos',(req,res)=>{
    
    conexion.query('Call VerGruposTutorias()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('grupos', { results: results[0] });
        }
    });
    
});
//profesores
router.get('/profesores',(req,res)=>{
    
    conexion.query('Call VerProfesores()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('profesores', { results: results[0] });
        }
    });
    
});
//reporte
router.get('/reportes',(req,res)=>{
    
    conexion.query('Call VerReportesTutor()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('reportes', { results: results[0] });
        }
    });
    
});
//tutores
router.get('/tutores',(req,res)=>{
    
    conexion.query('Call VerTutores()',(error,results)=>{
        if(error){
            throw error;
        }else{
            res.render('tutores', { results: results[0] });
        }
    });
    
});
//crear registros
router.get('/create',(req,res)=>{
    
    res.render('create');
    
});



module.exports=router;