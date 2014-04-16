'use strict';

module.exports = {
  html: "<html> \
            <head> \
              <title></title> \
            </head> \
            <body> \
              <p> \
                <%= name %>, te damos la bienvenida al Gestor de Tareas Movistar.<br /> \
                Tu perfil ha sido creado exitosamente.<br /> \
                Desde ahora podrás: \
              </p> \
              <% if (role === 'ADMIN' || role === 'ROOT') { %> \
                <p> \
                  <ul> \
                    <li>Crear nuevo usurios</li> \
                    <li>Eliminar usuarios existentes</li> \
                    <li>Editar usuarios existentes</li> \
                    <li>Validar solicitudes de trabajo, en especifico de caracter criticas</li> \
                  </ul> \
                </p> \
              <% } %> \
              <% if (role === 'CLIENT') { %> \
                <p> \
                  <ul> \
                    <li>Generar solicitudes de trabajo al equipo de contenidos web de Movistar.</li> \
                    <li>Revisar el estado de tus solicitudes</li> \
                    <li>Aprobar o rechazar propuestas en respuesta a tus solicitudes.</li> \
                    <li>Revisar y editar tu perfil de usuario.</li> \
                  </ul> \
                </p> \
              <% } %> \
              <% if (role === 'EDITOR') { %> \
                <p> \
                  <ul> \
                    <li>Aceptar, rechazar y cerrar las solicitudes de trabajo realizadas hacia el equipo de contenidos web de Movistar.</li> \
                    <li>Asignar tareas a los gestores de contenido.</li> \
                    <li>Conocer el estado de de avance de cada solicitud.</li> \
                    <li>Ver actividad de los Gestores de contenido.</li> \
                  </ul> \
                </p> \
              <% } %> \
              <% if (role === 'CONTENT_MANAGER') { %> \
                <p> \
                  <ul> \
                    <li>Recibir solicitudes de trabajo.</li> \
                    <li>Consultar el estado de las solicitudes que te serán asignadas.</li> \
                    <li>Enviar propuestas y respuestas para cada solicitud.</li> \
                    <li>Revisar y editar tu perfil de usuario.</li> \
                  </ul> \
                </p> \
              <% } %> \
              <% if (role === 'PROVIDER') { %> \
                <p> \
                  <ul> \
                    <li>Revisar lista de solicitudes.</li> \
                    <li>Aceptar, rechazar y responder solicitudes.</li> \
                    <li>Cerrar Tareas.</li> \
                    <li>Revisar y editar tu perfil de usuario.</li> \
                  </ul> \
                </p> \
              <% } %> \
              <p>Esta son tus credenciales de ingreso:<br /> \
              Email: <%= email %><br /> \
              Clave: <%= password %></p> \
              <p>Haz click <a href='<%= link_login %>'>aquí</a> para acceder.</p> \
            </body> \
          </html>",
  text: "\
          Bienvenido <%= name %> al gestor de tareas de movistar, esta son tus credenciales de ingreso:\n \
          Email: <%= email %>\n \
          Clave: <%= password %>"
}
