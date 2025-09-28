# Blueprint: PorciApp

## Visión del Proyecto

**PorciApp** es una aplicación móvil desarrollada en Flutter, diseñada para facilitar la gestión de la cría y engorde de cerdos. La aplicación se centra en ofrecer una experiencia de usuario visualmente atractiva y amigable, utilizando ilustraciones y animaciones de estilo caricaturesco en lugar de fotografías reales. El objetivo es proporcionar una herramienta intuitiva y fácil de usar para los criadores de cerdos, ayudándoles a realizar un seguimiento de sus animales y a estimar sus ganancias de una manera sencilla y eficiente.

## Arquitectura y Diseño

La aplicación seguirá el patrón de diseño **Modelo-Vista-Controlador (MVC)**, lo que garantizará una separación clara de las responsabilidades y facilitará el mantenimiento y la escalabilidad del código.

- **Modelo:** Se encargará de la lógica de negocio y la gestión de los datos. Para la persistencia de datos, se utilizará **Hive**, una base de datos NoSQL ligera y rápida para Flutter.
- **Vista:** Se construirá con widgets de Flutter, creando una interfaz de usuario limpia y moderna, con un enfoque en la usabilidad y la estética visual.
- **Controlador:** Servirá como intermediario entre el Modelo y la Vista, gestionando el estado de la aplicación y la interacción del usuario. Se utilizará **BLoC** para el manejo del estado, lo que permitirá una gestión de estado predecible y robusta.

## Plan de Desarrollo

### Fase 1: Configuración del Proyecto y Estructura de Archivos

1.  **Inicialización del Proyecto:** Configurar el entorno de desarrollo de Flutter y crear la estructura de directorios inicial para el proyecto, siguiendo el patrón MVC.
2.  **Gestión de Dependencias:** Añadir las dependencias necesarias al archivo `pubspec.yaml`, incluyendo `flutter_bloc`, `hive`, `hive_flutter`, y cualquier otro paquete requerido para la interfaz de usuario y las animaciones.
3.  **Creación del `blueprint.md`:** Elaborar este documento para definir el alcance y la planificación del proyecto, asegurando que todos los involucrados tengan una comprensión clara de los objetivos.

### Fase 2: Implementación de la Interfaz de Usuario (UI)

1.  **Pantalla Principal:** Diseñar la pantalla de inicio con una barra de pestañas para las secciones de "Crianza" y "Engorda".
2.  **Diseño Visual:** Aplicar un estilo visual coherente en toda la aplicación, utilizando colores pastel, iconografía sencilla y una tipografía amigable.
3.  **Componentes Reutilizables:** Crear componentes de widget modulares y reutilizables para mantener un código limpio y eficiente.

### Fase 3: Integración de la Lógica de Negocio y Persistencia de Datos

1.  **Modelos de Datos:** Definir los modelos de datos para `Cerdas`, `CerdosEngorda` y `Configuracion`, y configurar las cajas de Hive correspondientes.
2.  **Lógica de Crianza:** Implementar las funcionalidades de la sección de "Crianza", incluyendo el cálculo de fechas de parto, el registro de cerditos y la estimación de ganancias.
3.  **Lógica de Engorda:** Desarrollar las funcionalidades de la sección de "Engorda", como el cálculo de ganancias basado en el peso y la importación de cerdos desde la sección de "Crianza".

### Fase 4: Animaciones y Mejoras Visuales

1.  **Animaciones de Estado:** Implementar animaciones que reflejen el estado de los cerdos, como el crecimiento durante el embarazo o los ciclos de día y noche.
2.  **Ilustraciones Personalizadas:** Crear o integrar ilustraciones de estilo caricaturesco para los cerdos y otros elementos de la granja.

### Fase 5: Pruebas y Despliegue

1.  **Pruebas Unitarias y de Widgets:** Realizar pruebas exhaustivas para asegurar la calidad y el correcto funcionamiento de la aplicación.
2.  **Optimización del Rendimiento:** Analizar y optimizar el rendimiento de la aplicación para garantizar una experiencia de usuario fluida.
3.  **Generación de Builds:** Preparar y generar los archivos de la aplicación para su despliegue en las plataformas de Android y iOS.
