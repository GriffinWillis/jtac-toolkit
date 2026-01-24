/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}"
  ],
  theme: {
    extend: {
      colors: {
        // Dark gray/black palette for JTAC app
        dark: {
          50: '#f9fafb',   // Lightest (for contrast)
          100: '#f3f4f6',
          200: '#e5e7eb',
          300: '#d1d5db',
          400: '#9ca3af',
          500: '#6b7280',   // Medium gray
          600: '#4b5563',   // Dark gray
          700: '#374151',   // Darker gray
          800: '#1f2937',   // Very dark gray
          900: '#111827',   // Almost black
          950: '#030712',   // Near black
        },
        // Optional accent color (subtle, JTAC-appropriate)
        accent: {
          DEFAULT: '#3b82f6', // Subtle blue for highlights
          light: '#60a5fa',
          dark: '#2563eb',
        }
      },
      fontFamily: {
        sans: ['system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
      },
    },
  },
  plugins: [],
}