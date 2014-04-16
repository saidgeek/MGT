'use strict';

module.exports = {
  html: "<html> \
            <head> \
              <title></title> \
            </head> \
            <body> \
              <p> \
                <%= name %> has solicitado el restablecer tu contraseña.<br /> \
                Tu contraseña es: <%= password %> \
              </p> \
              <p>Haz click <a href='<%= link_login %>'>aquí</a> para acceder.</p> \
            </body> \
          </html>",
  text: "\
          Hola <%= name %>, te enviamos esta clave <%= password %>."
}
