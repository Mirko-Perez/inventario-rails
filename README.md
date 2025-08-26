# Sistema de Gestión de Inventario

Una aplicación web desarrollada en **Ruby on Rails 8** para gestionar artículos y personas en un sistema de inventario, incluyendo el seguimiento de transferencias entre portadores.

## 🎯 Objetivo

Permitir la gestión completa de artículos y personas en un sistema de inventario, manteniendo un historial detallado de las transferencias de portadores de cada artículo.

## 🛠️ Tecnologías

- **Ruby 3.3.0**
- **Rails 8.0.2**
- **SQLite3** (base de datos)
- **Tailwind CSS** (estilos)
- **Hotwire/Turbo** (interactividad)
- **RSpec** y **Minitest** (pruebas)

## 📋 Funcionalidades Implementadas

### ✅ Funcionalidades Mínimas (Completadas)

- **Listar artículos** con filtros por marca, modelo y fecha de ingreso
- **Detalle de artículo** mostrando:
  - Datos básicos (marca, modelo, fecha de ingreso)
  - Portador actual
  - Historial completo de portadores
- **Listar personas** con información de artículos portados
- **Detalle de persona** mostrando:
  - Datos básicos (nombre, apellido)
  - Artículos que porta actualmente
  - Historial completo de artículos portados
- **Agregar artículo** con validaciones
- **Agregar persona** con validaciones
- **Registrar transferencia** de artículo entre personas
- **Seeds obligatorias** con:
  - 3 personas
  - 5 artículos
  - 2 transferencias

### 🎨 Características Adicionales

- **UI moderna** con Tailwind CSS
- **Navegación responsiva**
- **Formularios con validación** y manejo de errores
- **Filtros dinámicos** en listados
- **Historial completo** de transferencias
- **Validaciones de negocio** (ej: no eliminar persona con artículos asignados)

## 🏗️ Modelo de Datos

### Entidades y Relaciones

```
Person (Persona)
├── id (PK)
├── first_name (string, required)
├── last_name (string, required)
├── created_at, updated_at
└── Relaciones:
    ├── has_many :articles (current_articles)
    ├── has_many :transfers_from
    └── has_many :transfers_to

Article (Artículo)
├── id (PK)
├── brand (string, required)
├── model (string, required)
├── entry_date (date, required)
├── current_person_id (FK, required)
├── created_at, updated_at
└── Relaciones:
    ├── belongs_to :current_person
    └── has_many :transfers

Transfer (Transferencia)
├── id (PK)
├── article_id (FK, required)
├── from_person_id (FK, required)
├── to_person_id (FK, required)
├── transfer_date (date, required)
├── notes (text, optional)
├── created_at, updated_at
└── Relaciones:
    ├── belongs_to :article
    ├── belongs_to :from_person
    └── belongs_to :to_person
```

### Reglas de Negocio

- Cada artículo tiene exactamente un portador actual
- Una persona puede portar cero o más artículos
- Las transferencias mantienen el historial completo
- No se puede eliminar una persona que tiene artículos asignados
- Las transferencias deben tener personas origen y destino diferentes

## 🚀 Instalación y Ejecución

### Prerrequisitos

- Ruby 3.3.0
- Rails 8.0.2
- SQLite3

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd inventory_system
```

2. **Instalar dependencias**
```bash
bundle install
```

3. **Configurar la base de datos**
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

4. **Compilar assets**
```bash
bin/rails tailwindcss:build
```

5. **Ejecutar la aplicación**
```bash
bin/dev
```

La aplicación estará disponible en `http://localhost:3000`

### Comandos Útiles

- **Ejecutar pruebas**: `bin/rails test`
- **Ejecutar RSpec**: `bundle exec rspec`
- **Consola Rails**: `bin/rails console`
- **Recargar seeds**: `bin/rails db:seed`

## 🧪 Pruebas

El proyecto incluye pruebas automatizadas que cubren:

- **Modelos**: Validaciones y relaciones
- **Controladores**: Funcionalidad CRUD completa
- **Transferencias**: Lógica de negocio y validaciones
- **Integridad de datos**: Restricciones y reglas de negocio

### Ejecutar Pruebas

```bash
# Minitest (controladores)
bin/rails test

# RSpec (modelos)
bundle exec rspec

# Todas las pruebas
bin/rails test && bundle exec rspec
```

**Cobertura actual**: 19 pruebas, 31 aserciones, 0 fallos

## 📊 Datos de Ejemplo (Seeds)

El sistema incluye datos de ejemplo que se cargan automáticamente:

### Personas (3)
- Juan Pérez
- María González  
- Carlos Rodríguez

### Artículos (5)
- Dell Latitude 5520 (Juan)
- HP EliteBook 840 (Carlos - transferido)
- Lenovo ThinkPad X1 Carbon (Carlos)
- Apple MacBook Pro 14 (Juan)
- ASUS ZenBook 14 (María)

### Transferencias (2)
- Dell Latitude: Juan → María (hace 3 meses)
- HP EliteBook: María → Carlos (hace 1 mes)

## 🎨 Decisiones de Diseño

### Arquitectura
- **MVC tradicional** de Rails con Hotwire para interactividad
- **Tailwind CSS** para un diseño moderno y mantenible
- **SQLite** para simplicidad en desarrollo y despliegue

### UI/UX
- **Diseño responsivo** que funciona en móviles y desktop
- **Navegación intuitiva** con breadcrumbs y enlaces contextuales
- **Formularios con validación** en tiempo real
- **Filtros dinámicos** para mejorar la experiencia de búsqueda

### Base de Datos
- **Relaciones explícitas** con foreign keys y validaciones
- **Índices** en campos de búsqueda frecuente
- **Soft deletes** evitados para mantener integridad referencial

## 🔄 Flujo de Trabajo Principal

1. **Crear personas** en el sistema
2. **Agregar artículos** asignándolos a personas
3. **Registrar transferencias** cuando cambien de portador
4. **Consultar historiales** de artículos y personas
5. **Filtrar y buscar** información específica

## 📈 Funcionalidades Futuras (Opcionales)

- [ ] ABM de marcas y modelos
- [ ] Exportación/Importación CSV
- [ ] Sistema de autenticación con roles
- [ ] API REST JSON
- [ ] Notificaciones de transferencias
- [ ] Dashboard con métricas
- [ ] Búsqueda avanzada

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para la funcionalidad (`git checkout -b feature/nueva-funcionalidad`)
3. Commit los cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

---

**Desarrollado con ❤️ usando Ruby on Rails 8**
