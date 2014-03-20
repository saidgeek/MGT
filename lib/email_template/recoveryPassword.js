'use strict';

module.exports = {
  html: "<html> \
            <head> \
              <title></title> \
            </head> \
            <body> \
              <p>Hola <%= name %>, te enviamos esta clave <%= password %>.</p> \
            </body> \
          </html>",
  text: "\
          Hola <%= name %>, te enviamos esta clave <%= password %>."
}