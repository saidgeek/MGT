'use strict';

module.exports = {
  html: "<html> \
            <head> \
              <title></title> \
            </head> \
            <body> \
              <p> \
                <%= name %>, la solicitud de trabajo <%= code %> esta pendiente de revisión. \
              </p> \
              <p> \
                Para darle seguimiento <a href='<%= url %>'>haz click aquí</a>. \
              </p> \
            </body> \
          </html>",
  text: "\
          <%= name %>, la solicitud de trabajo <%= code %> esta pendiente de revisión. \n \
          Para darle seguimiento <%= url %>."
}