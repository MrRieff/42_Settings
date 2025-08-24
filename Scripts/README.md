# 🚀 Project Generator

An interactive script that creates clean, production-ready React/TypeScript projects with your choice of:
- **Web Applications** (with directory routing)
- **Mobile Apps** (React Native)
- **Database Integration** (Firebase, MariaDB, Supabase)
- **Git Repository** (automatic initialization)
- **Admin User Creation** (automatic setup for all database types)

## ✨ Features

- 🎯 **Interactive Setup** - Choose project type, database, and location
- 📁 **Directory Routing** - Folders become URLs (web apps)
- 🗄️ **Database Ready** - Firebase, MariaDB+phpMyAdmin, or Supabase
- 🐳 **Docker Support** - MariaDB with phpMyAdmin included
- 🔧 **Environment Variables** - .env configuration ready
- 📱 **Cross-Platform** - Web and mobile from same codebase
- 🎨 **TypeScript** - Full type safety included
- 🧩 **Modular Structure** - Clean, textbook project organization
- 🔧 **Git Integration** - Automatic repository initialization with initial commit
- 🚫 **Port Conflict Detection** - Automatically finds available ports for Docker services
- 👤 **Admin User Setup** - Automatic admin user creation with proper database setup
- 🛠️ **npm Install Fixes** - Handles common npm installation issues automatically

## 🚀 Quick Start

### Option 1: Install as Command (Recommended)
```bash
# Clone or download this repository
git clone <this-repo>
cd AppBase

# Install the generator
./install.sh

# Restart your terminal, then use anywhere:
create-project
```

### Option 2: Run Directly
```bash
# Make executable and run
chmod +x create-project.sh
./create-project.sh
```

## 🎮 Interactive Setup

The script will ask you:

1. **📁 Project Location** - Where to create the project (use `.` for current directory)
2. **📝 Project Name** - What to name your project
3. **🎯 Project Type** - Web Application or Mobile App
4. **🗄️ Database** - None, Firebase, MariaDB+phpMyAdmin, or Supabase
5. **🔧 Git Repository** - Initialize Git repository with initial commit
6. **👤 Admin User** - Create admin user (if database selected)
   - Admin name
   - Admin email (with validation)
   - Admin password (with confirmation, min 8 characters)

## 🏗️ Generated Project Structure

### Web Application (with Directory Routing)
```
my-web-app/
├── app/                    # 📁 Routes (folder = URL)
│   ├── _layout.tsx        # Root layout
│   ├── index.tsx          # Home page (/)
│   └── about.tsx          # About page (/about)
├── src/
│   ├── components/        # 🧩 Reusable components
│   ├── hooks/            # 🪝 Custom React hooks
│   ├── lib/              # 🛠️ Utils, constants, config
│   ├── types/            # 📝 TypeScript definitions
│   └── api/              # 🌐 API client
├── scripts/              # 🔧 Setup scripts (if admin user)
├── database/             # 🗄️ Database files (if applicable)
├── .env                  # 🔧 Environment variables
├── .gitignore           # 🚫 Git ignore rules
└── package.json         # 📦 Dependencies
```

### Mobile App (Traditional Navigation)
```
my-mobile-app/
├── App.tsx               # 📱 Main app component
├── src/
│   ├── screens/          # 📱 App screens
│   ├── components/       # 🧩 Reusable components
│   ├── navigation/       # 🧭 Navigation config
│   ├── hooks/           # 🪝 Custom React hooks
│   ├── lib/             # 🛠️ Utils, constants, config
│   ├── types/           # 📝 TypeScript definitions
│   └── api/             # 🌐 API client
├── scripts/             # 🔧 Setup scripts (if admin user)
├── database/            # 🗄️ Database files (if applicable)
├── .env                 # 🔧 Environment variables
├── .gitignore          # 🚫 Git ignore rules
└── package.json         # 📦 Dependencies
```

## 🗄️ Database Options & Admin User Setup

### 🔥 Firebase
- **Cloud database** with real-time features
- Authentication included
- Automatic scaling
- **Admin Setup**: 
  - Creates `scripts/create-admin.js` 
  - Run after Firebase configuration
  - Creates user in Firebase Auth + Firestore profile

### 🐳 MariaDB + phpMyAdmin
- **Local database** with Docker
- phpMyAdmin web interface
- Full SQL database with admin user table
- **Automatic port detection** - finds available ports if defaults are in use
- **Admin Setup**: 
  - Admin user automatically inserted into database
  - Password hashed with SHA-256
  - Role-based user table with admin/user roles

### ⚡ Supabase
- **PostgreSQL** in the cloud
- Built-in authentication
- Real-time subscriptions
- **Admin Setup**: 
  - Creates `scripts/create-admin-supabase.js`
  - Creates `database/supabase-users-table.sql` migration
  - Includes Row Level Security policies
  - Creates user in Supabase Auth + users table

## 📁 Directory Routing (Web Apps)

Add pages by creating files in `app/`:

```
app/
├── index.tsx          → / (home)
├── about.tsx          → /about
├── contact.tsx        → /contact
└── blog/
    ├── index.tsx      → /blog
    ├── [slug].tsx     → /blog/my-post
    └── create.tsx     → /blog/create
```

## 🛠️ Development Commands

```bash
# Web Development
npm run dev          # Start web development server
npm run build        # Build for production

# Mobile Development  
npm start            # Start Expo development server
npm run ios          # Run on iOS simulator
npm run android      # Run on Android emulator

# Code Quality
npm run typecheck    # TypeScript validation
npm run lint         # ESLint checks
npm run format       # Prettier formatting
```

## 🔧 Environment Variables

Each project comes with `.env` configuration:

```bash
# App Configuration
EXPO_PUBLIC_APP_NAME=My App
EXPO_PUBLIC_API_URL=http://localhost:3000

# Database (based on your choice)
DATABASE_URL=your_database_url

# Firebase (if selected)
EXPO_PUBLIC_FIREBASE_API_KEY=your_key
EXPO_PUBLIC_FIREBASE_PROJECT_ID=your_project

# Supabase (if selected)  
EXPO_PUBLIC_SUPABASE_URL=your_url
EXPO_PUBLIC_SUPABASE_ANON_KEY=your_key
SUPABASE_SERVICE_ROLE_KEY=your_service_key  # For admin operations
```

## 👤 Admin User Management

### Database Schema
All database setups include a users table with:
- `id` - Primary key
- `name` - Full name
- `email` - Email address (unique)
- `password_hash` - Hashed password (MariaDB) or handled by service (Firebase/Supabase)
- `role` - 'admin' or 'user'
- `is_active` - Boolean status
- `created_at` / `updated_at` - Timestamps

### Admin User Creation Process

**MariaDB**: Admin user inserted directly into database with SHA-256 hashed password
**Firebase**: Script creates user in Firebase Auth + Firestore profile document
**Supabase**: Script creates user in Supabase Auth + users table with RLS policies

## 🐳 Docker Database Setup

When you choose MariaDB + phpMyAdmin, the generator:

1. **Detects port conflicts** - Automatically finds available ports
2. **Creates unique containers** - Named with your project name
3. **Sets up database** - Uses your project name as database name
4. **Provides access info** - Shows correct URLs and ports
5. **Creates admin user** - Automatically inserts admin user on startup

### Common Port Conflicts
If default ports are in use:
- **MariaDB**: 3306 → 3307, 3308, 3309, 3310
- **phpMyAdmin**: 8080 → 8081, 8082, 8083, 8084

## 🔧 Git Repository Integration

When you choose to initialize a Git repository:

1. **Automatic initialization** - `git init` in project directory
2. **Git config setup** - Prompts for username/email if not configured
3. **Initial commit** - Commits all generated files with descriptive message
4. **Ready for remote** - Easy to connect to GitHub, GitLab, etc.

```bash
# To connect to a remote repository:
git remote add origin <your-repository-url>
git branch -M main
git push -u origin main
```

## 🚨 Troubleshooting

### npm install issues
The generator automatically handles common npm install issues:

1. **Clears npm cache** before installation
2. **Tries --legacy-peer-deps** if standard install fails
3. **Falls back to yarn** if available
4. **Provides manual instructions** if all methods fail

### System Requirements
- **Node.js 18+** (automatically checked)
- **npm** (automatically checked)
- **Git** (for repository initialization)
- **Docker** (for MariaDB option)

### Port Conflicts
The generator automatically detects and resolves port conflicts, but if you encounter issues:

```bash
# Check what's using a port
lsof -i :3306
lsof -i :8080

# Stop conflicting services
sudo systemctl stop mysql  # Linux
brew services stop mysql   # macOS
```

### Docker Issues
```bash
# Clean up Docker containers
docker-compose down
docker system prune

# Restart Docker Desktop (macOS/Windows)
# Or restart Docker service (Linux)
```

## 🎯 Perfect For

- 🚀 **Rapid Prototyping** - Get ideas running fast with admin access
- 🧪 **Testing Concepts** - Quick validation with user management
- 📱 **Mobile Apps** - iOS and Android with authentication
- 🌐 **Web Applications** - Modern React apps with admin panels
- 🏢 **Client Projects** - Professional structure with user roles
- 🎓 **Learning** - Best practices with real authentication systems

## 📝 Example Usage

```bash
# Create a new web app with MariaDB and admin user
create-project
# Choose: Web Application
# Choose: MariaDB + phpMyAdmin (Docker)
# Choose: Yes (Git repository)
# Choose: Yes (Admin user)
# Name: my-awesome-app
# Location: ./projects
# Admin: John Doe, john@example.com, password123

cd projects/my-awesome-app
docker-compose up -d  # Start database (admin user auto-created)
npm run dev          # Start development server

# Admin user is ready to use:
# Email: john@example.com
# Password: password123
# Role: admin
```

## 🔄 Adding Features

Start minimal, add what you need:

- **Authentication UI**: Login/register components
- **State Management**: Zustand, Redux, Context with user state
- **UI Libraries**: Tailwind, Styled Components, NativeBase
- **Authorization**: Role-based access control
- **Testing**: Jest, React Testing Library
- **Deployment**: Vercel, Netlify, Expo EAS

## 🤝 Contributing

Want to improve the generator? 

1. Fork this repository
2. Add your improvements
3. Test with different configurations
4. Submit a pull request

---

**🎉 Happy coding! Build amazing things quickly with proper user management!**