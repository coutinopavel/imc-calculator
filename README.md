# Calculadora de IMC

Aplicación móvil desarrollada en Flutter que calcula el Índice de Masa Corporal (IMC) del usuario a partir de su peso y altura.

## ¿Para qué sirve?

Permite al usuario conocer su IMC de forma rápida y saber en qué categoría se encuentra según la Organización Mundial de la Salud:

- **Bajo peso:** IMC menor a 18.5
- **Normal:** IMC entre 18.5 y 24.9
- **Sobrepeso:** IMC entre 25 y 29.9
- **Obesidad:** IMC de 30 en adelante

## ¿Cómo funciona?

1. El usuario ingresa su peso (kg) y altura (cm)
2. La app calcula el IMC con la fórmula: peso / (altura en metros)²
3. Se muestra el resultado con un indicador de color según la categoría
4. Cada medición se guarda en un historial local con fecha y hora

## Tecnologías utilizadas

- **Flutter** (Dart)
- **shared_preferences** para almacenamiento local del historial

## Cómo ejecutar

```bash
cd imc_app
flutter pub get
flutter run
```

## APK

El archivo `app-release.apk` se encuentra en la raíz del repositorio para instalación directa en Android.

## Autor

Pavel Coutino
