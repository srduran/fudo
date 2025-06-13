# Product API - Rack App
API creada para dar solución al problema dado por el **technical challenge de FUDO**, esta API permite autenticación con JWT, gestión de productos, consulta de datos de usuario y documentación OpenAPI compatible con Swagger.

---

## Requisitos
- Ruby `>= 3.0`
- Bundler (`gem install bundler` en caso de no tenerlo)
- Archivo `.env` con las variables necesarias (ver más abajo)

---

## Instalación
```bash
$ git clone https://github.com/srduran/fudo.git
$ cd fudo
$ bundle install
```

---

## Cómo levantar el servidor
```bash
$ rackup
```
Esto iniciará el servidor en: http://localhost:9292

---

## Documentación API
- La API está documentada en formato OpenAPI. Se puede visualizar en Swagger Editor online (editor.swagger.io)
- Es necesario tener corriendo la app para poder conectarse a través de localhost.

### Autenticación
La API usa JWT para proteger los endpoints. El siguiente paso sirve para autenticarse:
```bash  
    POST /login
    URL: http://localhost:9292/login
    Body (JSON):
    {
      "user": "admin",
      "password": "1234"
    }
    Respuesta esperada:
    {
      "token": "<JWT_TOKEN>"
    }
```

En Postman o curl se debe enviar el token en el header:
`Authorization: Bearer <JWT_TOKEN>`

---

## Endpoints para probar
**GET** `/me` \
Requiere header **Authorization** \
Muestra el usuario autenticado y la fecha de expiración del token \
`curl -H "Authorization: Bearer <JWT_TOKEN>" http://localhost:9292/me`

**GET** `/products` \
Devuelve todos los productos registrados \
`curl -H "Authorization: Bearer <JWT_TOKEN>" http://localhost:9292/products`

**POST** `/products` \
Crea un nuevo producto
```bash
Body (JSON):
  {
  "name": "Café en grano"
  }
curl -X POST http://localhost:9292/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -d '{"name": "Café en grano"}'
```
---

## CORS
El proyecto incluye un middleware para permitir solicitudes desde navegadores o Swagger UI externo.

---

## zip (opcional)
La API comprime las respuestas JSON si el cliente incluye este header:
`Accept-Encoding: gzip`
Postman y navegadores lo suelen enviar por defecto. Se Puede desactivar desde los headers para ver la diferencia.

---

## Variables de entorno
Antes de levantar la aplicación, hay que asegurarse de definir las siguientes variables de entorno en un archivo .env en la raíz del proyecto. Puedes guiarte con el archivo .env.example incluido.

### Variables requeridas

| Variable     | Descripción                              | Ejemplo               |
| ------------ | ---------------------------------------- | --------------------- |
| `USER_ADMIN` | Usuario con permisos para iniciar sesión | `admin`               |
| `PASS_ADMIN` | Contraseña del usuario administrador     | `1234`                |
| `JWT_SECRET` | Clave secreta para firmar tokens JWT     | `jwt_secret_password` |

### Cómo configurar
Copia el archivo de ejemplo:
`cp .env.example .env`
Editamos el archivo .env ajustando los valores.