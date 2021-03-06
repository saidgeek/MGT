'use strict';

module.exports = {
  html: "<html> \
            <head> \
              <title></title> \
            </head> \
            <body> \
              <p> \
                <%= name %>, la solicitud de trabajo <%= code %> esta en espera de asignacion de proveedor. \
              </p> \
              <p> \
                Para darle seguimiento <a href='<%= url %>'>haz click aquí</a>. \
              </p> \
            </body> \
          </html>",
  text: "\
          <%= name %>, la solicitud de trabajo <%= code %> esta en espera de asignacion de proveedor. \n \
          Para darle seguimiento <%= url %>."
}
