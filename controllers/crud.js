const conexion =require('../database/db');

exports.save=(req,res)=>{
    //id de los camps
    const user=req.body.username;
    const rol=req.body.rol;
    conexion.query('INSERT INTO user set ?',{username:user,rol:rol},(error,results)=>{
        if(error){
            console.log(error);
        }else{
            res.redirect('/');
        }
    })
    console.log(user+" - "+rol);
}