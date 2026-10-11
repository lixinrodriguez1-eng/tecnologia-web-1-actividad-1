# Bitácora de uso de Inteligencia Artificial

Herramienta: Claude (Anthropic), asistente conversacional. Cada sugerencia se ejecutó en el servidor y se verificó con `nginx -t`, los instaladores y los verificadores de cada laboratorio.

| # | Lab | Qué le pedí a la IA | Qué respondió / propuso | Cómo lo verifiqué | Qué aprendí o corregí |
|---|---|---|---|---|---|
| 1 | 2 | Interpretar el error `403 Forbidden` de `apt` dentro de Docker | Aislar la causa con pruebas desde Windows y desde contenedores; usar un espejo HTTPS | `docker run … apt-get update` funcionó por HTTPS; la imagen se construyó | Diagnosticar por eliminación antes de cambiar configuraciones |
| 2 | 2 | Por qué la imagen se construía pero no arrancaba (`/sbin/init`) | El `|| true` final se aplicaba a toda la cadena de `&&` y ocultaba el fallo de apt | Con `{ … || true; }` el build falla si apt falla | Un `|| true` mal ubicado oculta errores |
| 3 | 2 | Completar los TODO de `preparar_servidor.sh` | Comandos idempotentes (`getent … ||`, `[[ -f … ]] ||`) | Dos ejecuciones sin errores; `verificar_lab02.sh` 14/14 | Idempotencia; `groupadd` repetido devuelve código 9 |
| 4 | 3 | Por qué Nginx no arrancó tras instalarlo | `policy-rc.d` (código 101) bloquea el arranque en Docker | `systemctl start nginx` → active | Diferencia entre `enabled` y `active` |
| 5 | 3 | Explicar `/etc/nginx` y los enlaces simbólicos | Proponer el experimento de borrar y recrear el enlace | `Failed to connect` y luego `200 OK` con el mismo ETag | `sites-available` vs `sites-enabled` |
| 6 | 3 | Completar los 5 TODO de `horizonte-www.conf` | Directivas con explicación de cada una | `nginx -t` y verificador | `expires`, `autoindex`, `error_page` + `internal` |
| 7 | 3 | Pedí que escribiera `horizonte-portal.conf` | No lo escribió (la guía lo prohíbe); me guió a copiar el de www, recortarlo y tomar los valores del LEEME, y revisó mi versión (tenía valores corridos entre líneas) | Verificador: portal con su propia página | Diferencia entre `server_name` y `root` |
| 8 | 3 | Interpretar `[emerg] invalid parameter "listen"` y el `[warn]` del `index` | El error real está en la línea anterior; el `[warn]` oculta la pérdida del `access_log` | Restauré la copia y `nginx -t` correcto | Leer también las advertencias |
| 9 | 4 | Completar los 10 TODO (Nginx, sesión, systemd) | Configuración con socket `unix:/run/php/php8.3-fpm.sock` (no `127.0.0.1:9000`) | Verificador 16/16 | FastCGI vs proxy inverso; HttpOnly, SameSite, regeneración de ID |
| 10 | 4 | Interpretar cabeceras de `/api/eco` y mensajes del error.log | Quién agrega cada IP; causa de cada 502 | Detuve y reinicié cada servicio | `X-Forwarded-For` se puede falsificar |

**Reglas respetadas:** no pegué en la IA cookies completas, archivos de sesión reales ni hashes de usuarios reales (solo el usuario de prueba del laboratorio); no desactivé CSRF ni HttpOnly; no pedí el `horizonte-portal.conf` del Lab 3 hecho.
