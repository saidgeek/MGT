'use strict'

template = require './template'

module.exports = {
  html: """
    #{ template.header }

      <p>
        <%= to %> la solicitud "<%= title %>" con código de referencia <b><%= code %></b>, a actualizado su estado a <b><%= state.toLowerCase() %></b> para acceder a ella solo debes hacer click <a class="ir" href="<%= url %>">aquí</a>. 
      </p>

    #{ template.footer }
  """
  text: """
    <%= to %> la solicitud "<%= title %>" con código de referencia <b><%= code %></b>, a actualizado su estado a <b><%= state.toLowerCase() %></b>.
    link: <%= url %>
  """
}