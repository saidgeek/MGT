'use strict'

module.exports = {
  header: """
    <html>
      <head>
        <meta charset="UTF-8">
        <title></title>

        <style>
          body {
            margin: 0;
            padding: 0;
            border: none;
          }
          table {
            margin: 0;
            padding: 0;
            border: none;
            width: 100%;
          }
          table td.header,
          table td.content {
            padding: 20px;
          }
          table td.content p {
            padding: 10px;
            color: #9da9b9;
          }
          table td.content a.ir {
            background: #00b8cf;
            margin: 10px;
            padding: 10px;
            color: #ffffff;
            text-decoration: none;
            text-align: center;
            font-size: 1em;
            float: right;
          }
          table td.footer p {
            text-align: center;
            padding: 5px;
            color: #ADADAD;
            border-top: 1px solid #adadad;
            font-size: 0.9em;
          }
        </style>

      </head>
      <body>
        <table>
          <tr bgcolor="#2f364a">
            <td class="header">
              <img src="http://gestor-movistar.ingeniavps.cl/images/movistar.png" alt="Movistar">
            </td>
          </tr>
          <tr>
            <td class="content">
  """
  footer: """
            </td>
          </tr>
          <tr>
            <td class="footer">
              <p>Gestor de tareas movistar</p>
            </td>
          </tr>
        </table>
      </body>
    </html>
  """
};