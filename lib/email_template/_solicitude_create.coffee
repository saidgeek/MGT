'use strict'

template = require './template'

module.exports = {
  html: """
    #{ template.header }
      
      <p>
        Se creado esta nueva solicitude "<%= title %>" con codigo: <%= code %>.
      </p>
      <a class="ir" href="<%= url %>">Ir a la Solicitud</a>

    #{ template.footer }
  """
  text: """
    Se creado esta nueva solicitude "<%= title %>" con codigo: <%= code %>.
    link: <%= url %>
  """
}