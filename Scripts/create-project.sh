#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    🚀 PROJECT GENERATOR 🚀                   ║"
echo "║              Quick setup for React/TypeScript projects       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to check system requirements
check_requirements() {
    echo -e "${GREEN}🔍 Checking system requirements...${NC}"
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js is not installed. Please install Node.js first.${NC}"
        echo -e "${YELLOW}Visit: https://nodejs.org${NC}"
        exit 1
    fi
    
    NODE_VERSION=$(node --version | cut -d'v' -f2)
    MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1)
    
    if [ "$MAJOR_VERSION" -lt 18 ]; then
        echo -e "${RED}❌ Node.js version $NODE_VERSION is too old. Please upgrade to Node.js 18 or higher.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Node.js $NODE_VERSION${NC}"
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}❌ npm is not installed.${NC}"
        exit 1
    fi
    
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✅ npm $NPM_VERSION${NC}"
    
    # Check if Expo CLI is available (install if needed)
    if ! command -v npx &> /dev/null; then
        echo -e "${RED}❌ npx is not available.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ npx available${NC}"
}

# Function to prompt for input with validation
prompt_input() {
    local prompt="$1"
    local var_name="$2"
    local validation="$3"
    
    while true; do
        echo -e "${YELLOW}$prompt${NC}"
        read -r input
        
        if [[ -n "$input" ]]; then
            if [[ -z "$validation" ]] || eval "$validation"; then
                eval "$var_name='$input'"
                break
            else
                echo -e "${RED}Invalid input. Please try again.${NC}"
            fi
        else
            echo -e "${RED}Input cannot be empty. Please try again.${NC}"
        fi
    done
}

# Check system requirements first
check_requirements

# Get project details
prompt_input "📁 Where do you want to create the project? (use '.' for current directory or provide full path):" "PROJECT_PATH" ""
prompt_input "📝 What's the name of your project?" "PROJECT_NAME" '[[ "$input" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]'

# Resolve project path
if [[ "$PROJECT_PATH" == "." ]]; then
    PROJECT_FULL_PATH="$(pwd)/$PROJECT_NAME"
else
    PROJECT_FULL_PATH="$PROJECT_PATH/$PROJECT_NAME"
fi

# Check if directory already exists
if [[ -d "$PROJECT_FULL_PATH" ]]; then
    echo -e "${RED}❌ Directory $PROJECT_FULL_PATH already exists!${NC}"
    exit 1
fi

# Project type selection
PROJECT_TYPE_OPTIONS=("Web Application (with directory routing)" "Mobile App (React Native)")
echo -e "${YELLOW}🎯 What type of project do you want to create?${NC}"
for i in "${!PROJECT_TYPE_OPTIONS[@]}"; do
    echo "  $((i+1)). ${PROJECT_TYPE_OPTIONS[i]}"
done

while true; do
    echo -e "${YELLOW}Enter your choice (1-${#PROJECT_TYPE_OPTIONS[@]}): ${NC}"
    read -r choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#PROJECT_TYPE_OPTIONS[@]}" ]; then
        PROJECT_TYPE="${PROJECT_TYPE_OPTIONS[$((choice-1))]}"
        break
    else
        echo -e "${RED}Invalid choice. Please enter a number between 1 and ${#PROJECT_TYPE_OPTIONS[@]}.${NC}"
    fi
done

# Database selection
DATABASE_OPTIONS=("None (no database)" "Firebase (cloud database)" "MariaDB + phpMyAdmin (Docker)" "Supabase (cloud database)")
echo -e "${YELLOW}🗄️ Which database setup do you want?${NC}"
for i in "${!DATABASE_OPTIONS[@]}"; do
    echo "  $((i+1)). ${DATABASE_OPTIONS[i]}"
done

while true; do
    echo -e "${YELLOW}Enter your choice (1-${#DATABASE_OPTIONS[@]}): ${NC}"
    read -r choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#DATABASE_OPTIONS[@]}" ]; then
        DATABASE_TYPE="${DATABASE_OPTIONS[$((choice-1))]}"
        break
    else
        echo -e "${RED}Invalid choice. Please enter a number between 1 and ${#DATABASE_OPTIONS[@]}.${NC}"
    fi
done

# Git repository option
echo -e "${YELLOW}🔧 Do you want to initialize a Git repository? (Y/n): ${NC}"
read -r git_init
if [[ ! "$git_init" =~ ^[Nn]$ ]]; then
    INIT_GIT=true
else
    INIT_GIT=false
fi

# Admin user creation (only if database is selected)
CREATE_ADMIN=false
if [[ "$DATABASE_TYPE" != "None (no database)" ]]; then
    echo -e "${YELLOW}👤 Do you want to create an admin user? (Y/n): ${NC}"
    read -r create_admin
    
    if [[ ! "$create_admin" =~ ^[Nn]$ ]]; then
        CREATE_ADMIN=true
        
        # Get admin details
        prompt_input "📝 Admin name:" "ADMIN_NAME" ""
        prompt_input "📧 Admin email:" "ADMIN_EMAIL" '[[ "$input" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]'
        
        # Get password with confirmation
        while true; do
            echo -e "${YELLOW}🔒 Admin password (min 8 characters):${NC}"
            read -s ADMIN_PASSWORD
            echo
            
            if [[ ${#ADMIN_PASSWORD} -lt 8 ]]; then
                echo -e "${RED}Password must be at least 8 characters long.${NC}"
                continue
            fi
            
            echo -e "${YELLOW}🔒 Confirm admin password:${NC}"
            read -s ADMIN_PASSWORD_CONFIRM
            echo
            
            if [[ "$ADMIN_PASSWORD" == "$ADMIN_PASSWORD_CONFIRM" ]]; then
                break
            else
                echo -e "${RED}Passwords don't match. Please try again.${NC}"
            fi
        done
        
        echo -e "${GREEN}✅ Admin user details captured${NC}"
    else
        CREATE_ADMIN=false
    fi
fi

echo ""
echo -e "${GREEN}📋 Project Configuration:${NC}"
echo -e "  Name: ${BLUE}$PROJECT_NAME${NC}"
echo -e "  Path: ${BLUE}$PROJECT_FULL_PATH${NC}"
echo -e "  Type: ${BLUE}$PROJECT_TYPE${NC}"
echo -e "  Database: ${BLUE}$DATABASE_TYPE${NC}"
echo -e "  Git Repository: ${BLUE}$([ "$INIT_GIT" = true ] && echo "Yes" || echo "No")${NC}"
echo ""

# Confirm
echo -e "${YELLOW}Do you want to proceed? (y/N): ${NC}"
read -r confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Setup cancelled.${NC}"
    exit 0
fi

# Create project directory
echo -e "${GREEN}📁 Creating project directory...${NC}"
mkdir -p "$PROJECT_FULL_PATH"
cd "$PROJECT_FULL_PATH"

# Initialize Git repository if requested
if [ "$INIT_GIT" = true ]; then
    echo -e "${GREEN}🔧 Initializing Git repository...${NC}"
    git init
    
    # Check if user has git config set
    if ! git config user.name > /dev/null 2>&1 || ! git config user.email > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Git user not configured. Setting up...${NC}"
        
        # Prompt for git config if not set
        if ! git config user.name > /dev/null 2>&1; then
            prompt_input "📝 Enter your Git username:" "GIT_USERNAME" ""
            git config user.name "$GIT_USERNAME"
        fi
        
        if ! git config user.email > /dev/null 2>&1; then
            prompt_input "📧 Enter your Git email:" "GIT_EMAIL" ""
            git config user.email "$GIT_EMAIL"
        fi
    fi
fi

# Initialize project based on type
if [[ "$PROJECT_TYPE" == "Web Application (with directory routing)" ]]; then
    echo -e "${GREEN}🌐 Setting up Web Application...${NC}"
    
    # Create package.json for web with better dependency management
    cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "main": "expo-router/entry",
  "scripts": {
    "start": "expo start --web",
    "dev": "expo start --web",
    "build": "expo export --platform web",
    "preview": "npx serve dist",
    "format": "prettier --write .",
    "typecheck": "tsc --noEmit",
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx"
  },
  "dependencies": {
    "expo": "~51.0.28",
    "expo-linking": "~6.3.1",
    "expo-router": "~3.5.23",
    "expo-status-bar": "~1.12.1",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "react-native": "0.74.5",
    "react-native-web": "~0.19.10",
    "@tanstack/react-query": "^5.51.23"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "@types/react": "~18.2.45",
    "eslint": "^8.57.0",
    "eslint-config-prettier": "^9.1.0",
    "prettier": "^3.3.3",
    "typescript": "~5.3.3"
  },
  "private": true
}
EOF

    # Create app.json for web
    cat > app.json << EOF
{
  "expo": {
    "name": "$PROJECT_NAME",
    "slug": "$PROJECT_NAME",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "userInterfaceStyle": "light",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#ffffff"
    },
    "assetBundlePatterns": [
      "**/*"
    ],
    "ios": {
      "supportsTablet": true
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png",
        "backgroundColor": "#FFFFFF"
      }
    },
    "web": {
      "favicon": "./assets/favicon.png",
      "bundler": "metro"
    }
  }
}
EOF

    # Create web folder structure
    mkdir -p app src/{components,hooks,lib,types,api} assets
    
    # Create root layout for web
    cat > app/_layout.tsx << 'EOF'
import { Stack } from 'expo-router';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { StatusBar } from 'expo-status-bar';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      retry: 1,
    },
  },
});

export default function RootLayout() {
  return (
    <QueryClientProvider client={queryClient}>
      <StatusBar style="auto" />
      <Stack 
        screenOptions={{ 
          headerShown: true,
          headerStyle: {
            backgroundColor: '#f8f9fa',
          },
          headerTintColor: '#333',
          headerTitleStyle: {
            fontWeight: '600',
          },
        }} 
      />
    </QueryClientProvider>
  );
}
EOF

    # Create home page for web
    cat > app/index.tsx << 'EOF'
import { View, Text, StyleSheet } from 'react-native';
import { Link } from 'expo-router';

export default function Home() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome to Your Web App</Text>
      <Text style={styles.subtitle}>Built with directory routing</Text>
      
      <Link href="/about" style={styles.link}>
        <Text style={styles.linkText}>Go to About →</Text>
      </Link>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
    backgroundColor: '#f8f9fa',
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#333',
    textAlign: 'center',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 32,
  },
  link: {
    padding: 12,
    backgroundColor: '#007AFF',
    borderRadius: 8,
  },
  linkText: {
    color: 'white',
    fontWeight: '600',
  },
});
EOF

    # Create example about page
    cat > app/about.tsx << 'EOF'
import { View, Text, StyleSheet } from 'react-native';
import { Link } from 'expo-router';

export default function About() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>About Page</Text>
      <Text style={styles.description}>
        This page was created by adding app/about.tsx
      </Text>
      <Text style={styles.route}>Route: /about</Text>
      
      <Link href="/" style={styles.link}>
        <Text style={styles.linkText}>← Back to Home</Text>
      </Link>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
    backgroundColor: '#f8f9fa',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 16,
  },
  description: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 8,
  },
  route: {
    fontSize: 14,
    color: '#007AFF',
    fontFamily: 'monospace',
    marginBottom: 32,
  },
  link: {
    padding: 12,
    backgroundColor: '#007AFF',
    borderRadius: 8,
  },
  linkText: {
    color: 'white',
    fontWeight: '600',
  },
});
EOF

else
    echo -e "${GREEN}📱 Setting up Mobile App...${NC}"
    
    # Create package.json for mobile app with better dependency management
    cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "main": "expo-router/entry",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web",
    "format": "prettier --write .",
    "typecheck": "tsc --noEmit",
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx"
  },
  "dependencies": {
    "expo": "~51.0.28",
    "expo-linking": "~6.3.1",
    "expo-router": "~3.5.23",
    "expo-status-bar": "~1.12.1",
    "react": "18.2.0",
    "react-native": "0.74.5",
    "react-native-safe-area-context": "4.10.5",
    "react-native-screens": "3.31.1",
    "@tanstack/react-query": "^5.51.23",
    "@react-navigation/native": "^6.1.18",
    "@react-navigation/native-stack": "^6.10.1"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0",
    "@types/react": "~18.2.45",
    "eslint": "^8.57.0",
    "eslint-config-prettier": "^9.1.0",
    "prettier": "^3.3.3",
    "typescript": "~5.3.3"
  },
  "private": true
}
EOF

    # Create app.json for mobile
    cat > app.json << EOF
{
  "expo": {
    "name": "$PROJECT_NAME",
    "slug": "$PROJECT_NAME",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "userInterfaceStyle": "light",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#ffffff"
    },
    "assetBundlePatterns": [
      "**/*"
    ],
    "ios": {
      "supportsTablet": true
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png",
        "backgroundColor": "#FFFFFF"
      }
    }
  }
}
EOF

    # Create mobile folder structure
    mkdir -p src/{components,hooks,lib,types,screens,navigation,api} assets
    
    # Create App.tsx for mobile (no directory routing)
    cat > App.tsx << 'EOF'
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { StatusBar } from 'expo-status-bar';

import HomeScreen from './src/screens/HomeScreen';
import AboutScreen from './src/screens/AboutScreen';

const Stack = createNativeStackNavigator();

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      retry: 1,
    },
  },
});

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <NavigationContainer>
        <StatusBar style="auto" />
        <Stack.Navigator
          initialRouteName="Home"
          screenOptions={{
            headerStyle: {
              backgroundColor: '#f8f9fa',
            },
            headerTintColor: '#333',
            headerTitleStyle: {
              fontWeight: '600',
            },
          }}
        >
          <Stack.Screen name="Home" component={HomeScreen} />
          <Stack.Screen name="About" component={AboutScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    </QueryClientProvider>
  );
}
EOF

    # Create screens
    cat > src/screens/HomeScreen.tsx << 'EOF'
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function HomeScreen({ navigation }: any) {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>Welcome to Your Mobile App</Text>
        <Text style={styles.subtitle}>Built with React Native</Text>
        
        <TouchableOpacity 
          style={styles.button}
          onPress={() => navigation.navigate('About')}
        >
          <Text style={styles.buttonText}>Go to About →</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  content: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#333',
    textAlign: 'center',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 32,
  },
  button: {
    padding: 12,
    backgroundColor: '#007AFF',
    borderRadius: 8,
  },
  buttonText: {
    color: 'white',
    fontWeight: '600',
  },
});
EOF

    cat > src/screens/AboutScreen.tsx << 'EOF'
import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function AboutScreen({ navigation }: any) {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>About Screen</Text>
        <Text style={styles.description}>
          This is a traditional React Native screen
        </Text>
        
        <TouchableOpacity 
          style={styles.button}
          onPress={() => navigation.goBack()}
        >
          <Text style={styles.buttonText}>← Back to Home</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  content: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 16,
  },
  description: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 32,
  },
  button: {
    padding: 12,
    backgroundColor: '#007AFF',
    borderRadius: 8,
  },
  buttonText: {
    color: 'white',
    fontWeight: '600',
  },
});
EOF
fi

# Create common files
echo -e "${GREEN}📝 Creating common project files...${NC}"

# Create TypeScript config
cat > tsconfig.json << 'EOF'
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "moduleResolution": "bundler"
  }
}
EOF

# Create basic types
cat > src/types/index.ts << 'EOF'
export interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface ApiResponse<T> {
  data: T;
  message: string;
  success: boolean;
}
EOF

# Create constants
cat > src/lib/constants.ts << 'EOF'
export const APP_CONFIG = {
  name: process.env.EXPO_PUBLIC_APP_NAME || 'My App',
  version: '1.0.0',
} as const;

export const API_CONFIG = {
  baseUrl: process.env.EXPO_PUBLIC_API_URL || 'http://localhost:3000',
  timeout: 10000,
} as const;

export const COLORS = {
  primary: '#007AFF',
  secondary: '#5856D6',
  success: '#34C759',
  warning: '#FF9500',
  error: '#FF3B30',
  background: '#f8f9fa',
  surface: '#ffffff',
  text: '#333333',
  textSecondary: '#666666',
} as const;
EOF

# Create utility functions
cat > src/lib/utils.ts << 'EOF'
export function formatDate(date: Date): string {
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(date);
}

export function generateId(): string {
  return Math.random().toString(36).substring(2) + Date.now().toString(36);
}

export function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
EOF

# Create API utilities
cat > src/api/client.ts << 'EOF'
import { API_CONFIG } from '../lib/constants';

class ApiClient {
  private baseUrl: string;
  private timeout: number;

  constructor() {
    this.baseUrl = API_CONFIG.baseUrl;
    this.timeout = API_CONFIG.timeout;
  }

  async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseUrl}${endpoint}`;
    
    const config: RequestInit = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  async get<T>(endpoint: string): Promise<T> {
    return this.request<T>(endpoint, { method: 'GET' });
  }

  async post<T>(endpoint: string, data: any): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  async put<T>(endpoint: string, data: any): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  async delete<T>(endpoint: string): Promise<T> {
    return this.request<T>(endpoint, { method: 'DELETE' });
  }
}

export const apiClient = new ApiClient();
EOF

# Create index files
cat > src/components/index.ts << 'EOF'
// Export your components here
// Example: export { Button } from './Button';
EOF

cat > src/hooks/index.ts << 'EOF'
// Export your custom hooks here
// Example: export { useAuth } from './useAuth';
EOF

# Create basic .env template
cat > .env.example << 'EOF'
# App Configuration
EXPO_PUBLIC_APP_NAME=My App
EXPO_PUBLIC_API_URL=http://localhost:3000

# Database Configuration (uncomment based on your choice)
# DATABASE_URL=your_database_url_here

# Firebase (if using Firebase)
# EXPO_PUBLIC_FIREBASE_API_KEY=your_api_key
# EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
# EXPO_PUBLIC_FIREBASE_PROJECT_ID=your_project_id

# Supabase (if using Supabase)
# EXPO_PUBLIC_SUPABASE_URL=your_supabase_url
# EXPO_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
EOF

# Copy to actual .env
cp .env.example .env

# Handle database setup
case "$DATABASE_TYPE" in
    "Firebase (cloud database)")
        echo -e "${GREEN}🔥 Setting up Firebase...${NC}"
        
        # Add Firebase dependencies
        sed -i '' 's/"@tanstack\/react-query": "^5.51.23"/"@tanstack\/react-query": "^5.51.23",\
    "firebase": "^10.12.4"/' package.json
        
        # Create Firebase config
        cat > src/lib/firebase.ts << 'EOF'
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
  apiKey: process.env.EXPO_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.EXPO_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.EXPO_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.EXPO_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.EXPO_PUBLIC_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
EOF

        # Create Firebase admin setup script if admin user requested
        if [ "$CREATE_ADMIN" = true ]; then
            cat > scripts/create-admin.js << EOF
// Firebase Admin User Creation Script
// Run this after setting up Firebase: node scripts/create-admin.js

import { initializeApp } from 'firebase/app';
import { getAuth, createUserWithEmailAndPassword, updateProfile } from 'firebase/auth';
import { getFirestore, doc, setDoc } from 'firebase/firestore';

// Your Firebase config (update with your actual config)
const firebaseConfig = {
  apiKey: process.env.EXPO_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.EXPO_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.EXPO_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.EXPO_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.EXPO_PUBLIC_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

async function createAdminUser() {
  try {
    // Create admin user
    const userCredential = await createUserWithEmailAndPassword(
      auth, 
      '$ADMIN_EMAIL', 
      '$ADMIN_PASSWORD'
    );
    
    const user = userCredential.user;
    
    // Update profile
    await updateProfile(user, {
      displayName: '$ADMIN_NAME'
    });
    
    // Add admin role to Firestore
    await setDoc(doc(db, 'users', user.uid), {
      name: '$ADMIN_NAME',
      email: '$ADMIN_EMAIL',
      role: 'admin',
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    
    console.log('✅ Admin user created successfully!');
    console.log('Email:', '$ADMIN_EMAIL');
    console.log('Name:', '$ADMIN_NAME');
    console.log('UID:', user.uid);
    
  } catch (error) {
    console.error('❌ Error creating admin user:', error);
  }
}

createAdminUser();
EOF

            mkdir -p scripts
            
            echo -e "${GREEN}📝 Admin user script created at scripts/create-admin.js${NC}"
        fi

        echo -e "${YELLOW}📝 Don't forget to:${NC}"
        echo "  1. Create a Firebase project at https://console.firebase.google.com"
        echo "  2. Update the .env file with your Firebase config"
        if [ "$CREATE_ADMIN" = true ]; then
            echo "  3. Run: node scripts/create-admin.js (after Firebase setup)"
        fi
        ;;
        
    "MariaDB + phpMyAdmin (Docker)")
        echo -e "${GREEN}🐳 Setting up MariaDB + phpMyAdmin with Docker...${NC}"
        
        # Function to check if port is available
        check_port() {
            local port=$1
            if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
                return 1  # Port is in use
            else
                return 0  # Port is available
            fi
        }
        
        # Find available ports
        DB_PORT=3306
        PHPMYADMIN_PORT=8080
        
        # Check and find alternative port for MariaDB
        if ! check_port $DB_PORT; then
            echo -e "${YELLOW}⚠️  Port $DB_PORT is already in use, finding alternative...${NC}"
            for port in 3307 3308 3309 3310; do
                if check_port $port; then
                    DB_PORT=$port
                    echo -e "${GREEN}✅ Using port $DB_PORT for MariaDB${NC}"
                    break
                fi
            done
        fi
        
        # Check and find alternative port for phpMyAdmin
        if ! check_port $PHPMYADMIN_PORT; then
            echo -e "${YELLOW}⚠️  Port $PHPMYADMIN_PORT is already in use, finding alternative...${NC}"
            for port in 8081 8082 8083 8084; do
                if check_port $port; then
                    PHPMYADMIN_PORT=$port
                    echo -e "${GREEN}✅ Using port $PHPMYADMIN_PORT for phpMyAdmin${NC}"
                    break
                fi
            done
        fi
        
        # Create Docker Compose file with dynamic ports
        cat > docker-compose.yml << EOF
services:
  mariadb:
    image: mariadb:10.11
    container_name: ${PROJECT_NAME}_mariadb
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: ${PROJECT_NAME}
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppassword
    ports:
      - "${DB_PORT}:3306"
    volumes:
      - mariadb_data:/var/lib/mysql
      - ./database/init:/docker-entrypoint-initdb.d
    networks:
      - app-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:5.2
    container_name: ${PROJECT_NAME}_phpmyadmin
    restart: unless-stopped
    environment:
      PMA_HOST: mariadb
      PMA_PORT: 3306
      PMA_USER: root
      PMA_PASSWORD: rootpassword
    ports:
      - "${PHPMYADMIN_PORT}:80"
    depends_on:
      - mariadb
    networks:
      - app-network

volumes:
  mariadb_data:

networks:
  app-network:
    driver: bridge
EOF

        # Create database init directory
        mkdir -p database/init
        
        # Create initial SQL file with admin user support
        cat > database/init/01-init.sql << EOF
-- Initial database setup
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (name, email, password_hash, role) VALUES 
('John Doe', 'john@example.com', 'sample_hash_1', 'user'),
('Jane Smith', 'jane@example.com', 'sample_hash_2', 'user');

EOF

        # Add admin user if requested
        if [ "$CREATE_ADMIN" = true ]; then
            # Generate a simple hash (in production, use proper bcrypt)
            ADMIN_HASH=$(echo -n "$ADMIN_PASSWORD" | openssl dgst -sha256 | awk '{print $2}')
            
            cat >> database/init/01-init.sql << EOF
-- Insert admin user
INSERT INTO users (name, email, password_hash, role) VALUES 
('$ADMIN_NAME', '$ADMIN_EMAIL', '$ADMIN_HASH', 'admin');
EOF
        fi

        # Update .env with database config using dynamic ports
        cat >> .env << EOF

# MariaDB Configuration
DATABASE_URL=mysql://appuser:apppassword@localhost:${DB_PORT}/${PROJECT_NAME}
DB_HOST=localhost
DB_PORT=${DB_PORT}
DB_NAME=${PROJECT_NAME}
DB_USER=appuser
DB_PASSWORD=apppassword
EOF

        echo -e "${YELLOW}📝 Database setup complete!${NC}"
        echo "  • Run: docker-compose up -d"
        echo "  • phpMyAdmin: http://localhost:${PHPMYADMIN_PORT}"
        echo "  • Database: localhost:${DB_PORT}"
        ;;
        
    "Supabase (cloud database)")
        echo -e "${GREEN}⚡ Setting up Supabase...${NC}"
        
        # Add Supabase dependencies
        sed -i '' 's/"@tanstack\/react-query": "^5.51.23"/"@tanstack\/react-query": "^5.51.23",\
    "@supabase\/supabase-js": "^2.45.1"/' package.json
        
        # Create Supabase config
        cat > src/lib/supabase.ts << 'EOF'
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
EOF

        # Create Supabase admin setup script if admin user requested
        if [ "$CREATE_ADMIN" = true ]; then
            cat > scripts/create-admin-supabase.js << EOF
// Supabase Admin User Creation Script
// Run this after setting up Supabase: node scripts/create-admin-supabase.js

import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY; // Service role key needed for admin operations

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing Supabase configuration. Please set EXPO_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in .env');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

async function createAdminUser() {
  try {
    // Create admin user
    const { data: authData, error: authError } = await supabase.auth.admin.createUser({
      email: '$ADMIN_EMAIL',
      password: '$ADMIN_PASSWORD',
      email_confirm: true,
      user_metadata: {
        name: '$ADMIN_NAME',
        role: 'admin'
      }
    });

    if (authError) {
      throw authError;
    }

    console.log('✅ Admin user created successfully!');
    console.log('Email:', '$ADMIN_EMAIL');
    console.log('Name:', '$ADMIN_NAME');
    console.log('User ID:', authData.user.id);

    // Create user profile in public.users table (if you have one)
    const { error: profileError } = await supabase
      .from('users')
      .insert([
        {
          id: authData.user.id,
          name: '$ADMIN_NAME',
          email: '$ADMIN_EMAIL',
          role: 'admin',
          is_active: true,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        }
      ]);

    if (profileError) {
      console.warn('⚠️  Could not create user profile (table might not exist):', profileError.message);
    } else {
      console.log('✅ User profile created in users table');
    }

  } catch (error) {
    console.error('❌ Error creating admin user:', error);
  }
}

createAdminUser();
EOF

            # Create SQL migration for users table
            cat > database/supabase-users-table.sql << 'EOF'
-- Create users table for Supabase
-- Run this in your Supabase SQL editor

CREATE TABLE IF NOT EXISTS public.users (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT DEFAULT 'user' CHECK (role IN ('admin', 'user')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own profile" ON public.users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON public.users
    FOR UPDATE USING (auth.uid() = id);

-- Admin policies (you may need to adjust based on your needs)
CREATE POLICY "Admins can view all users" ON public.users
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Create function to handle user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS \$\$
BEGIN
    INSERT INTO public.users (id, email, name)
    VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'name', 'User'));
    RETURN NEW;
END;
\$\$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
EOF

            mkdir -p scripts database
            
            echo -e "${GREEN}📝 Admin user script created at scripts/create-admin-supabase.js${NC}"
            echo -e "${GREEN}📝 SQL migration created at database/supabase-users-table.sql${NC}"
        fi

        echo -e "${YELLOW}📝 Don't forget to:${NC}"
        echo "  1. Create a Supabase project at https://supabase.com"
        echo "  2. Update the .env file with your Supabase URL and anon key"
        if [ "$CREATE_ADMIN" = true ]; then
            echo "  3. Run the SQL in database/supabase-users-table.sql in your Supabase SQL editor"
            echo "  4. Add SUPABASE_SERVICE_ROLE_KEY to .env (from Supabase settings)"
            echo "  5. Run: node scripts/create-admin-supabase.js"
        fi
        ;;
        
    *)
        echo -e "${GREEN}✅ No database setup selected.${NC}"
        ;;
esac

# Create basic assets
mkdir -p assets
echo -e "${GREEN}🎨 Creating placeholder assets...${NC}"

# Create .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Expo
.expo/
dist/
web-build/

# Environment variables
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Database
*.db
*.sqlite

# Build
build/
EOF

# Create README with troubleshooting
cat > README.md << EOF
# $PROJECT_NAME

A $PROJECT_TYPE built with React, TypeScript, and Expo.

## 🚀 Quick Start

1. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

2. Set up environment variables:
   \`\`\`bash
   cp .env.example .env
   # Edit .env with your configuration
   \`\`\`

EOF

if [[ "$DATABASE_TYPE" == "MariaDB + phpMyAdmin (Docker)" ]]; then
    cat >> README.md << 'EOF'
3. Start the database:
   ```bash
   docker-compose up -d
   ```

4. Start the development server:
EOF
else
    cat >> README.md << 'EOF'
3. Start the development server:
EOF
fi

if [[ "$PROJECT_TYPE" == "Web Application (with directory routing)" ]]; then
    cat >> README.md << 'EOF'
   ```bash
   npm run dev
   ```

## 📁 Directory Routing

- `app/index.tsx` → `/` (home page)
- `app/about.tsx` → `/about`
- `app/profile/index.tsx` → `/profile`
- `app/profile/settings.tsx` → `/profile/settings`

Add new pages by creating `.tsx` files in the `app/` directory!
EOF
else
    cat >> README.md << 'EOF'
   ```bash
   npm start
   ```

Then:
- Press `i` for iOS simulator
- Press `a` for Android emulator
- Press `w` for web

## 📱 Navigation

This app uses React Navigation. Add new screens in `src/screens/` and update the navigator in `App.tsx`.
EOF
fi

cat >> README.md << 'EOF'

## 🚨 Troubleshooting

### npm install issues
If you encounter issues with `npm install`:

1. **Check Node.js version**:
   ```bash
   node --version  # Should be 18.x or higher
   ```

2. **Clear npm cache**:
   ```bash
   npm cache clean --force
   ```

3. **Delete node_modules and reinstall**:
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```

4. **Use exact versions**:
   ```bash
   npm ci  # Uses exact versions from package-lock.json
   ```

### Web development issues
If you get "react-dom" missing error:

1. **Install react-dom**:
   ```bash
   npx expo install react-dom
   ```

2. **Or install manually**:
   ```bash
   npm install react-dom@18.2.0
   ```

### Expo CLI issues
If Expo commands don't work:

1. **Install Expo CLI globally**:
   ```bash
   npm install -g @expo/cli
   ```

2. **Or use npx**:
   ```bash
   npx expo start
   ```

3. **For web development**:
   ```bash
   npx expo start --web
   ```

### Port conflicts
If you get "port already in use" errors:

1. **Check what's using the port**:
   ```bash
   lsof -i :3000  # or whatever port
   ```

2. **Kill the process**:
   ```bash
   kill -9 <PID>
   ```

3. **Use a different port**:
   ```bash
   npm run dev -- --port 3001
   ```
EOF

if [[ "$DATABASE_TYPE" != "None (no database)" ]]; then
    cat >> README.md << EOF

## 🗄️ Database

This project is configured with **$DATABASE_TYPE**.

EOF

    if [ "$CREATE_ADMIN" = true ]; then
        cat >> README.md << EOF
### 👤 Admin User

An admin user has been configured:
- **Email**: $ADMIN_EMAIL
- **Name**: $ADMIN_NAME
- **Role**: admin

EOF
    fi

    case "$DATABASE_TYPE" in
        "Firebase (cloud database)")
            cat >> README.md << 'EOF'
### Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Enable Firestore Database
4. Copy your config to `.env`

### Usage
```typescript
import { db } from './src/lib/firebase';
import { collection, addDoc } from 'firebase/firestore';

// Add a document
await addDoc(collection(db, 'users'), {
  name: 'John Doe',
  email: 'john@example.com'
});
```
EOF
            ;;
        "MariaDB + phpMyAdmin (Docker)")
            cat >> README.md << EOF
### MariaDB + phpMyAdmin Setup
1. Make sure Docker is installed
2. Run: \`docker-compose up -d\`
3. Access phpMyAdmin at http://localhost:${PHPMYADMIN_PORT:-8080}
   - Username: \`root\`
   - Password: \`rootpassword\`

### Database Access
- Host: \`localhost\`
- Port: \`${DB_PORT:-3306}\`
- Database: \`${PROJECT_NAME}\`
- Username: \`appuser\`
- Password: \`apppassword\`
EOF
            ;;
        "Supabase (cloud database)")
            cat >> README.md << 'EOF'
### Supabase Setup
1. Go to [Supabase](https://supabase.com)
2. Create a new project
3. Copy your URL and anon key to `.env`

### Usage
```typescript
import { supabase } from './src/lib/supabase';

// Insert data
const { data, error } = await supabase
  .from('users')
  .insert([{ name: 'John Doe', email: 'john@example.com' }]);
```
EOF
            ;;
    esac
fi

if [ "$INIT_GIT" = true ]; then
    cat >> README.md << 'EOF'

## 🔧 Git Repository

This project is initialized with Git. To connect to a remote repository:

```bash
git remote add origin <your-repository-url>
git branch -M main
git push -u origin main
```
EOF
fi

cat >> README.md << 'EOF'

## 🎯 Next Steps

1. Update `.env` with your configuration
2. Start building your features in `src/`
3. Add new pages/screens as needed
4. Customize the styling and components

Happy coding! 🎉
EOF

# Install dependencies with better error handling
echo -e "${GREEN}📦 Installing dependencies...${NC}"

# Clear npm cache first
echo -e "${YELLOW}🧹 Clearing npm cache...${NC}"
npm cache clean --force

# Install with verbose output and error handling
echo -e "${YELLOW}📥 Running npm install...${NC}"
if npm install --verbose; then
    echo -e "${GREEN}✅ Dependencies installed successfully!${NC}"
    
    # For web projects, ensure react-dom is properly installed
    if [[ "$PROJECT_TYPE" == "Web Application (with directory routing)" ]]; then
        echo -e "${YELLOW}🌐 Verifying web dependencies...${NC}"
        if ! npm list react-dom > /dev/null 2>&1; then
            echo -e "${YELLOW}📥 Installing react-dom for web support...${NC}"
            npx expo install react-dom
        fi
    fi
else
    echo -e "${RED}❌ npm install failed. Trying alternative approaches...${NC}"
    
    # Try with legacy peer deps
    echo -e "${YELLOW}🔄 Trying with --legacy-peer-deps...${NC}"
    if npm install --legacy-peer-deps; then
        echo -e "${GREEN}✅ Dependencies installed with legacy peer deps!${NC}"
    else
        echo -e "${RED}❌ npm install still failing. Trying yarn...${NC}"
        
        # Try with yarn if available
        if command -v yarn &> /dev/null; then
            echo -e "${YELLOW}🔄 Trying with yarn...${NC}"
            if yarn install; then
                echo -e "${GREEN}✅ Dependencies installed with yarn!${NC}"
            else
                echo -e "${RED}❌ Both npm and yarn failed. Manual intervention required.${NC}"
                echo -e "${YELLOW}Please try:${NC}"
                echo "  1. cd $PROJECT_FULL_PATH"
                echo "  2. rm -rf node_modules package-lock.json"
                echo "  3. npm install --force"
            fi
        else
            echo -e "${RED}❌ npm install failed and yarn is not available.${NC}"
            echo -e "${YELLOW}Please try manually:${NC}"
            echo "  1. cd $PROJECT_FULL_PATH"
            echo "  2. rm -rf node_modules package-lock.json"
            echo "  3. npm install --force"
        fi
    fi
fi

# Git operations
if [ "$INIT_GIT" = true ]; then
    echo -e "${GREEN}🔧 Setting up Git repository...${NC}"
    
    # Add all files to git
    git add .
    
    # Create initial commit
    git commit -m "🎉 Initial commit

✨ Features:
- $PROJECT_TYPE setup
- TypeScript configuration
- $DATABASE_TYPE integration
- Environment variables configured
- Project structure established

Generated with Project Generator 🚀"
    
    echo -e "${GREEN}✅ Git repository initialized with initial commit${NC}"
fi

# Final success message
echo ""
echo -e "${GREEN}🎉 Project created successfully!${NC}"
echo ""
echo -e "${BLUE}📁 Project location: ${PROJECT_FULL_PATH}${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. cd $PROJECT_FULL_PATH"

if [[ "$DATABASE_TYPE" == "MariaDB + phpMyAdmin (Docker)" ]]; then
    echo "  2. docker-compose up -d  # Start database"
    echo "  3. npm run dev           # Start development server"
    echo ""
    echo -e "${GREEN}🗄️ Database Access:${NC}"
    echo "  • phpMyAdmin: http://localhost:${PHPMYADMIN_PORT:-8080}"
    echo "  • Database: localhost:${DB_PORT:-3306}"
    echo "  • Username: appuser / Password: apppassword"
else
    echo "  2. npm run dev           # Start development server"
fi

if [ "$INIT_GIT" = true ]; then
    echo ""
    echo -e "${GREEN}🔧 Git Repository Ready!${NC}"
    echo "  • Repository initialized with initial commit"
    echo "  • To connect to remote: git remote add origin <url>"
    echo "  • To push: git push -u origin main"
fi

if [ "$CREATE_ADMIN" = true ]; then
    echo ""
    echo -e "${GREEN}👤 Admin User Configured!${NC}"
    echo "  • Email: $ADMIN_EMAIL"
    echo "  • Name: $ADMIN_NAME"
    echo "  • Role: admin"
    
    case "$DATABASE_TYPE" in
        "Firebase (cloud database)")
            echo "  • Run: node scripts/create-admin.js (after Firebase setup)"
            ;;
        "MariaDB + phpMyAdmin (Docker)")
            echo "  • Admin user will be created when Docker starts"
            ;;
        "Supabase (cloud database)")
            echo "  • Run SQL migration, then: node scripts/create-admin-supabase.js"
            ;;
    esac
fi

echo ""
echo -e "${GREEN}✨ Happy coding! ✨${NC}"