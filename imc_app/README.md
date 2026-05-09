# Calculadora IMC

Aplicación móvil desarrollada en Flutter para calcular el Índice de Masa Corporal (IMC). Permite registrar mediciones, clasificarlas según los rangos establecidos por la OMS y mantener un historial persistente de los cálculos realizados.

## Características

- Cálculo del IMC a partir del peso (kg) y la altura (cm).
- Clasificación automática del resultado en cuatro categorías:
  - Bajo peso (menor a 18.5)
  - Normal (18.5 a 24.9)
  - Sobrepeso (25 a 29.9)
  - Obesidad (30 o mayor)
- Indicador visual con barra de rangos de IMC.
- Historial de mediciones con fecha y hora.
- Almacenamiento local mediante SharedPreferences.
- Opción para borrar el historial con diálogo de confirmación.
- Interfaz construida con Material 3 en tema oscuro.

## Requisitos

- Flutter SDK 3.0 o superior
- Dart
- Emulador Android, iOS o dispositivo físico

## Instalación

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/calculadora-imc.git
   cd calculadora-imc
   ```

2. Instalar las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

## Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.0
```

## Estructura del proyecto

```
lib/
└── main.dart
    ├── ImcApp                 # Widget raíz con MaterialApp
    ├── Medicion               # Modelo de datos (peso, altura, IMC, categoría, fecha)
    ├── CalculadoraScreen      # Pantalla principal con inputs y resultado
    └── HistorialScreen        # Pantalla de historial de mediciones
```

## Fórmula utilizada

El cálculo se realiza con la fórmula estándar:

```
IMC = peso (kg) / altura² (m)
```

La altura se ingresa en centímetros y se convierte internamente a metros antes del cálculo.

## Detalles técnicos

- Validación de entrada para descartar valores no numéricos, nulos o negativos.
- Serialización de las mediciones en formato JSON para su almacenamiento.
- Carga automática del historial al iniciar la aplicación.
- Las mediciones se ordenan de la más reciente a la más antigua.

## Mejoras pendientes

- Soporte para sistema imperial (libras y pulgadas).
- Gráfica de evolución del IMC a lo largo del tiempo.
- Exportación del historial a CSV o PDF.
- Modo claro.
- Internacionalización (i18n).

## Contribuciones

Para contribuir al proyecto:

1. Hacer un fork del repositorio.
2. Crear una rama para la nueva funcionalidad (`git checkout -b feature/nombre-funcion`).
3. Realizar los commits correspondientes.
4. Hacer push a la rama.
5. Abrir un Pull Request.

## Licencia

Este proyecto se distribuye bajo la licencia MIT. Consultar el archivo `LICENSE` para más detalles.

## Aviso

Esta aplicación tiene fines informativos. El IMC es un indicador general y no sustituye la valoración de un profesional de la salud.
