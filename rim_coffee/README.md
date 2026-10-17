# Rim Coffee · Prototipo de interfaz (Flutter)

Prototipo visual, solo UI y datos simulados, de las **16 pantallas** del Anexo A
del instrumento de evaluación (Desarrollo de Aplicaciones Móviles).
Mantiene el estilo de los wireframes: blanco y negro, bordes marcados,
placeholders de imagen con diagonales y un único acento café.

## Cómo abrirlo en VS Code

1. Instala [Flutter](https://docs.flutter.dev/get-started/install) y la extensión **Flutter** de VS Code.
2. Descomprime la carpeta `rim_coffee` y ábrela en VS Code (*Archivo → Abrir carpeta*).
3. Abre la terminal integrada y ejecuta **una sola vez**:

   ```bash
   flutter create .
   flutter pub get
   ```

   `flutter create .` solo genera las carpetas de plataforma (`android/`, `web/`, etc.);
   **no sobrescribe** el código de `lib/`.
4. Presiona **F5** (o `flutter run`). Para verlo en el navegador: `flutter run -d chrome`.

## Cómo probarlo (recorrido sugerido)

La app abre en una pantalla de **demostración** que permite elegir perfil
(no es una de las 16 pantallas; en el sistema real son dos apps separadas).

**Cliente:** Bienvenida QR → Menú → toca un producto (Detalle) o usa +/– →
*Ver mi pedido* → Revisar y enviar → *Enviar pedido a barra* → Estado del pedido.
Si el carrito está vacío, la pestaña "Mi pedido" muestra el Carrito vacío.

**Administrador:** Acceso (o *¿Olvidaste tu contraseña?*) → Pedidos entrantes →
abre un pedido (Detalle y cobro) → *Cambiar* estado (Avanzar estado).
A los ~6 s llega un pedido nuevo con notificación emergente.
Pestañas: Productos, Reportes y Perfil (→ Códigos QR por mesa → *Simular escaneo*).

### Lo que está conectado entre pantallas
- El pedido que envía el cliente **aparece en Pedidos entrantes** del administrador.
- Si el administrador avanza el estado, **el cliente lo ve cambiar** en su pantalla (patrón Observer).
- Si el administrador **edita o elimina un producto**, el menú del cliente cambia al instante.
- Al avanzar todos los pedidos pendientes aparece la pantalla **Sin pedidos pendientes**.
- Productos repetidos se agrupan en una sola línea y el total se calcula solo.

## Las 16 pantallas

| # | Pantalla | Perfil | Archivo |
|---|----------|--------|---------|
| 1 | Menú | Cliente | `features/cliente/menu_screen.dart` |
| 2 | Revisar y enviar | Cliente | `features/cliente/revisar_enviar_screen.dart` |
| 3 | Estado del pedido | Cliente | `features/cliente/estado_pedido_screen.dart` |
| 4 | Acceso | Admin | `features/admin/acceso_screen.dart` |
| 5 | Pedidos entrantes | Admin | `features/admin/pedidos_screen.dart` |
| 6 | Detalle y cobro | Admin | `features/admin/detalle_cobro_screen.dart` |
| 7 | Avanzar estado | Admin | `features/admin/avanzar_estado_screen.dart` |
| 8 | Gestión de productos | Admin | `features/admin/productos_screen.dart` (+ `producto_form_sheet.dart`) |
| 9 | Reportes de ventas | Admin | `features/admin/reportes_screen.dart` |
| 10 | Detalle de producto | Cliente | `features/cliente/detalle_producto_screen.dart` |
| 11 | Carrito vacío | Cliente | `features/cliente/carrito_vacio_screen.dart` |
| 12 | Sin pedidos pendientes | Admin | estado vacío dentro de `pedidos_screen.dart` |
| 13 | Perfil | Admin | `features/admin/perfil_screen.dart` |
| 14 | Bienvenida QR | Cliente | `features/cliente/bienvenida_qr_screen.dart` |
| 15 | Códigos QR por mesa | Admin | `features/admin/codigos_qr_screen.dart` |
| 16 | Olvidé mi contraseña | Admin | `features/admin/recuperar_contrasena_screen.dart` |

## Estructura

```
rim_coffee/
├── pubspec.yaml
├── analysis_options.yaml
├── test/widget_test.dart
├── .vscode/                      # configuración de depuración
└── lib/
    ├── main.dart
    ├── app/                      # MaterialApp, tema, rutas
    │   ├── app.dart
    │   ├── app_router.dart
    │   ├── route_names.dart
    │   ├── route_args.dart
    │   └── theme.dart            # colores y estilo de campos
    ├── core/
    │   ├── models/               # Producto, Extra, LineaCarrito, Pedido
    │   ├── state/                # controladores en memoria (ChangeNotifier)
    │   ├── utils/formato.dart    # money(), horaActual()
    │   └── widgets/              # botones, campos, QR, stepper, barra inferior…
    └── features/
        ├── launcher/             # selector de perfil (solo demostración)
        ├── cliente/              # 6 pantallas del cliente
        └── admin/                # 10 pantallas del administrador
```

Sin paquetes externos: todo el estado vive en memoria con `ChangeNotifier`.
Los modelos corresponden a las entidades del diagrama entidad-relación
(`producto`, `extra`, `pedido`, `detalle_pedido`).

## Decisiones del prototipo
- **Ayuda** (pestaña del cliente) abre una hoja con "Llamar al mesero" y "Pedir la cuenta" en lugar de una pantalla aparte.
- **Perfil → Códigos QR por mesa** es el enlace que conecta la pantalla 13 con la 15.
- Los QR son dibujados (no escaneables); el botón *Simular escaneo* hace el papel del escaneo real.
- No hay backend, pagos ni persistencia: al reiniciar la app los datos vuelven al estado inicial.
