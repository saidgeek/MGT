'use strict';

module.exports = {
  html: "<html> \
            <head> \
              <title></title> \
            </head> \
            <body> \
              <p> \
                <%= name %>, tu solicitud de trabajo <%= code %> ha sido pausada por el siguiente motivo:
              </p> \
              <p> \
                <%= comment %>
              </p> \
              <p> \
                Para darle seguimiento <a href='<%= url %>'>haz click aquí</a>.
              </p> \
            </body> \
          </html>",
  text: "\
          <%= name %>, tu solicitud de trabajo <%= code %> ha sido pausada por el siguiente motivo: \n
          <%= comment %> \n
          Para darle seguimiento <%= url %>.
        "
