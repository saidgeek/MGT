'use strict';

module.exports = {
  html: "<html> \
            <head> \
              <title></title> \
            </head> \
            <body> \
              <p>Bienvenido <%= name %> al gestor de tareas de movistar, esta son tus credenciales de ingreso:<br /> \
              Email: <%= email %><br /> \
              Clave: <%= password %></p> \
            </body> \
          </html>",
  text: "\
          Bienvenido <%= name %> al gestor de tareas de movistar, esta son tus credenciales de ingreso:\n \
          Email: <%= email %>\n \
          Clave: <%= password %>"
}