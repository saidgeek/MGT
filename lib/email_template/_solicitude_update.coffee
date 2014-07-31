'use strict'

template = require './template'

module.exports = {
  html: """
    #{ template.header }
      
      <p>
        La solicitud "<%= title %>" código: <%= code %> se ha actualizado.
      </p>
      <a class="ir" href="<%= url %>">Ir a la Solicitud</a>

    #{ template.footer }
  """
  text: """
    La solicitud "<%= title %>" código: <%= code %> se ha actualizado.
    link: <%= url %>
  """
}