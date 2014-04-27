'use strict';

module.exports = {
  html: "<html> \
            <head> \
              <title></title> \
            </head> \
            <body> \
              <p> \
                <%= name %>, tu solicitud de trabajo <%= code %> ha sido aceptada.
              </p> \
              <p> \
                Para darle seguimiento <a href='<%= url %>'>haz click aquí</a>.
              </p> \
            </body> \
          </html>",
  text: "\
          <%= name %>, tu solicitud de trabajo <%= code %> ha sido aceptada. \n
          Para darle seguimiento <%= url %>.
        "
