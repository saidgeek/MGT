MGT
===

Requisitos de sistema para el ambiente de desarrollo
----------------------------------------------------

  > Paginas de referencia a las instalación en windows son solo una referencia

+ NVM: https://github.com/creationix/nvm (solo para mac o linux)

  > NVM es un manejador de versiones para node, este permite poder tener mas de una version de node instalada
  > en el computador

  ### Instalación:
    ``
      $ curl https://raw.github.com/creationix/nvm/v0.5.0/install.sh | sh
    ``

+ NodeJs: http://nodejs.org/

  > La version para usar en el proyecto es la 0.10.25

  ### Instalación al usar NVM:

  ``
    $ nvm install 0.10.25
  ``

  ### instalación:

  > Para instalar NodeJS, seguir los pasos que salen el a pagina segun el sistema operativo a usar http://nodejs.org/


+ MongoDB: https://www.mongodb.org/

  ### Instalación con brew (mac o linux):

  ``
    $ brew install mongodb
    # create db directory
    $ mkdir /usr/local/db
  ``

  ### Instalación en windows:
    http://docs.mongodb.org/manual/tutorial/install-mongodb-on-windows/

+ Redis: http://redis.io/

  ### Instalación con brew (mac o linux):

  ``
    $ brew install redis
  ``

  ### Instalación en windows
    http://www.codeproject.com/Articles/715967/Running-Redis-as-a-Windows-Service

+ Bower: http://bower.io/

  > Esto es cuando ya esta instalado nodejs

  ### instalación:

  ``
    $ npm install bower -g
  ``

+ GruntJS: http://gruntjs.com/

  > Esto es cuando ya esta instalado nodejs

  ### instalación:

  ``
    $ npm install grunt -g
  ``

Pasos para ejecutar el projecto
-------------------------------

  > Entrar a la carpeta del proyecto para realizar los siguientes pasos

  + En el caso de usar ***NVM***:
    ``
      $ nvm use
    ``
  + Ejecutar el servidor
    ``
      $ grunt serve
    ``
