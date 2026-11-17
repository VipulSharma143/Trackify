// Lets the web build (Vite) import image files as URL strings.
declare module '*.png' {
  const url: string;
  export default url;
}
