# Sistema de Gestión de Inventario

Aplicación web desarrollada en **Ruby on Rails 8** para gestionar artículos y personas en un sistema de inventario, incluyendo las transferencias de portadores.

## 🎯 Objetivo

Construir una aplicación web que permita **gestionar artículos y personas** en un sistema de inventario, incluyendo las transferencias de portadores.

## 🛠️ Tecnologías

- **Ruby on Rails 8.0.2**
- **SQLite3** (base de datos)
- **Hotwire** (Turbo + Stimulus) para interacción UI
- **Tailwind CSS** para estilos

## 📋 Reglas de Negocio

### Artículos
- Cada artículo tiene:
  - Identificador único
  - Modelo
  - Marca
  - Fecha de ingreso
- Cada artículo tiene un **portador actual**, que es una persona.

### Personas
- Cada persona tiene:
  - Identificador único
  - Nombre
  - Apellido
- Cada persona puede portar **cero o más artículos**.

### Transferencias
- Un artículo puede ser transferido de una persona a otra.
- Se mantiene un **historial de portadores** por artículo.
- Se mantiene un **historial de artículos portados** por persona.

## ✅ Funcionalidades Implementadas

### Funcionalidades Mínimas
- ✅ **Listar artículos**
- ✅ **Detalle de artículo**
  - Datos básicos
  - Portador actual
  - Historial de portadores
- ✅ **Listar personas**
  - Datos básicos
  - Artículos que porta actualmente
  - Historial de artículos portados
- ✅ **Agregar artículo**
- ✅ **Agregar persona**
- ✅ **Registrar transferencia de artículo**
- ✅ **Seeds obligatorias** con:
  - 3 personas
  - 5 artículos
  - 2 transferencias cargadas

### Funcionalidades Opcionales
- ✅ **Filtros de artículos** por marca, modelo y fecha de ingreso
- ❌ ABM de marcas y modelos (no implementado)
- ❌ Exportar/Importar CSV (no implementado)
- ❌ Login básico (no implementado)
- ❌ API JSON (no implementado)

## 🏗️ Diseño de la Solución

### Modelo de Datos

```
Person (Persona)
├── id (PK)
├── first_name (string, required)
├── last_name (string, required)
├── created_at, updated_at
└── Relaciones:
    ├── has_many :current_articles
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

### Decisiones de Diseño

#### Base de Datos
- **SQLite3** para simplicidad en desarrollo y despliegue
- **Foreign keys** con restricciones de integridad
- **Índices** en campos de búsqueda frecuente
- **dependent: :restrict_with_error** para mantener integridad referencial

#### Arquitectura
- **MVC tradicional** de Rails con Hotwire para interactividad
- **Tailwind CSS** para diseño moderno y mantenible
- **Validaciones robustas** tanto en modelo como en controlador

#### UI/UX
- **Diseño responsivo** que funciona en móviles y desktop
- **Navegación intuitiva** con breadcrumbs y enlaces contextuales
- **Formularios con validación** y manejo de errores
- **Filtros dinámicos** para mejorar la experiencia de búsqueda

## 📋 Planificación del Proyecto

### Tareas Completadas
1. ✅ **Diseño del modelo de datos** - Entidades y relaciones
2. ✅ **Configuración del proyecto Rails 8** - Gemfile y configuración
3. ✅ **Implementación de modelos** - Person, Article, Transfer
4. ✅ **Migraciones de base de datos** - Estructura y foreign keys
5. ✅ **Controladores CRUD** - Articles, People, Transfers
6. ✅ **Vistas con Tailwind CSS** - Diseño moderno y responsive
7. ✅ **Validaciones de negocio** - Integridad de datos
8. ✅ **Sistema de transferencias** - Lógica compleja con callbacks
9. ✅ **Filtros avanzados** - Búsqueda por múltiples criterios
10. ✅ **Seeds con datos de ejemplo** - 3 personas, 5 artículos, 2 transferencias
11. ✅ **Pruebas automatizadas** - Minitest y RSpec
12. ✅ **Documentación** - README completo

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
rails db:create
rails db:migrate
rails db:seed
```

4. **Compilar assets**
```bash
rails tailwindcss:build
```

5. **Ejecutar la aplicación**
```bash
dev
```

La aplicación estará disponible en `http://localhost:3000`

### Comandos Útiles
- **Ejecutar pruebas**: `rails test && bundle exec rspec`
- **Consola Rails**: `rails console`
- **Recargar seeds**: `rails db:seed`

## 🧪 Pruebas Automatizadas

El proyecto incluye pruebas automatizadas que cubren:

### Cobertura Mínima Requerida
- ✅ **Modelo de datos** - Validaciones y relaciones
- ✅ **Registro de transferencias** - Lógica de negocio compleja
- ✅ **Validaciones básicas** - Integridad y restricciones

### Frameworks de Testing
- **Minitest** (controladores): 19 tests, 31 assertions
- **RSpec** (modelos): Cobertura completa de validaciones y métodos
- **Factory Bot**: Datos de prueba consistentes

### Ejecutar Pruebas
```bash
# Minitest (controladores)
rails test

# RSpec (modelos)
bundle exec rspec

# Todas las pruebas
rails test && bundle exec rspec
```

## 📊 Datos de Ejemplo (Seeds)

### Personas (3)
- Juan Pérez
- María González
- Carlos Rodríguez

### Artículos (5)
- Dell Latitude 5520 (portador actual según transferencias)
- HP EliteBook 840 (portador actual según transferencias)
- Lenovo ThinkPad X1 Carbon (Carlos)
- Apple MacBook Pro 14 (Juan)
- ASUS ZenBook 14 (María)

### Transferencias (2)
- Dell Latitude: Juan → María (hace 3 meses)
- HP EliteBook: María → Carlos (hace 1 mes)

## 🔄 Flujo de Trabajo Principal

1. **Crear personas** en el sistema
2. **Agregar artículos** asignándolos a personas
3. **Registrar transferencias** cuando cambien de portador
4. **Consultar historiales** de artículos y personas
5. **Filtrar y buscar** información específica

---

**Desarrollado con Ruby on Rails 8**
