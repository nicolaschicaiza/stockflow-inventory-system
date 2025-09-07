#!/bin/bash

# ================================
# SCRIPT DE INSTALACIÓN DE BD STOCKFLOW
# ================================

set -e  # Salir en caso de error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables de configuración
DB_NAME="stockflow"
DB_USER="stockflow_user"
DB_PASSWORD="stockflow_password"
DB_HOST="localhost"
DB_PORT="5432"

echo -e "${BLUE}🚀 Instalación de Base de Datos StockFlow${NC}"
echo "================================================"

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [OPCIÓN]"
    echo ""
    echo "Opciones:"
    echo "  --help, -h          Mostrar esta ayuda"
    echo "  --db-name NAME      Nombre de la base de datos (default: stockflow)"
    echo "  --db-user USER      Usuario de la base de datos (default: stockflow_user)"
    echo "  --db-password PASS  Contraseña del usuario (default: stockflow_password)"
    echo "  --db-host HOST      Host de PostgreSQL (default: localhost)"
    echo "  --db-port PORT      Puerto de PostgreSQL (default: 5432)"
    echo "  --skip-user         No crear usuario, usar usuario existente"
    echo "  --with-data         Insertar datos de prueba"
    echo ""
}

# Procesar argumentos
SKIP_USER=false
WITH_DATA=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_help
            exit 0
            ;;
        --db-name)
            DB_NAME="$2"
            shift 2
            ;;
        --db-user)
            DB_USER="$2"
            shift 2
            ;;
        --db-password)
            DB_PASSWORD="$2"
            shift 2
            ;;
        --db-host)
            DB_HOST="$2"
            shift 2
            ;;
        --db-port)
            DB_PORT="$2"
            shift 2
            ;;
        --skip-user)
            SKIP_USER=true
            shift
            ;;
        --with-data)
            WITH_DATA=true
            shift
            ;;
        *)
            echo -e "${RED}❌ Opción desconocida: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Verificar que PostgreSQL esté corriendo
echo -e "${YELLOW}🔍 Verificando PostgreSQL...${NC}"
if ! pg_isready -h "$DB_HOST" -p "$DB_PORT" > /dev/null 2>&1; then
    echo -e "${RED}❌ PostgreSQL no está corriendo o no es accesible en $DB_HOST:$DB_PORT${NC}"
    echo "Por favor, inicia PostgreSQL primero:"
    echo "  sudo systemctl start postgresql"
    echo "  # o"
    echo "  brew services start postgresql"
    exit 1
fi

echo -e "${GREEN}✅ PostgreSQL está corriendo${NC}"

# Crear usuario si no se especifica --skip-user
if [ "$SKIP_USER" = false ]; then
    echo -e "${YELLOW}👤 Creando usuario de base de datos...${NC}"
    sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || {
        echo -e "${YELLOW}⚠️  El usuario $DB_USER ya existe, continuando...${NC}"
    }
    sudo -u postgres psql -c "ALTER USER $DB_USER CREATEDB;"
fi

# Crear base de datos
echo -e "${YELLOW}🗄️  Creando base de datos $DB_NAME...${NC}"
sudo -u postgres createdb -O "$DB_USER" "$DB_NAME" 2>/dev/null || {
    echo -e "${YELLOW}⚠️  La base de datos $DB_NAME ya existe${NC}"
    read -p "¿Deseas recrearla? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}🗑️  Eliminando base de datos existente...${NC}"
        sudo -u postgres dropdb "$DB_NAME"
        sudo -u postgres createdb -O "$DB_USER" "$DB_NAME"
    else
        echo -e "${BLUE}ℹ️  Continuando con la base de datos existente${NC}"
    fi
}

# Verificar archivos necesarios
echo -e "${YELLOW}📁 Verificando archivos...${NC}"
if [ ! -f "schema.sql" ]; then
    echo -e "${YELLOW}⚠️  schema.sql no encontrado, generando desde DBML...${NC}"
    if command -v dbml2sql &> /dev/null; then
        dbml2sql schema.dbml --postgres -o schema.sql
        echo -e "${GREEN}✅ schema.sql generado${NC}"
    else
        echo -e "${RED}❌ dbml2sql no está instalado${NC}"
        echo "Instala con: npm install -g @dbml/cli"
        exit 1
    fi
fi

# Aplicar esquema
echo -e "${YELLOW}🏗️  Aplicando esquema de base de datos...${NC}"
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f schema.sql

# Aplicar triggers y funciones
echo -e "${YELLOW}⚙️  Aplicando triggers y funciones...${NC}"
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f triggers.sql

# Insertar datos de prueba si se especifica
if [ "$WITH_DATA" = true ]; then
    echo -e "${YELLOW}📊 Insertando datos de negocio...${NC}"
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f seeds.sql
    
    echo -e "${YELLOW}🎛️ Configurando sistema de control...${NC}"
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f app_control_seeds.sql
fi

# Verificar instalación
echo -e "${YELLOW}🔍 Verificando instalación...${NC}"
TABLE_COUNT=$(PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")

echo -e "${GREEN}✅ Instalación completada${NC}"
echo "================================================"
echo -e "${BLUE}📊 Resumen de la instalación:${NC}"
echo -e "  🗄️  Base de datos: ${GREEN}$DB_NAME${NC}"
echo -e "  👤 Usuario: ${GREEN}$DB_USER${NC}"
echo -e "  🏠 Host: ${GREEN}$DB_HOST:$DB_PORT${NC}"
echo -e "  📋 Tablas creadas: ${GREEN}$TABLE_COUNT${NC}"

# Mostrar información de conexión
echo ""
echo -e "${BLUE}🔌 Información de conexión:${NC}"
echo -e "  PostgreSQL URI: ${YELLOW}postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME${NC}"
echo ""
echo -e "${BLUE}🛠️  Comandos útiles:${NC}"
echo -e "  Conectar a la BD: ${YELLOW}psql postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME${NC}"
echo -e "  Ver tablas: ${YELLOW}\\dt${NC}"
echo -e "  Ver vistas: ${YELLOW}\\dv${NC}"

if [ "$WITH_DATA" = true ]; then
    echo ""
    echo -e "${BLUE}📊 Datos de prueba insertados:${NC}"
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "
        SELECT 'users' as tabla, COUNT(*) as registros FROM users
        UNION ALL SELECT 'products', COUNT(*) FROM products
        UNION ALL SELECT 'customers', COUNT(*) FROM customers
        UNION ALL SELECT 'sales', COUNT(*) FROM sales
        ORDER BY tabla;
    "
fi

echo ""
echo -e "${GREEN}🎉 ¡Base de datos StockFlow lista para usar!${NC}"