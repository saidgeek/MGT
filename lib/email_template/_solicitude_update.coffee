'use strict'

template = require './template'

module.exports = {
  html: """
    #{ template.header }

      <p>
        La solicitud "<%= title %>", con código de referencia <b><%= code %></b>, ha sido actualizada.
        <br />
        <br />
        Su estado actual: <b><%= state.toLowerCase() %></b>.
        <br />
        <br />
        Ultima modificación por: "<%= updatedBy %>", el <%= updatedAt %>
        <br />
        <br />

        Has click <a class="ir" href="<%= url %>">aquí</a> para acceder a ella.

      </p>

    #{ template.footer }
  """
  text: """
    <%= to %> la solicitud "<%= title %>" con código de referencia <b><%= code %></b>, a actualizado su estado a <b><%= state.toLowerCase() %></b>.
    link: <%= url %>
  """
}